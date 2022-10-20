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
    /// Weather location publisher
    var weatherLocationsPublisher: AnyPublisher<[WeatherLocation], Never> { get }
    /// Starts fetchig locations
    func startFetchingWeatherLocation() async throws
    /// Reindexes locations in persistant store to arrange indexes continuously
    func reindex() async throws
}

/// WeatherLocation Repository class.
public final class WeatherLocationRepository {

    // MARK: - Properties

    private let requestManager: RequestManagerProtocol

    /// The Core Data WeatherLocation repository.
    private let repository: CoreDataRepository<WeatherLocationEntity>

    /// Weather location publisher
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
    }
}

// MARK: - WeatherLocationRepositoryProtocol methods
extension WeatherLocationRepository: WeatherLocationRepositoryProtocol {
    private var mainSortDescriptors: [NSSortDescriptor] {
        [
            NSSortDescriptor(keyPath: \WeatherLocationEntity.index, ascending: false),
        ]
    }

    private func mapToWeatherLocation(locationEntities: [WeatherLocationEntity]
    ) -> [WeatherLocation] {
        locationEntities.map { $0.toDomainModel() }
    }

    private func getPredicate(index: Int) -> NSPredicate {
        NSPredicate(format: "index == %@", NSNumber(value: index))
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
        let locationEntities = try await getWeatherLocationEntities(for: location)
        guard let locationEntity = locationEntities.first else {
            throw DatabaseError.notFound
        }

        return locationEntity
    }

    private func getWeatherLocationEntities(for location: WeatherLocation) async throws -> [WeatherLocationEntity] {
        let predicate = getPredicate(index: location.index)
        return try await repository.get(predicate: predicate, sortDescriptors: mainSortDescriptors)
    }

    /// Save the NSManagedObjectContext.
    public func saveChanges() async throws {
        try await repository.saveChanges()
    }

    /// Starts fetchig locations
    public func startFetchingWeatherLocation() async throws {
        try repository.startFetchingWith(predicate: nil,
                                         sortDescriptors: mainSortDescriptors)
    }

    /// Reindexes locations in persistant store to arrange indexes continuously
    public func reindex() async throws {
        let sortDescriptor = NSSortDescriptor(keyPath: \WeatherLocationEntity.index, ascending: true)
        let locationEntities = try await repository.get(predicate: nil,
                                                        sortDescriptors: [sortDescriptor])

        for (i, entity) in locationEntities.enumerated() where entity.index != i {
            entity.index = Int16(i)
        }

        try await saveChanges()
    }
}
