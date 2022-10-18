//
//  WeatherDependencyContainer.swift
//  WeatherUIKit
//
//  Created by Павел Барташов on 24.09.2022.
//

import WeatherKit
import Combine

public final class WeatherDependencyContainer {

    // MARK: - Properties
    private let contextProvider: CoreDataContextProvider
    private let unitsFormatterContainer: UnitsFormatterContainer
    private let removePageResponder: RemovePageResponder


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

    public init(contextProvider: CoreDataContextProvider,
                removePageResponder: RemovePageResponder,
                unitsFormatterContainer: UnitsFormatterContainer = UnitsFormatterContainer()
    ) {
        self.contextProvider = contextProvider
        self.removePageResponder = removePageResponder
        self.unitsFormatterContainer = unitsFormatterContainer
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

        return WeathersViewController(viewModel: viewModel,
                                      hourlyWeatherViewControllerFactory: self,
                                      dailyWeatherViewControllerFactory: self)
//                                     weatherFormatter: viewModel)
    }

    func makeWeartherViewModel(for location: WeatherLocation) -> WeathersViewModel {
        let repository = WeatherRepository(context: contextProvider.backgroundContext)
        return WeathersViewModel(location: location,
                                 weatherRepository: repository,
                                 unitsFormatterContainer: unitsFormatterContainer,
                                 removePageResponder: removePageResponder)
    }

    func makeHourlyWeatherViewController(for city: String,
                                         weathers: AnyPublisher<[WeatherViewModel], Never>
    ) -> HourlyWeatherViewController {
        let viewModel = makeHourlyWeartherViewModel(for: city, weathers: weathers)
        return HourlyWeatherViewController(viewModel: viewModel)
    }

    func makeHourlyWeartherViewModel(for city: String,
                                     weathers: AnyPublisher<[WeatherViewModel], Never>
    ) -> HourlyWeatherViewModel {
        HourlyWeatherViewModel(cityName: city, weathers: weathers)
    }

    func makeDailyWeatherViewController(for location: WeatherLocation,
                                        weathers: AnyPublisher<[WeatherViewModel], Never>
    ) -> DailyWeatherViewController {
        let viewModel = makeDailyWeartherViewModel(for: location, weathers: weathers)
        return DailyWeatherViewController(viewModel: viewModel)
    }

    func makeDailyWeartherViewModel(for location: WeatherLocation,
                                     weathers: AnyPublisher<[WeatherViewModel], Never>
    ) -> DailyWeatherViewModel {
        DailyWeatherViewModel(location: location,
                              weathers: weathers,
                              unitsFormatterContainer: unitsFormatterContainer)
    }
}

extension WeatherDependencyContainer: HourlyWeatherViewControllerFactory { }
extension WeatherDependencyContainer: DailyWeatherViewControllerFactory { }
