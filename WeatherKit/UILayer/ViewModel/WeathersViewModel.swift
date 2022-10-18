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
//    private lazy var formatterPublisher = CurrentValueSubject<UnitsFormatter, Never>(formatter)
//    public let timeFormatter: DateFormatter = {
//        let timeFormatter = DateFormatter()
//        timeFormatter.locale = Locale(identifier: "en_US_POSIX")
//
//        return timeFormatter
//    }()
//
//    public let datetimeFormatter: DateFormatter = {
//        let datetimeFormatter = DateFormatter()
//        datetimeFormatter.locale = Locale(identifier: "ru_RU")
//
//        return datetimeFormatter
//    }()

    @Published public private(set) var location: WeatherLocation

    @Published public private(set) var forecastHorizon: ForecastTimeHorizon = .small
//    {
//        didSet {
//            reloadDailyWeather()
//        }
//    }

    public var toggleForecastHorizonTitle: String {
        switch forecastHorizon {
            case .small:
                return "\(forecastHorizon.dayForLarge)"

            case .large:
                return "\(forecastHorizon.dayForSmall)"
        }
    }

    @Published public private(set) var currentWeather: WeatherViewModel?
    @Published public private(set) var hourlyWeather: [WeatherViewModel] = []
    @Published public private(set) var dailyWeather: [WeatherViewModel] = []

    private var toggleForecastTimeHorizonSubscription: AnyCancellable?
    private var removePageSubscription: AnyCancellable?

    private let weatherRepository: WeatherRepositoryProtocol

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
//        bindToFormatters()

//        configureDateFormatters(format: Settings.shared.timeFormat)

        
        //        Task {
        //            await self.fetchCurrentWeather(latitude: 63,
        //                                      longitude: 43)
        //        }





        
    }
    
    // MARK: - Metods

//    private func bindToSettings() {
//        let settings = Settings.shared
//
//        func bindToSettingsTemperature() {
//            settings.$temperature
//                .receive(on: DispatchQueue.main)
//                .sink { [weak self] format in
//                    self?.configureTemperatureFormatters(with: format)
//                }
//                .store(in: &subscriptions)
//        }
//
//        func bindToSettingsSpeed() {
//            settings.$speed
//                .receive(on: DispatchQueue.main)
//                .sink { [weak self] format in
//                    self?.configureSpeedFormatters(with: format)
//                }
//                .store(in: &subscriptions)
//        }
//
//        func bindToSettingsTimeFormat() {
//            settings.$timeFormat
//                .receive(on: DispatchQueue.main)
//                .sink { [weak self] format in
//                    self?.configureDateFormatters(with: format)
//                }
//                .store(in: &subscriptions)
//        }
//
////        func bindToSettingsNotificationsState() {
////            settings.$notificationsState
////                .receive(on: DispatchQueue.main)
////                .sink { [weak self] format in
////                    self?.configureNotificationss(format: format)
////                }
////                .store(in: &subscriptions)
////        }
//
//
//        bindToSettingsTemperature()
//    }

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



//    private func bindToFormatters() {timezone
//        formatter.didChangedPublisher
//            .sink {
//                formatterPublisher.send(formatter)
//        }
//    }

    public func fetchWeathers() async {
//        await fetchCurrentWeather()
//    }
//
//    private func fetchCurrentWeather(//latitude: Double,
//        //                         longitude: Double
//    ) async {
        do {
//            currentWeather = try await weatherRepository.fetchCurrentDayWeather(location: location)
//            let since: Date = .now
//            let till: Date
//
//            switch forecastTimeHorizon {
//                case .small:
//                    till = since.advanced(by: 5)
//                case.large:
//            }

            try await weatherRepository.startFetchingWeather(for: location, dateInterval: forecastHorizon.dateInterval)
//            configureDateFormatters(with: Settings.shared.timeFormat)
//            print(currentWeather)
//            print(currentWeather?.sunsetEpoch)
            //            for var animal in animalsContainer.animals {
            //                animal.toManagedObject()
            //            }
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


    //    private func reloadDailyWeather() {
//        switch forecastHorizon {
//            case .small:
//                dailyWeather = Array(dailyWeather.prefix(forecastHorizon.days))
//
//            case .large:
//                ()
//
//        }
//    }

//    private func configureTemperatureFormatters(with format: Settings.Temperature) {
//
//    }
//
//    private func configureSpeedFormatters(with format: Settings.Speed) {
//
//    }
//
//    private func configureDateFormatters(with format: Settings.TimeFormat) {
//        if case .format12 = format {
//            timeFormatter.dateFormat = "HH:mm"
//            datetimeFormatter.dateFormat = "HH:mm, DD LL"
//        } else {
//            timeFormatter.dateFormat = "hh:mm a"
//            datetimeFormatter.dateFormat = "hh:mm a, E dd MMMM"
//            //            timestampFormatter.dateStyle = .medium
//            //            timestampFormatter.timeStyle = .short
//        }
//
//        guard let currentWeather = currentWeather
//                //              let timezone = currentWeather.timezone
//        else { return }
//
//        //        timeFormatter.timeZone = TimeZone(identifier: currentWeather.timezone)
//        //        timestampFormatter.timeZone = TimeZone(identifier: currentWeather.timezone)
//    }


}

//extension Weather {
//    public var tempFormatted: String? {
////        guard let temp = temp else { return nil }
//
//        return "\(temp)\(Settings.shared.temperatureSymbol)"
//    }
//
//    public var cloudsFormatted: String? {
////        guard let clouds = clouds else { return nil }
//
//        return "\(cloudcover)"
//    }
//
//    public var humidityFormatted: String? {
////        guard let rh = rh else { return nil }
//
//        return "\(String(format: "%.0f", humidity))%"
//    }
//
//    public var windSpeedFormatted: String? {
////        guard let windSpd = windSpd else { return nil }
//
//        return "\(String(format: "%.0f", windspeed)) \(Settings.shared.speedSymbol)"
//    }
//
////    public var sunriseFormatted: String? {
////        guard let sunrise = sunrise else { return nil }
////        if case .format12 = Settings.shared.timeFormat {
////            return sunrise.formatted(date: .omitted, time: .shortened)
////        }
////
////        return sunrise.formatted(date: .omitted, time: .shortened)
////
////    }
//
////    public var sunsetFormatted: String? {
////        guard let windSpd = windSpd else { return nil }
////
////        return "\(String(format: "%.0f", windSpd))\(Settings.shared.speedSymbol)"
////    }
//
////    public var timestamp: String? {
////        guard let windSpd = windSpd else { return nil }
////
////        return "\(String(format: "%.0f", windSpd))\(Settings.shared.speedSymbol)"
////    }
//
//}

//extension WeathersViewModel: WeartherFormatterProtocol {
//    public func format(temperature: Double) -> String {
//        formatter.format(temperature: temperature)
//    }
//
//    public func format(speed: Double) -> String {
//        formatter.format(speed: speed)
//    }
//
//    public func format(time: Date) -> String {
//        formatter.format(time: time)
//    }
//
//    public func format(dateTime: Date) -> String {
//        formatter.format(dateTime: dateTime)
//    }
//
//    public func format(cloudcover: Double) -> String {
//        formatter.format(cloudcover: cloudcover)
//    }
//
//    public func format(humidity: Double) -> String {
//        formatter.format(humidity: humidity)
//    }
//
////    func formatted(weather: Weather) -> FormattedWeather {
////
////    }
//
//
//}

extension WeathersViewModel.ForecastTimeHorizon {
    var dayForSmall: Int { 7 }
    var dayForLarge: Int { 14 }

    var dateInterval: DateInterval {
        let start: Date = .now + .days(1)
//        let days: Int
//
//        switch self {
//            case .small:
//                days = dayForSmall
//            case .large:
//                days = dayForLarge
//
                #warning("25")
//        }

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

//extension Date {
//    static func + (lhs: Date, rhs: Date) -> Date {
//
//    }
//}

extension TimeInterval {
    static func days(_ count: Int) -> TimeInterval {
        return 60 * 60 * 24 * Double(count)
    }
}
