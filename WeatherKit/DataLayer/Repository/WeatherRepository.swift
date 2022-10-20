//
//  WeatherRepository.swift
//  WeatherKit
//
//  Created by Павел Барташов on 24.09.2022.
//

import CoreData
import Combine

//https://www.userdesk.io/blog/repository-pattern-using-core-data-and-swift/

/// Protocol that describes a Weather repository.
public protocol WeatherRepositoryProtocol {
    /// Get a Weather using a predicate
    func getWeather(predicate: NSPredicate?) async throws -> [Weather]
    /// Creates a Weather on the persistance layer.
    func create(weather: Weather) async throws
    /// Deletes a Weather from the persistance layer.
    func delete(weather: Weather) async throws
    /// Saves changes to Repository.
    func saveChanges() async throws
    /// Current, hourly and daily weathers publisher
    var weathersPublisher: AnyPublisher<[WeatherType: [Weather]], Never> { get }
    /// Weaher pack publisher
    var weatherPackPublisher: AnyPublisher<WeatherPack, Never> { get }
    /// Starts fetching weather for provided location within provided date interval
    func startFetchingWeather(for location: WeatherLocation, dateInterval: DateInterval) async throws
    /// Fetches current and hourly weather for provided location
    func fetchCurrentDayWeatherFromAPI(for location: WeatherLocation) async throws
    /// Fetches daily weathers for provided location within provided date interval
    func fetchForecastWeatherFromAPI(for location: WeatherLocation,
                                     dateInterval: DateInterval) async throws
}

/// Weather Repository class.
public final class WeatherRepository {

    // MARK: - Properties

    private let requestManager: RequestManagerProtocol

    /// The Core Data Weather repository.
    private let repository: CoreDataRepository<WeatherEntity>

    /// Current, hourly and daily weathers publisher
    public var weathersPublisher: AnyPublisher<[WeatherType: [Weather]], Never> {
        repository.fetchedResultsPublisher
            .map { weatherEntities in
                Dictionary(grouping: weatherEntities.map { $0.toDomainModel() },
                           by: { $0.weatherType })
            }
            .eraseToAnyPublisher()
    }

    /// Weaher pack publisher
    private let weatherContainerSubject = PassthroughSubject<WeatherPack, Never>()
    public var weatherPackPublisher: AnyPublisher<WeatherPack, Never> {
        weatherContainerSubject.eraseToAnyPublisher()
    }

    // MARK: - LifeCicle

    /// Designated initializer
    /// - Parameter context: The context used for storing and quering Core Data.
    public init(context: NSManagedObjectContext,
                requestManager: RequestManagerProtocol = RequestManager()
    ) {
        self.repository = CoreDataRepository<WeatherEntity>(managedObjectContext: context)
        self.requestManager = requestManager
    }
}

// MARK: - WeatherRepositoryProtocol methods
extension WeatherRepository: WeatherRepositoryProtocol {
    private var mainSortDescriptors: [NSSortDescriptor] {
        [
            NSSortDescriptor(keyPath: \WeatherEntity.weatherTypeRaw, ascending: true),
            NSSortDescriptor(keyPath: \WeatherEntity.datetimeEpoch, ascending: true)
        ]
    }

    private func mapToWeather(weatherEntities: [WeatherEntity]) -> [Weather] {
        weatherEntities.map { $0.toDomainModel() }
    }

    private func getPredicate(latitude: Double,
                              longitude: Double) -> NSPredicate {
        NSPredicate(format: "latitude BETWEEN { %@ , %@ } AND longitude BETWEEN { %@ , %@ }",
                    NSNumber(value: latitude - Constants.locationAccuracy),
                    NSNumber(value: latitude + Constants.locationAccuracy),
                    NSNumber(value: longitude - Constants.locationAccuracy),
                    NSNumber(value: longitude + Constants.locationAccuracy))
    }

    /// Get Weather using a predicate
    public func getWeather(predicate: NSPredicate?) async throws -> [Weather] {
        let weatherEntities = try await repository.get(predicate: predicate, sortDescriptors: nil)
        // Transform the NSManagedObject objects to domain objects
        return mapToWeather(weatherEntities: weatherEntities)
    }

    /// Creates a Weather on the persistance layer.
    public func create(weather: Weather) async throws {
        let weatherEntity = try await repository.create()
        weatherEntity.copyDomainModel(model: weather)
    }

    /// Deletes a Weather from the persistance layer.
    public func delete(weather: Weather) async throws {
        let weatherEntity = try await getWeatherEntity(for: weather)
        await repository.delete(entity: weatherEntity)
    }

    private func getWeatherEntity(for weather: Weather) async throws -> WeatherEntity {
        let weatherEntities = try await getWeatherEntities(for: weather)
        guard let weatherEntity = weatherEntities.first else {
            throw DatabaseError.notFound
        }

        return weatherEntity
    }

    private func getWeatherEntities(for weather: Weather) async throws -> [WeatherEntity] {
        let locationPredicate = getPredicate(latitude: weather.latitude, longitude: weather.longitude)
        let typePredicate = NSPredicate(format: "weatherTypeRaw == %@", NSNumber(value:  weather.weatherType.rawValue))
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [locationPredicate, typePredicate])

        return try await repository.get(predicate: predicate, sortDescriptors: mainSortDescriptors)
    }

    /// Save the NSManagedObjectContext.
    public func saveChanges() async throws {
        try await repository.saveChanges()
    }

    /// Starts fetching weather for provided location within provided date interval
    public func startFetchingWeather(for location: WeatherLocation,
                                     dateInterval: DateInterval
    ) async throws {
        let predicate = getPredicate(latitude: location.latitude, longitude: location.longitude)

        try repository.startFetchingWith(predicate: predicate,
                                         sortDescriptors: mainSortDescriptors)

        try await fetchCurrentDayWeatherFromAPI(for: location)
        try await fetchForecastWeatherFromAPI(for: location, dateInterval: dateInterval)
    }

    /// Fetches current and hourly weathers for provided location
    public func fetchCurrentDayWeatherFromAPI(for location: WeatherLocation) async throws {
        let weatherPack: WeatherPack = try await requestManager.perform(
            WeatherRequest.getCurrentDayWeatherFor(location: location)
        )
        weatherContainerSubject.send(weatherPack)

        guard let todayWeather = weatherPack.days.first else { return }
        if let currentWeather = weatherPack.currentWeather  {
            try await store([currentWeather])
        }

        guard let hourlyWeather = todayWeather.hourlyWeathers else { return }

        try await store(hourlyWeather)
    }

    /// Fetches daily weathers for provided location within provided date interval
    public func fetchForecastWeatherFromAPI(for location: WeatherLocation,
                                            dateInterval: DateInterval
    ) async throws {

        let weatherPack: WeatherPack = try await requestManager.perform(
            WeatherRequest.getForecastWeatherFor(location: location, dateInterval: dateInterval)
        )

        try await store(weatherPack.days)
    }

    private func store(_ weathers: [Weather]) async throws {
        guard let weather = weathers.first else {
            return
        }

        var weatherEntities = try await getWeatherEntities(for: weather)
        
        while weatherEntities.count < weathers.count {
            let newEntity = try await repository.create()
            weatherEntities.append(newEntity)
        }

        for (entity, weather) in zip(weatherEntities, weathers) {
            entity.copyDomainModel(model: weather)
        }

        try await repository.saveChanges()
    }
}
