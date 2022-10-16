//
//  WeatherLocationRepository.swift
//  WeatherKit
//
//  Created by Павел Барташов on 14.10.2022.
//

import CoreData
import Combine

//https://www.userdesk.io/blog/repository-pattern-using-core-data-and-swift/

/// Protocol that describes a WeatherLocation repository.
public protocol WeatherLocationRepositoryProtocol {
    /// Get a WeatherLocation using a predicate
    func getWeatherLocation(predicate: NSPredicate?) async throws -> [WeatherLocation]
    /// Creates a WeatherLocation on the persistance layer.
    func create(location: WeatherLocation) async throws
    /// Creates or Updates existing WeatherLocation on the persistance layer.
    func save(location: WeatherLocation) async throws
    /// Deletes a WeatherLocation from the persistance layer.
    func delete(location: WeatherLocation) async throws
    /// Saves changes to Repository.
    func saveChanges() async throws





    var weatherLocationsPublisher: AnyPublisher<[WeatherLocation], Never> { get }
//    func startFetchingWith(predicate: NSPredicate?,
//                           sortDescriptors: [NSSortDescriptor]?) throws

    func startFetchingWeatherLocation() async throws
}

/// WeatherLocation Repository class.
public final class WeatherLocationRepository {

    // MARK: - Properties

    private let requestManager: RequestManagerProtocol

    /// The Core Data WeatherLocation repository.
    private let repository: CoreDataRepository<WeatherLocationEntity>


    //    @Published public var currentWeatherLocation: WeatherLocation?
    //    @Published public var hourlyWeatherLocation: [WeatherLocation] = []
    //    @Published public var dailyWeatherLocation: [WeatherLocation] = []

    //    public var currentWeatherLocationPublisher: AnyPublisher<WeatherLocation, Never>

    public var weatherLocationsPublisher: AnyPublisher<[WeatherLocation], Never> {
        repository.fetchedResultsPublisher
            .map { locationEntities in
                locationEntities.map { $0.toDomainModel() }
            }
            .eraseToAnyPublisher()
    }


    // MARK: - LifeCicle

    /// Designated initializer
    /// - Parameter context: The context used for storing and quering Core Data.
    public init(context: NSManagedObjectContext,
                requestManager: RequestManagerProtocol = RequestManager()
    ) {
        self.repository = CoreDataRepository<WeatherLocationEntity>(managedObjectContext: context)
        self.requestManager = requestManager

        //        bindToRepository()
    }

}


extension WeatherLocationRepository: WeatherLocationRepositoryProtocol {
    private var mainSortDescriptors: [NSSortDescriptor] {
        [
            NSSortDescriptor(keyPath: \WeatherLocationEntity.index, ascending: false),
        ]
    }

    private func mapToWeatherLocation(locationEntities: [WeatherLocationEntity]) -> [WeatherLocation] {
        locationEntities.map { $0.toDomainModel() }
    }

    private func getPredicate(latitude: Double,
                              longitude: Double) -> NSPredicate {
        //                              locationType: WeatherLocationType) -> NSPredicate {
        //        NSPredicate(format: "locationType == %@ AND latitude BETWEEN { %@ , %@ } AND longitude BETWEEN { %@ , %@ }",
        NSPredicate(format: "latitude BETWEEN { %@ , %@ } AND longitude BETWEEN { %@ , %@ }",
                    NSNumber(value: latitude - Constants.locationAccuracy),
                    NSNumber(value: latitude + Constants.locationAccuracy),
                    NSNumber(value: longitude - Constants.locationAccuracy),
                    NSNumber(value: longitude + Constants.locationAccuracy))
    }



    /// Get WeatherLocation using a predicate
    public func getWeatherLocation(predicate: NSPredicate?) async throws -> [WeatherLocation] {
        let locationEntities = try await repository.get(predicate: predicate, sortDescriptors: nil)
        // Transform the NSManagedObject objects to domain objects
        return mapToWeatherLocation(locationEntities: locationEntities)
    }

    /// Creates a WeatherLocation on the persistance layer.
    public func create(location: WeatherLocation) async throws {
        let entity = try await repository.create()
        entity.copyDomainModel(model: location)
    }

    /// Deletes a WeatherLocation from the persistance layer.
    public func delete(location: WeatherLocation) async throws {
        let locationEntity = try await getWeatherLocationEntity(for: location)
        await repository.delete(entity: locationEntity)
    }

    /// Creates or Updates existing WeatherLocation on the persistance layer.
    public func save(location: WeatherLocation) async throws {
        do {
            let entity = try await getWeatherLocationEntity(for: location)
            entity.copyDomainModel(model: location)
        } catch DatabaseError.notFound {
            try await create(location: location)
        }
    }

    private func getWeatherLocationEntity(for location: WeatherLocation) async throws -> WeatherLocationEntity {
        //        let locationPredicate = getPredicate(latitude: location.latitude, longitude: location.longitude)
        //        let typePredicate = NSPredicate(format: "locationType == %@", location.locationType.rawValue)
        //        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [locationPredicate, typePredicate])
        //
        //        let locationEntities = try await repository.get(predicate: predicate, sortDescriptors: [mainSortDescriptor])
        let locationEntities = try await getWeatherLocationEntities(for: location)
        guard let locationEntity = locationEntities.first else {
            throw DatabaseError.notFound
        }

        return locationEntity
    }

    private func getWeatherLocationEntities(for location: WeatherLocation) async throws -> [WeatherLocationEntity] {
        let locationPredicate = getPredicate(latitude: location.latitude, longitude: location.longitude)
//        let typePredicate = NSPredicate(format: "weatherTypeRaw == %@", NSNumber(value:  weather.weatherType.rawValue))
//        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [locationPredicate, typePredicate])

        return try await repository.get(predicate: locationPredicate, sortDescriptors: mainSortDescriptors)
    }

    /// Save the NSManagedObjectContext.
    public func saveChanges() async throws {
        try await repository.saveChanges()
    }

    /// Sets up a FetchResultService with stateChanged handler.
    //    public func setupResultsControllerStateChangedHandler(stateChanged:((FetchResultServiceState) -> Void)?) {
    //        repository.setupResultsControllerStateChangedHandler(stateChanged: stateChanged)
    //    }






    public func startFetchingWeatherLocation() async throws {
//        let predicate = getPredicate(latitude: location.latitude, longitude: location.longitude)

        try repository.startFetchingWith(predicate: nil,
                                         sortDescriptors: mainSortDescriptors)//,
        //                                         sectionNameKeyPath: "weatherTypeRaw")

//        try await fetchCurrentDayWeatherLocationFromAPI(for: location)
    }

//    private func fetchCurrentDayWeatherLocationFromAPI(for location: WeatherLocationLocation
//                                               //        latitude: Double,
//                                               //                                 longitude: Double
//    ) async throws {
//        let weatherPack: WeatherLocationPack = try await requestManager.perform(
//            WeatherLocationRequest.getCurrentDayWeatherLocationFor(location: location)
//        )
//        weatherContainerSubject.send(weatherPack)
//
//        guard let todayWeatherLocation = weatherPack.days.first else { return }
//        //        print(todayWeatherLocation)
//        if let currentWeatherLocation = weatherPack.currentWeatherLocation  {
//            //            print(currentWeatherLocation)
//            try await store([currentWeatherLocation])
//        }
//        //            try await store([currentWeatherLocation.filledWith(weatherType: .current,
//        //                                                       longitude: location.longitude,
//        //                                                       latitude: location.latitude)])
//        //        }
//
//        guard let hourlyWeatherLocation = todayWeatherLocation.hourlyWeatherLocations else { return }
//        //        print(hourlyWeatherLocation)
//        //        hourlyWeatherLocation = hourlyWeatherLocation.map { weather in
//        //            weather.filledWith(weatherType: .hourly,
//        //                               longitude: location.longitude,
//        //                               latitude: location.latitude)
//        //        }
//
//        try await store(hourlyWeatherLocation)
//
//
//        //        guard let currentWeatherLocation = currentWeatherLocationContainer.data?.first else { throw NetworkError.invalidServerResponse }
//
//
//
//        //            for var animal in animalsContainer.animals {
//        //                animal.toManagedObject()
//        //            }
//    }
//
//    private func fetchForecastWeatherLocationFromAPI(for location: WeatherLocationLocation,
//                                             dateInterval: DateInterval
//    ) async throws {
//
//        let weatherPack: WeatherLocationPack = try await requestManager.perform(
//            WeatherLocationRequest.getForecastWeatherLocationFor(location: location, dateInterval: dateInterval)
//        )
//
//        try await store(weatherPack.days)
//    }
//
//    private func store(_ weathers: [WeatherLocation]) async throws {
//        guard let weather = weathers.first else {
//            return
//        }
//
//        var weatherEntities = try await getWeatherLocationEntities(for: weather)
//
//        while weatherEntities.count < weathers.count {
//            let newEntity = try await repository.create()
//            weatherEntities.append(newEntity)
//        }
//
//        for (entity, weather) in zip(weatherEntities, weathers) {
//            entity.copyDomainModel(model: weather)
//        }
//
//        try await repository.saveChanges()
//
//    }







}

