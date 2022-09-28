//
//  WeatherRepository.swift
//  WeatherKit
//
//  Created by Павел Барташов on 24.09.2022.
//

import CoreData

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



    var fetchResults: [Weather] { get }

    func setupResultsControllerStateChangedHandler(stateChanged:((FetchResultServiceState) -> Void)?)

    func startFetchingWith(predicate: NSPredicate?,
                           sortDescriptors: [NSSortDescriptor]?) throws


    func fetchCurrentDayWeather(location: WeatherLocation) async throws -> WeatherContainer
}

/// Weather Repository class.
public final class WeatherRepository {

    // MARK: - Properties

    private let requestManager: RequestManagerProtocol

    /// The Core Data Weather repository.
    private let repository: CoreDataRepository<WeatherEntity>

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


extension WeatherRepository: WeatherRepositoryProtocol {

    public var fetchResults: [Weather] {
        mapToWeather(weatherEntities: repository.fetchResults)
    }

    private func mapToWeather(weatherEntities: [WeatherEntity]) -> [Weather] {
        weatherEntities.map { $0.toDomainModel() }
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
        let predicate = NSPredicate(format: "weatherType == %@ AND latitude BETWEEN { %@ , %@ } AND longitude BETWEEN { %@ , %@ } AND",
                                    weather.weatherType.rawValue,
                                    weather.latitude + Constants.locationAccuracy,
                                    weather.latitude - Constants.locationAccuracy,
                                    weather.longitude + Constants.locationAccuracy,
                                    weather.longitude - Constants.locationAccuracy)

        let weatherEntities = try await repository.get(predicate: predicate, sortDescriptors: nil)
        guard let weatherEntity = weatherEntities.first else {
            throw DatabaseError.notFound
        }

        return weatherEntity
    }

    /// Save the NSManagedObjectContext.
    public func saveChanges() async throws {
        try await repository.saveChanges()
    }

    /// Sets up a FetchResultService with stateChanged handler.
    public func setupResultsControllerStateChangedHandler(stateChanged:((FetchResultServiceState) -> Void)?) {
        repository.setupResultsControllerStateChangedHandler(stateChanged: stateChanged)
    }

    /// Starts fetching with given NSPredicate and array of NSSortDescriptors.
    public func startFetchingWith(predicate: NSPredicate?,
                                  sortDescriptors: [NSSortDescriptor]?) throws {
        var sorting = sortDescriptors
        if sorting == nil {
            sorting = [NSSortDescriptor(keyPath: \WeatherEntity.weatherType, ascending: true)]
        }

        try repository.startFetchingWith(predicate: predicate, sortDescriptors: sorting)
    }


  
    //    public func fetchWeather(location: WeatherLocation) async {
    //        await fetchCurrentWeather(location: location)
    //    }

    public func fetchCurrentDayWeather(location: WeatherLocation
                                       //        latitude: Double,
                                       //                                 longitude: Double
    ) async throws -> WeatherContainer {
        let weatherContainer: WeatherContainer = try await requestManager.perform(
            WeatherRequest.getCurrentDayWeatherFor(latitude: location.latitude,
                                                   longitude: location.longitude)

        )

        //        guard let currentWeather = currentWeatherContainer.data?.first else { throw NetworkError.invalidServerResponse }

        return weatherContainer

        //            for var animal in animalsContainer.animals {
        //                animal.toManagedObject()
        //            }
    }






}
