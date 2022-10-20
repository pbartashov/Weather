//
//  AppDependencyContainer.swift
//  WeatherUIKit
//
//  Created by Павел Барташов on 24.09.2022.
//

import WeatherKit
import UIKit

public class AppDependencyContainer {

    // MARK: - Properties

    let contextProvider: CoreDataContextProvider

    // Long-lived dependencies
    let sharedMainViewModel: MainViewModel

    // MARK: - LifeCicle

    public init(contextProvider: CoreDataContextProvider = CoreDataContextProvider.shared) {
        func makeMainViewModel() -> MainViewModel {
            let repository = WeatherLocationRepository(context: contextProvider.viewContext)
            return MainViewModel(locationsRepository: repository)
        }
        self.contextProvider = contextProvider
        self.sharedMainViewModel = makeMainViewModel()
    }

    // MARK: - Metods

    public func makeMainViewController() -> MainViewController {
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
                                  searchLocationViewControllerFactory: searchLocationViewControllerFactory,
                                  locationsViewControllerFactory: self
        )
    }

    public func makeRootViewController() -> UIViewController {
        let mainViewController = makeMainViewController()
        return UINavigationController(rootViewController: mainViewController)
    }

    public func makeWeartherViewController(for index: Int) -> WeathersViewController {
        let location = sharedMainViewModel.locations[index]
        let dependencyContainer = WeatherDependencyContainer(contextProvider: contextProvider,
                                                             removePageResponder: sharedMainViewModel)
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
        let dependencyContainer = OnboardingDependencyContainer(onboardingResponder: sharedMainViewModel)
        return dependencyContainer.makeOnboardingViewController()
    }

    public func makeSearchLocationViewController() -> SearchLocationViewController {
        let dependencyContainer = SearchLocationDependencyContainer(searchLocationResponder: sharedMainViewModel)
        return dependencyContainer.makeSearchLocationViewController()
    }
}

// MARK: - LocationViewControllerFactoryProtocol methods
extension AppDependencyContainer: LocationViewControllerFactoryProtocol {
    public func makeDeniedViewController() -> UIViewController {
        let alert = UIAlertController(title: "Резрешите доступ к геолокации в настройках",
                                      message: nil,
                                      preferredStyle: .alert)

        let setting = UIAlertAction(title: "Настройки", style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString),
               UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }

        let ok = UIAlertAction(title: "Отмена",
                               style: .default)
        [setting, ok].forEach {
            alert.addAction($0)
        }

        return alert
    }

    public func makeRestrictedViewController() -> UIViewController {
        let alert = UIAlertController(title: "Нет доступа к геолокации",
                                      message: nil,
                                      preferredStyle: .alert)

        let ok = UIAlertAction(title: "Ясно",
                               style: .default)
        alert.addAction(ok)

        return alert
    }
}
