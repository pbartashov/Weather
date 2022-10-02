//
//  WeatherViewModel.swift
//  WeatherKit
//
//  Created by Павел Барташов on 24.09.2022.
//

import Combine
import Foundation

public final class WeathersViewModel {

    // MARK: - Properties

    private let formatter: UnitsFormatter
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


    public let location: WeatherLocation

    @Published public var currentWeather: WeatherViewModel?
    @Published public var hourlyWeather: [WeatherViewModel] = []
    @Published public var dailyWeather: [WeatherViewModel] = []

    public var errorMessages: AnyPublisher<Error, Never> {
        errorMessagesSubject.eraseToAnyPublisher()
    }

    private let errorMessagesSubject = PassthroughSubject<Error, Never>()

    private var subscriptions = Set<AnyCancellable>()

    private let weatherRepository: WeatherRepositoryProtocol




    // MARK: - LifeCicle

    public init(
        location: WeatherLocation,
        weatherRepository: WeatherRepositoryProtocol,
        unitsFormatter: UnitsFormatter = UnitsFormatter()

    ) {
        self.location = location
        self.weatherRepository = weatherRepository
        self.formatter = unitsFormatter

   
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
        let formatterPublisher = formatter.didChangedPublisher
            .compactMap { [weak self] in self?.formatter }

        weatherRepository
            .weathersPublisher
            .compactMap { $0[.current]?.first }
            .combineLatest(formatterPublisher)
            .map { (weather, formatter) in
                WeatherViewModel(weather: weather, formatter: UnitsFormatter())
            }
            .assign(to: &$currentWeather)

        weatherRepository
            .weathersPublisher
            .compactMap { $0[.hourly] }
            .combineLatest(formatterPublisher)
            .map { (weathers, formatter) in
                weathers.map { WeatherViewModel(weather: $0, formatter: formatter) }
            }
            .assign(to: &$hourlyWeather)

        weatherRepository
            .weathersPublisher
            .compactMap { $0[.daily] }
            .combineLatest(formatterPublisher)
            .map { (weathers, formatter) in
                weathers.map { WeatherViewModel(weather: $0, formatter: formatter) }
            }
            .assign(to: &$dailyWeather)
    }

//    private func bindToFormatters() {
//        formatter.didChangedPublisher
//            .sink {
//                formatterPublisher.send(formatter)
//        }
//    }

    public func fetchWeather() async {
//        await fetchCurrentWeather()
//    }
//
//    private func fetchCurrentWeather(//latitude: Double,
//        //                         longitude: Double
//    ) async {
        do {
//            currentWeather = try await weatherRepository.fetchCurrentDayWeather(location: location)

            try await weatherRepository.startFetchingWeather(for: location)
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
    //     public let errorPresentation = PassthroughSubject<ErrorPresentation?, Never>()



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
