//
//  MainViewModel.swift
//  WeatherKit
//
//  Created by Павел Барташов on 24.09.2022.
//

import Combine
import CoreLocation

@objc public protocol AddLocationResponder {
    @objc func handleAddLocation()
}

@objc public protocol OnboardingResponder {
    @objc func locationAccessGranted()
    @objc func locationAccessDenied()
}

public protocol SearchLocationResponder {
    func selected(address: LocationAddress)
}

public protocol RemovePageResponder {
    func remove(location: WeatherLocation)
}

public final class MainViewModel: ViewModel {

    // MARK: - Properties

    private let repository: WeatherLocationRepositoryProtocol
    private let gpsLocationManager: LocationManager

    @Published public var mainSceneState: MainSceneState
    @Published public var locations: [WeatherLocation] = []

    // MARK: - LifeCicle

    public init(locationsRepository: WeatherLocationRepositoryProtocol,
                locationManager: LocationManager = LocationManager(),
                settings: Settings = Settings.shared
    ) {
        self.repository = locationsRepository
        self.gpsLocationManager = locationManager
        self.mainSceneState = settings.isFirstLaunch() ? .showOnboarding : .showWeather
        super.init()
        setupBindings()
    }

    // MARK: - Metods

    private func setupBindings() {
        func bindToRepository() {
            repository.weatherLocationsPublisher
                .assign(to: &$locations)
        }

        func bindToLocationManager() {
            gpsLocationManager.$authorizationStatus
                .filter { [weak self] _ in
                    self?.mainSceneState == .showOnboarding
                }
                .map { [weak self] status in
                    switch status {
                        case .authorizedAlways, .authorizedWhenInUse:
                            return self?.getStateForEmptyLocations() ?? MainSceneState.showWeather

                        case .notDetermined:
                            return MainSceneState.showOnboarding

                        default:
                            return MainSceneState.showWeather
                    }
                }
                .assign(to: &$mainSceneState)
        }

        bindToRepository()
        bindToLocationManager()
    }

    public func fetchLocations() async {
        do {
            try await repository.startFetchingWeatherLocation()
        } catch {
            errorMessagesSubject.send(error)
        }
    }

    private func requestLocation() {
        Task {
            do {
                if let address = try await gpsLocationManager.getCurrentAddress() {
                    selected(address: address)
                }
            } catch {
                errorMessagesSubject.send(error)
            }
        }
    }

    private func getStateForEmptyLocations() -> MainSceneState {
        if locations.isEmpty {
            requestLocation()
            return .showWaitingLocation
        } else {
            return .showSearchLocation
        }
    }
}

// MARK: - AddLocationResponder methods
extension MainViewModel: AddLocationResponder {
    public func handleAddLocation() {
        if gpsLocationManager.isLocationEnabled {
            mainSceneState = getStateForEmptyLocations()
        } else {
            mainSceneState = .showOnboarding
        }
    }
}

// MARK: - OnboardingResponder methods
extension MainViewModel: OnboardingResponder {
    public func locationAccessGranted() {
        let onDenied = {
            self.mainSceneState = .showLocationDenied
        }

        let onRestricted = {
            self.mainSceneState = .showLocationRestricted
        }

        gpsLocationManager.checkAuthorization(onDenied: onDenied,
                                              onRestricted: onRestricted)
    }

    public func locationAccessDenied() {
        mainSceneState = .showSearchLocation
    }
}

// MARK: - SearchLocationResponder methods
extension MainViewModel: SearchLocationResponder {
    public func selected(address: LocationAddress) {
        if let index = locations.firstIndex(where: {
            $0.longitude.isCloseTo(address.longitude) &&
            $0.latitude.isCloseTo(address.latitude)
        }) {
            mainSceneState = .showWeatherAt(index: index)
            return
        }

        Task {
            do {
                let timeZone = try await gpsLocationManager.getTimeZoneFor(
                    latitude: address.latitude,
                    longitude: address.longitude
                )
                let location = address.toWeatherLocation(index: locations.count,
                                                         timeZone: timeZone)
                try await repository.save(location: location)
                try await repository.saveChanges()
            } catch {
                errorMessagesSubject.send(error)
            }

            mainSceneState = .showWeather
        }
    }
}

// MARK: - RemovePageResponder methods
extension MainViewModel: RemovePageResponder {
    public func remove(location: WeatherLocation) {
        locations.removeAll {
            location.index == $0.index
        }

        Task {
            do {
                try await repository.delete(location: location)
                try await repository.reindex()
            } catch {
                errorMessagesSubject.send(error)
            }
        }
    }
}


fileprivate extension LocationAddress {
    func toWeatherLocation(index: Int, timeZone: String) -> WeatherLocation {
        WeatherLocation(index: index,
                        cityName: "\(city), \(country)",
                        timeZone: timeZone,
                        latitude: latitude,
                        longitude: longitude)
    }
}

fileprivate extension Double {
    func isCloseTo(_ other: Double) -> Bool {
        abs(self - other) < Constants.locationAccuracy
    }
}
