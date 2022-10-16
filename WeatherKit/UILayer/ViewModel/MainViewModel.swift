//
//  MainViewModel.swift
//  WeatherKit
//
//  Created by Павел Барташов on 24.09.2022.
//

import Combine

@objc public protocol AddLocationResponder {
    @objc func handleAddLocation()
}

@objc public protocol OnboardingResponder {
    @objc func locationAccessGranted()
    @objc func locationAccessDenied()
}

@objc public protocol SearchLocationResponder {
    @objc func searchLocation()
    @objc func cancelSearchLocation()
}



public final class MainViewModel {

    // MARK: - Properties
    private let repository: WeatherLocationRepositoryProtocol
    private let gpsLocationManager: LocationManager

    @Published public var mainSceneState: MainSceneState = .showWeather
    @Published public var locations: [WeatherLocation] = []

    public var errorMessages: AnyPublisher<Error, Never> {
        errorMessagesSubject.eraseToAnyPublisher()
    }

    private let errorMessagesSubject = PassthroughSubject<Error, Never>()

    private var subscriptions = Set<AnyCancellable>()

    // MARK: - LifeCicle

    public init(locationsRepository: WeatherLocationRepositoryProtocol,
                locationManager: LocationManager = LocationManager()
    ) {
        self.repository = locationsRepository
        self.gpsLocationManager = locationManager

        setupBindings()


        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.locations = MockLocations.locations
        }
//        locations = 

//        MockLocations.locations.forEach { location in
//            Task {
//                await self.add(location: location)
//            }
//        }
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
                .map { status -> MainSceneState in
                    if status == .authorizedAlways ||
                    status == .authorizedWhenInUse {
                        let name = "Владивосток"
                        return .showSearchLocation(named: name)
                    } else {
                        return .showSearchLocation(named: nil)
                    }
                }
                .assign(to: &$mainSceneState)
//                .sink { [weak self] status in
//                    self?.handleGPSAuthorizationStatusDidChanged(status)
//                }

//                .store(in: &subscriptions)
        }

        bindToRepository()
        bindToLocationManager()
    }

    public func add(location: WeatherLocation) async {
        do {
            try await repository.save(location: location)
        } catch {
            errorMessagesSubject.send(error)
        }

    }

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

    func trySetSearchLocation() {//} async -> MainSceneState {
//        let status = gpsLocationManager.authorizationStatus
//        guard
//            status == .authorizedAlways ||
//                status == .authorizedWhenInUse
//        else {
//            return .showSearchLocation(named: nil)
//        }
//        let lat - gpsLocationManager.
//        let name = "Владивосток"
//        return .showSearchLocation(named: name)
//    } else {
//
//    }
//    }

        guard
            gpsLocationManager.locationIsEnabled
//            let coordinate = gpsLocationManager.lastSeenLocation?.coordinate
        else {
            mainSceneState = .showSearchLocation(named: nil)
            return
        }
//
//        let longitude = coordinate.longitude
        //        let latitude = coordinate.latitude

        Task {
            do {
                let addresses = try await gpsLocationManager.getAddressesForCurrentLocation()




            } catch {
                errorMessagesSubject.send(error)
            }
        }
    }



}

extension MainViewModel: AddLocationResponder {
    public func handleAddLocation() {
        if gpsLocationManager.locationIsEnabled {
//            mainSceneState = makeSearchLocation()
            trySetSearchLocation()
        } else {
            mainSceneState = .showOnboarding
        }
    }
}

extension MainViewModel: OnboardingResponder {
    public func locationAccessGranted() {
        gpsLocationManager.requestWhenInUseAuthorization()
    }

    public func locationAccessDenied() {
//        mainSceneState = .showWeather
        trySetSearchLocation()
//        mainSceneState = makeSearchLocation()
    }


}

extension MainViewModel: SearchLocationResponder {
    public func searchLocation() {

    }

    public func cancelSearchLocation() {
        mainSceneState = .showWeather
    }


}








struct MockLocations {
    static let locations = [WeatherLocation(index: 0, cityName: "London", latitude: 30, longitude: 60),
       WeatherLocation(index: 1, cityName: "Vladivostok", latitude: 50, longitude: 90),
       WeatherLocation(index: 2, cityName: "San Diego", latitude: 20, longitude: 135)]
}


