//
//  WeatherViewModel.swift
//  WeatherKit
//
//  Created by Павел Барташов on 24.09.2022.
//

import Combine
import Foundation

public final class WeathersViewModel: ViewModel {

    public enum ForecastTimeHorizon {
        case small
        case large
    }

    // MARK: - Properties

    private let formatterContainer: UnitsFormatterContainer
    private let weatherRepository: WeatherRepositoryProtocol

    @Published public private(set) var location: WeatherLocation
    @Published public private(set) var currentWeather: WeatherViewModel?
    @Published public private(set) var hourlyWeather: [WeatherViewModel] = []
    @Published public private(set) var dailyWeather: [WeatherViewModel] = []
    @Published public private(set) var forecastHorizon: ForecastTimeHorizon = .small

    public var toggleForecastHorizonTitle: String {
        switch forecastHorizon {
            case .small:
                return "\(forecastHorizon.dayForLarge)"

            case .large:
                return "\(forecastHorizon.dayForSmall)"
        }
    }

    private var toggleForecastTimeHorizonSubscription: AnyCancellable?
    private var removePageSubscription: AnyCancellable?

    private let removePageResponder: RemovePageResponder

    // MARK: - LifeCicle

    public init(
        location: WeatherLocation,
        weatherRepository: WeatherRepositoryProtocol,
        unitsFormatterContainer: UnitsFormatterContainer,
        removePageResponder: RemovePageResponder

    ) {
        self.location = location
        self.weatherRepository = weatherRepository
        self.formatterContainer = unitsFormatterContainer
        self.removePageResponder = removePageResponder

        super.init()
        
        if let timeZone = location.timeZone {
            self.formatterContainer.setup(timeZone: timeZone)
        }

        bindToRepository()
    }
    
    // MARK: - Metods

    private func bindToRepository() {
        let formatterPublisher = formatterContainer.didChangedPublisher
            .compactMap { [weak self] in
                self?.formatterContainer.makeUnitsFormatter()
            }

        weatherRepository.weathersPublisher
            .compactMap { $0[.current]?.first }
            .combineLatest(formatterPublisher)
            .map { (weather, formatter) in
                WeatherViewModel(weather: weather, formatter: formatter)
            }
            .assign(to: &$currentWeather)

        weatherRepository.weathersPublisher
            .compactMap { $0[.hourly] }
            .combineLatest(formatterPublisher)
            .map { (weathers, formatter) in
                Array(weathers
                    .prefix(24)
                    .map { WeatherViewModel(weather: $0, formatter: formatter) }
                )
            }
            .assign(to: &$hourlyWeather)

        weatherRepository.weathersPublisher
            .compactMap { $0[.daily] }
            .combineLatest(formatterPublisher, $forecastHorizon)
            .map { (weathers, formatter, horizon) in
                Array(weathers
                    .prefix(horizon.days)
                    .map { WeatherViewModel(weather: $0, formatter: formatter) }
                )
            }
            .assign(to: &$dailyWeather)

        weatherRepository.weatherPackPublisher
            .map(\.timezone)
        //            .assign(to: \.timeZone, on: location)
            .sink { [weak self] in
                guard let self = self else { return }
                self.location.timeZone = $0
                self.formatterContainer.setup(timeZone: $0)
            }
            .store(in: &subscriptions)
    }

    public func fetchWeathers() async {
        do {
            try await weatherRepository.startFetchingWeather(for: location, dateInterval: forecastHorizon.dateInterval)
        } catch {
            errorMessagesSubject.send(error)
        }
    }

    private func fetchDailyWeather() async {
        do {
            try await weatherRepository.fetchForecastWeatherFromAPI(for: location,
                                                                    dateInterval: forecastHorizon.dateInterval)
        } catch {
            errorMessagesSubject.send(error)
        }
    }

    public func subscribeToggleForecastHorizon(to publisher: AnyPublisher<Void, Never>) {
        toggleForecastTimeHorizonSubscription = publisher
            .sink {[weak self] in
                self?.toggleForecastHorizon()
            }
    }

    public func subscribeRemovePage(to publisher: AnyPublisher<Void, Never>) {
        removePageSubscription = publisher
            .sink {[weak self] in
                guard let self = self else { return }
                self.removePageResponder.remove(location: self.location)
            }
    }

    private func toggleForecastHorizon() {
        switch forecastHorizon {
            case .small:
                Task {
                    forecastHorizon = .large
                    await fetchDailyWeather()
                }

            case .large:
                forecastHorizon = .small
        }
    }
}

fileprivate extension WeathersViewModel.ForecastTimeHorizon {
    var dayForSmall: Int { 7 }
    var dayForLarge: Int { 14 }

    var dateInterval: DateInterval {
        let start: Date = .now + .days(1)
        let end = start + .days(days - 1)

        return DateInterval(start: start, end: end)
    }

    var days: Int {
        switch self {
            case .small:
                return dayForSmall

            case .large:
                return dayForLarge
        }
    }
}

fileprivate extension TimeInterval {
    static func days(_ count: Int) -> TimeInterval {
        return 60 * 60 * 24 * Double(count)
    }
}
