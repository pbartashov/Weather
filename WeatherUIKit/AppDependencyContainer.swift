//
//  AppDependencyContainer.swift
//  WeatherUIKit
//
//  Created by Павел Барташов on 24.09.2022.
//

import WeatherKit

public class AppDependencyContainer {
    let contextProvider: CoreDataContextProvider
    // MARK: - Properties

    //
    //    // From parent container
    //    let imageCache: ImageCache
    //    let signedInViewModel: SignedInViewModel
    //
    //    // Context
    //    let pickupLocation: Location
    //

    // Long-lived dependencies
        let sharedMainViewModel: MainViewModel
    //    let newRideRemoteAPI: NewRideRemoteAPI
    //    let newRideRepository: NewRideRepository
    //    let rideOptionDataStore: RideOptionDataStore
    //    let pickMeUpViewModel: PickMeUpViewModel

    // MARK: - Views

    // MARK: - LifeCicle

    public init(contextProvider: CoreDataContextProvider = CoreDataContextProvider.shared) {
        func makeMainViewModel() -> MainViewModel {
            MainViewModel()
        }

        self.contextProvider = contextProvider
        self.sharedMainViewModel = makeMainViewModel()



    }

    // MARK: - Metods

    public func makeMainViewController() -> MainViewController {
//        let launchViewController = makeLaunchViewController()
//
//        let onboardingViewControllerFactory = {
//            return self.makeOnboardingViewController()
//        }
//
//        let signedInViewControllerFactory = { (userSession: UserSession) in
//            return self.makeSignedInViewController(session: userSession)
//        }

        let weatherViewControllerFactory = { index in
            return self.makeWeartherViewController(for: index)
        }

        return MainViewController(viewModel: sharedMainViewModel,
                                  weatherViewControllerFactory: weatherViewControllerFactory)
    }



    public func makeWeartherViewController(for index: Int) -> WeatherViewController {
        let location = sharedMainViewModel.locations[index]
        let dependencyContainer = WeatherDependencyContainer(contextProvider: contextProvider)
        return dependencyContainer.makeWeatherViewController(for: location)
    }





}
