//
//  AppDependencyContainer.swift
//  WeatherUIKit
//
//  Created by Павел Барташов on 24.09.2022.
//

import WeatherKit
import UIKit

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
            let repository = WeatherLocationRepository(context: contextProvider.backgroundContext)
            return MainViewModel(locationsRepository: repository)
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

        let settingsViewControllerFactory = {
            return self.makeSettingsViewController()
        }

        let addLocationViewControllerFactory = {
            return self.makeAddLocationViewController()
        }

        let onboardingViewControllerFactory = {
            return self.makeOnboardingViewController()
        }

        let searchLocationViewControllerFactory = {
            return self.makeSearchLocationViewController()
        }

        return MainViewController(viewModel: sharedMainViewModel,
                                  weatherViewControllerFactory: weatherViewControllerFactory,
                                  settingsViewControllerFactory: settingsViewControllerFactory,
                                  addLocationViewControllerFactory: addLocationViewControllerFactory,
                                  onboardingViewControllerFactory: onboardingViewControllerFactory,
                                  searchLocationViewControllerFactory: searchLocationViewControllerFactory)
    }

    public func makeRootViewController() -> UIViewController {
        let mainViewController = makeMainViewController()
        return UINavigationController(rootViewController: mainViewController)
    }



    public func makeWeartherViewController(for index: Int) -> WeathersViewController {
        let location = sharedMainViewModel.locations[index]
        let dependencyContainer = WeatherDependencyContainer(contextProvider: contextProvider)
        return dependencyContainer.makeWeatherViewController(for: location)
    }

    public func makeSettingsViewController() -> SettingsViewController {
        let dependencyContainer = SettingsDependencyContainer()
        return dependencyContainer.makeSettingsViewController()
    }

    public func makeAddLocationViewController() -> AddLocationViewController {
        AddLocationViewController(addLocationResponder: sharedMainViewModel)
    }

    public func makeOnboardingViewController() -> OnboardingViewController {
        let viewModel = makeOnboardingViewModel()
        return OnboardingViewController(viewModel: viewModel, onboardingResponder: sharedMainViewModel)
    }

    func makeOnboardingViewModel() -> OnboardingViewModel {
        OnboardingViewModel()
    }

    public func makeSearchLocationViewController() -> SearchLocationViewController {
        SearchLocationViewController(searchLocationResponder: sharedMainViewModel)
    }

    





}
