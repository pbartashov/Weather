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
    /// Creates or Updates existing Weather on the persistance layer.
    func save(weather: Weather) async throws
    /// Deletes a Weather from the persistance layer.
    func delete(weather: Weather) async throws
    /// Saves changes to Repository.
    func saveChanges() async throws



//    var fetchResults: [Weather] { get }

//    var currentWeather: Weather? { get }
//    var hourlyWeather: [Weather] { get }
//    var dailyWeather: [Weather] { get }

//    var currentWeatherPublisher: AnyPublisher<Weather, Never> { get }

    var weathersPublisher: AnyPublisher<[WeatherType: [Weather]], Never> { get }

    //    var fetchedResultsChangedPublisher: AnyPublisher<FetchResultServiceState, Never> { get }
    //    func setupResultsControllerStateChangedHandler(stateChanged:((FetchResultServiceState) -> Void)?)

    func startFetchingWith(predicate: NSPredicate?,
                           sortDescriptors: [NSSortDescriptor]?) throws

    func startFetchingWeather(for location: WeatherLocation) async throws
    //    func fetchCurrentDayWeather(location: WeatherLocation) async throws -> WeatherContainer
}

/// Weather Repository class.
public final class WeatherRepository {

    // MARK: - Properties

    private let requestManager: RequestManagerProtocol

    /// The Core Data Weather repository.
    private let repository: CoreDataRepository<WeatherEntity>


//    @Published public var currentWeather: Weather?
//    @Published public var hourlyWeather: [Weather] = []
//    @Published public var dailyWeather: [Weather] = []

//    public var currentWeatherPublisher: AnyPublisher<Weather, Never>

    public var weathersPublisher: AnyPublisher<[WeatherType: [Weather]], Never> {
        repository.fetchedResultsPublisher
            .map { weatherEntities in
                Dictionary(grouping: weatherEntities.map { $0.toDomainModel() },
                           by: { $0.weatherType })
            }
            .eraseToAnyPublisher()
    }

//    var weathersPublisher: AnyPublisher<[WeatherType: [Weather]], Never> {
//        repository.fetchedResultsPublisher
//            .compactMap { sections in
//                sections.enumerated().reduce(into: [:]) { partialResult, element in
//                    guard let weatherType = WeatherType(rawValue: element.offset) else {
//                        return
//                    }
//
//                    partialResult?[weatherType] = element.element.map { $0.toDomainModel() }
//                }
////
////                sections.compactMap { weatherEntities in
////                    weatherEntities.map { $0.toDomainModel() }
////
////                    Dictionary(
//////                    guard
//////                        let index = sections.firstIndex(of: weatherEntities),
//////                        let weatherType = WeatherType(rawValue: index)
//////                    else {
//////                        return nil
//////                    }
////
////                    return [WeatherType.hourly: []]
//
////                    return KeyValuePairs(dictionaryLiteral: (weatherType, weatherEntities.map { $0.toDomainModel() } ))
////                }
//            }
//            .eraseToAnyPublisher()
//    }

    // MARK: - LifeCicle

    /// Designated initializer
    /// - Parameter context: The context used for storing and quering Core Data.
    public init(context: NSManagedObjectContext,
                requestManager: RequestManagerProtocol = RequestManager()
    ) {
        self.repository = CoreDataRepository<WeatherEntity>(managedObjectContext: context)
        self.requestManager = requestManager

//        bindToRepository()
    }

//    private func bindToRepository() {
////        let weatublisher repository.fetchedResultsPublisher
////            .map { $0.publisher }
////
////
////
////
////            .filter { <#[WeatherEntity]#> in
////                <#code#>
////            }
//
//
//
//        let relay = repository.fetchedResultsPublisher
//            .map { weatherEntities in
//                Dictionary(grouping: weatherEntities.map { $0.toDomainModel() },
//                           by: { $0.weatherType })
////                .publisher
////                .eraseToAnyPublisher()
//            }
//
//         relay
//            .compactMap { $0[.current]?.first }
//            .assign(to: &currentWeatherPublisher)
//
//        relay
//            .compactMap { $0[.hourly]?.first }
////            .assign(to: &$currentWeather)
//
//
//    }

}


extension WeatherRepository: WeatherRepositoryProtocol {

//    public var fetchedResultsChangedPublisher: AnyPublisher<FetchResultServiceState, Never> {
//        repository.fetchedResultsChangedPublisher
//    }

//    public var fetchResults: [Weather] {
//        mapToWeather(weatherEntities: repository.fetchResults)
//    }

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
        //                              weatherType: WeatherType) -> NSPredicate {
        //        NSPredicate(format: "weatherType == %@ AND latitude BETWEEN { %@ , %@ } AND longitude BETWEEN { %@ , %@ }",
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

    /// Creates or Updates existing Weather on the persistance layer.
    public func save(weather: Weather) async throws {
        try await create(weather: weather)
    }

    private func getWeatherEntity(for weather: Weather) async throws -> WeatherEntity {
        //        let locationPredicate = getPredicate(latitude: weather.latitude, longitude: weather.longitude)
        //        let typePredicate = NSPredicate(format: "weatherType == %@", weather.weatherType.rawValue)
        //        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [locationPredicate, typePredicate])
        //
        //        let weatherEntities = try await repository.get(predicate: predicate, sortDescriptors: [mainSortDescriptor])
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

    /// Sets up a FetchResultService with stateChanged handler.
    //    public func setupResultsControllerStateChangedHandler(stateChanged:((FetchResultServiceState) -> Void)?) {
    //        repository.setupResultsControllerStateChangedHandler(stateChanged: stateChanged)
    //    }

    /// Starts fetching with given NSPredicate and array of NSSortDescriptors.
    public func startFetchingWith(predicate: NSPredicate?,
                                  sortDescriptors: [NSSortDescriptor]?) throws {
        //        var sorting = sortDescriptors
        //        if sorting == nil {
        //            sorting = [NSSortDescriptor(keyPath: \WeatherEntity.weatherType, ascending: true)]
        //        }
        //
        //        try repository.startFetchingWith(predicate: predicate, sortDescriptors: sorting)
    }



    //    public func fetchWeather(location: WeatherLocation) async {
    //        await fetchCurrentWeather(location: location)
    //    }

    public func startFetchingWeather(for location: WeatherLocation) async throws {
        let predicate = getPredicate(latitude: location.latitude, longitude: location.longitude)

        try repository.startFetchingWith(predicate: predicate,
                                         sortDescriptors: mainSortDescriptors)//,
//                                         sectionNameKeyPath: "weatherTypeRaw")

        try await fetchWeatherFromAPI(for: location)
    }

    private func fetchWeatherFromAPI(for location: WeatherLocation
                                     //        latitude: Double,
                                     //                                 longitude: Double
    ) async throws {
        let weatherContainer: WeatherContainer = try await requestManager.perform(
            WeatherRequest.getCurrentDayWeatherFor(latitude: location.latitude,
                                                   longitude: location.longitude)

        )

        guard let todayWeather = weatherContainer.days.first else { return }

        if let currentWeather = weatherContainer.currentConditions  {

            try await store([currentWeather.filledWith(weatherType: .current,
                                                       longitude: location.longitude,
                                                       latitude: location.latitude)])
        }

        guard var hourlyWeather = todayWeather.hours else { return }

        hourlyWeather = hourlyWeather.map { weather in
            weather.filledWith(weatherType: .hourly,
                               longitude: location.longitude,
                               latitude: location.latitude)
        }

        try await store(hourlyWeather)


        //        guard let currentWeather = currentWeatherContainer.data?.first else { throw NetworkError.invalidServerResponse }



        //            for var animal in animalsContainer.animals {
        //                animal.toManagedObject()
        //            }
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
    //    public func fetchCurrentDayWeather(location: WeatherLocation
    //                                       //        latitude: Double,
    //                                       //                                 longitude: Double
    //    ) async throws -> WeatherContainer {
    //        let weatherContainer: WeatherContainer = try await requestManager.perform(
    //            WeatherRequest.getCurrentDayWeatherFor(latitude: location.latitude,
    //                                                   longitude: location.longitude)
    //
    //        )
    //
    //        //        guard let currentWeather = currentWeatherContainer.data?.first else { throw NetworkError.invalidServerResponse }
    //
    //        return weatherContainer
    //
    //        //            for var animal in animalsContainer.animals {
    //        //                animal.toManagedObject()
    //        //            }
    //    }

    





}
