//
//  SearchLocationViewModel.swift
//  WeatherKit
//
//  Created by Павел Барташов on 16.10.2022.
//

import Combine

public final class SearchLocationViewModel: ViewModel {

    // MARK: - Properties

    private let gpsLocationManager: LocationManager

    @Published public var addresses: [LocationAddress] = []
    @Published public var searchText: String?

    public override var errorMessages: AnyPublisher<Error, Never> {
        Publishers.Merge(
            errorMessagesSubject,
            gpsLocationManager.errorMessages
        )
        .eraseToAnyPublisher()
    }

    // MARK: - LifeCicle

    public init(locationManager: LocationManager = LocationManager()
    ) {
        self.gpsLocationManager = locationManager
    }

    // MARK: - Metods

    public func fetch(locality: String) {//} async -> MainSceneState {
        Task {
            do {
                addresses = try await gpsLocationManager.getAddressesFor(locality: locality)
            } catch {
                errorMessagesSubject.send(error)
            }
        }
    }

    public func fetchCurrentLocality() {
        guard gpsLocationManager.isLocationEnabled else { return }

        Task {
            do {
                let currentAddress = try await gpsLocationManager.getCurrentAddress()
                searchText = currentAddress?.city
            } catch {
                errorMessagesSubject.send(error)
            }
        }
    }
}
