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
//    @objc func searchLocation()
//    @objc func cancelSearchLocation()
    func selected(address: LocationAddress)
}

public protocol RemovePageResponder {
    func remove(location: WeatherLocation)
}




public final class MainViewModel: ViewModel {

    // MARK: - Properties
    private let repository: WeatherLocationRepositoryProtocol
    private let gpsLocationManager: LocationManager
//    private let settings: Settings

    @Published public var mainSceneState: MainSceneState
    @Published public var locations: [WeatherLocation] = []

//    public var errorMessages: AnyPublisher<Error, Never> {
//        errorMessagesSubject.eraseToAnyPublisher()
//    }

//    private let errorMessagesSubject = PassthroughSubject<Error, Never>()
//
//    private var subscriptions = Set<AnyCancellable>()

    // MARK: - LifeCicle

    public init(locationsRepository: WeatherLocationRepositoryProtocol,
                locationManager: LocationManager = LocationManager(),
                settings: Settings = Settings.shared
    ) {
        self.repository = locationsRepository
        self.gpsLocationManager = locationManager
//        self.settings = settings
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
                .map { [weak self] status in // status -> MainSceneState in
//                    guard let self = self else { return }
//                    if status == .authorizedAlways ||
//                    status == .authorizedWhenInUse {
//                        let name = "Владивосток"
//                        return .showSearchLocation//(named: name)
//                    } else {
//                        return .showSearchLocation//(named: nil)
//                    }

                    switch status {
                        case .authorizedAlways, .authorizedWhenInUse:
                            return self?.getStateForEmptyLocations() ?? MainSceneState.showWeather
//                            if self?.locations.isEmpty == true {
//                                self?.requestLocation()
//                                return MainSceneState.showWaitingLocation
//                            } else {
//                                return MainSceneState.showSearchLocation
//                            }

                        case .notDetermined:
                            return MainSceneState.showOnboarding

                        default:
                            return MainSceneState.showWeather
                    }
                }
                .assign(to: &$mainSceneState)
//                .sink { [weak self] status in
//                    self?.handleGPSAuthorizationStatusDidChanged(status)
//                }

//                .store(in: &subscriptions)

//            gpsLocationManager.$lastSeenLocation
//                .sink { [weak self] location in
//                    self?.handleLocationChanged(location)
//                }
//                .store(in: &subscriptions)
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

//    private func handleLocationChanged(_ location: CLLocation?) {
//        guard mainSceneState == .showWaitingLocation else {
//            return
//        }
//
//        mainSceneState = .showWeather
//
//        guard let coordinate = location?.coordinate else {
//            return
//        }
//
//        Task {
//            do {
//                let adresses = try await gpsLocationManager.getAddressesFor(latitude: coordinate.latitude,
//                                                        longitude: coordinate.longitude)
//                if let address = adresses.first {
//                    selected(address: address)
//                }
//            }
//        }
//    }

//    public func checkIfFirstLaunch() {
//        if settings.isFirstLaunc {
//            mainSceneState =
//        }
//    }

//    public func add(location: WeatherLocation) async {
//        do {
//            try await repository.save(location: location)
//        } catch {
//            errorMessagesSubject.send(error)
//        }
//
//    }

//    private func handleGPSAuthorizationStatusDidChanged() {
//        guard let self = self,
//              case .showOnboarding = self.mainSceneState else {
//            return
//        }
//
//        if status == .authorizedAlways ||
//            status == .authorizedWhenInUse {
//            self.mainSceneState = .showSearchLocation
//        } else {
//            self.mainSceneState = .showSearchLocation
//        }
//        getAddressFor
//    }

//    func trySetSearchLocation() {//} async -> MainSceneState {
////        let status = gpsLocationManager.authorizationStatus
////        guard
////            status == .authorizedAlways ||
////                status == .authorizedWhenInUse
////        else {
////            return .showSearchLocation(named: nil)
////        }
////        let lat - gpsLocationManager.
////        let name = "Владивосток"
////        return .showSearchLocation(named: name)
////    } else {
////
////    }
////    }
//
//        guard
//            gpsLocationManager.locationIsEnabled
////            let coordinate = gpsLocationManager.lastSeenLocation?.coordinate
//        else {
//            mainSceneState = .showSearchLocation(named: nil)
//            return
//        }
////
////        let longitude = coordinate.longitude
//        //        let latitude = coordinate.latitude
//
//        Task {
//            do {
//                let addresses = try await gpsLocationManager.getAddressesForCurrentLocation()
//
//
//
//
//            } catch {
//                errorMessagesSubject.send(error)
//            }
//        }
//    }

    private func getStateForEmptyLocations() -> MainSceneState {
        if locations.isEmpty {
            requestLocation()
            return .showWaitingLocation
        } else {
            return .showSearchLocation
        }
    }


}

extension MainViewModel: AddLocationResponder {
    public func handleAddLocation() {
        if gpsLocationManager.isLocationEnabled {
            mainSceneState = getStateForEmptyLocations()
//            if locations.isEmpty {
//                requestLocation()
//                mainSceneState = .showWaitingLocation
//            } else {
//                mainSceneState = .showSearchLocation
//            }
//            trySetSearchLocation()
        } else {
            mainSceneState = .showOnboarding
        }
    }
}

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
//        mainSceneState = .showWeather
    }

    public func locationAccessDenied() {
//        mainSceneState = .showWeather
//        trySetSearchLocation()
        mainSceneState = .showSearchLocation
//        mainSceneState = makeSearchLocation()
    }


}

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


//
//
//
//
//
//struct MockLocations {
//    static let locations = [WeatherLocation(index: 0, cityName: "London", latitude: 30, longitude: 60),
//       WeatherLocation(index: 1, cityName: "Vladivostok", latitude: 50, longitude: 90),
//       WeatherLocation(index: 2, cityName: "San Diego", latitude: 20, longitude: 135)]
//}
//
//
