//
//  WeatherDependencyContainer.swift
//  WeatherUIKit
//
//  Created by Павел Барташов on 24.09.2022.
//

import WeatherKit

public final class WeatherDependencyContainer {

    // MARK: - Properties
    let contextProvider: CoreDataContextProvider



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

    public init(contextProvider: CoreDataContextProvider) {
        self.contextProvider = contextProvider
        //        func makeWeartherViewModel() -> WeatherViewModel {
        //            WeatherViewModel()
        //        }
        //
        //
        //        self.weatherViewModel = makeWeartherViewModel()
    }

    // MARK: - Metods

    public func makeWeatherViewController(for location: WeatherLocation) -> WeathersViewController {
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

        return WeathersViewController(viewModel: viewModel)
//                                     weatherFormatter: viewModel)
    }

    func makeWeartherViewModel(for location: WeatherLocation) -> WeathersViewModel {
        let repository = WeatherRepository(context: contextProvider.backgroundContext)
        return WeathersViewModel(location: location, weatherRepository: repository)
    }
}
