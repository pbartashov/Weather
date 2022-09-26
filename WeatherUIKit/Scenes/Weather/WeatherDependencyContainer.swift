//
//  WeatherDependencyContainer.swift
//  WeatherUIKit
//
//  Created by Павел Барташов on 24.09.2022.
//

import WeatherKit

public final class WeatherDependencyContainer {

    // MARK: - Properties


    //    // From parent container
    //    let imageCache: ImageCache
    //    let signedInViewModel: SignedInViewModel
    //
    //    // Context
    //    let pickupLocation: Location
    //
    // Long-lived dependencies
    //        let weatherViewModel: WeatherViewModel
    //    let newRideRemoteAPI: NewRideRemoteAPI
    //    let newRideRepository: NewRideRepository
    //    let rideOptionDataStore: RideOptionDataStore
    //    let pickMeUpViewModel: PickMeUpViewModel

    // MARK: - Views

    // MARK: - LifeCicle

    public init() {
        //        func makeWeartherViewModel() -> WeatherViewModel {
        //            WeatherViewModel()
        //        }
        //
        //
        //        self.weatherViewModel = makeWeartherViewModel()
    }

    // MARK: - Metods

    public func makeWeatherViewController(for location: WeatherLocation) -> WeatherViewController {
        //        let launchViewController = makeLaunchViewController()
        //
        //        let onboardingViewControllerFactory = {
        //            return self.makeOnboardingViewController()
        //        }
        //
        //        let signedInViewControllerFactory = { (userSession: UserSession) in
        //            return self.makeSignedInViewController(session: userSession)
        //        }

        let viewModel = makeWeartherViewModel(for: location)

        return WeatherViewController(viewModel: viewModel)
    }

    func makeWeartherViewModel(for location: WeatherLocation) -> WeatherViewModel {
        let reposirory = WeatherRepository()
        return WeatherViewModel(location: location, weatherRepository: reposirory)
    }
}
