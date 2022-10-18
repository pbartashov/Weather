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
//
//    private let errorMessagesSubject = PassthroughSubject<Error, Never>()
//
//    private var subscriptions = Set<AnyCancellable>()

    // MARK: - LifeCicle

    public init(locationManager: LocationManager = LocationManager()
    ) {
        self.gpsLocationManager = locationManager

//        setupBindings()
    }


    // MARK: - Metods


//    private func setupBindings() {
//        func bindToLocationManager() {
//            gpsLocationManager.$authorizationStatus
//                .filter { [weak self] _ in
//                    self?.mainSceneState == .showOnboarding
//                }
//                .map { _ in // status -> MainSceneState in
//                    //                    if status == .authorizedAlways ||
//                    //                    status == .authorizedWhenInUse {
//                    //                        let name = "Владивосток"
//                    //                        return .showSearchLocation//(named: name)
//                    //                    } else {
//                    //                        return .showSearchLocation//(named: nil)
//                    //                    }
//                    return MainSceneState.showSearchLocation
//                }
//                .assign(to: &$mainSceneState)
//            //                .sink { [weak self] status in
//            //                    self?.handleGPSAuthorizationStatusDidChanged(status)
//            //                }
//
//            //                .store(in: &subscriptions)
//        }
//
//        bindToLocationManager()
    //    }

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
