//
//  UnitsFormatter.swift
//  WeatherKit
//
//  Created by Павел Барташов on 01.10.2022.
//

import Combine

public final class UnitsFormatter {

    // MARK: - Properties
//    let settings: Settings

//    private var subscriptions = Set<AnyCancellable>()
//    private var didChanged = CurrentValueSubject<Void, Never>(())
//    var didChangedPublisher: AnyPublisher<Void, Never> {
//        didChanged
//            .debounce(for: .seconds(0.1), scheduler: RunLoop.current)
//            .eraseToAnyPublisher()
//    }

//    private var didChanged = PassthroughSubject<Void, Never>()
//    var didChangedPublisher: AnyPublisher<Void, Never> {
//        didChanged.eraseToAnyPublisher()
//    }

    private let timeFormatter: DateFormatter
//    = {
//        let timeFormatter = DateFormatter()
//        timeFormatter.locale = Locale(identifier: "en_US_POSIX")
//        timeFormatter.timeZone = .init(abbreviation: "GMT")
//
//        return timeFormatter
//    }()

    private let datetimeFormatter: DateFormatter
//    = {
//        let datetimeFormatter = DateFormatter()
//        datetimeFormatter.locale = Locale(identifier: "ru_RU")
//
//        return datetimeFormatter
//    }()

    private let dayMonthFormatter: DateFormatter

    private var temperatureFormatter: MeasurementFormatter

    private var speedFormatter: MeasurementFormatter

    private var speedUnits: UnitSpeed

    // MARK: - Views

    // MARK: - LifeCicle
//    public init(settings: Settings = Settings.shared) {
//        self.settings = settings
//
//        bindToSettings()
//    }


    public init(timeFormatter: DateFormatter,
                datetimeFormatter: DateFormatter,
                dayMonthFormatter: DateFormatter,
                temperatureFormatter: MeasurementFormatter,
                speedFormatter: MeasurementFormatter,
                speedUnits: UnitSpeed
    ) {
        self.timeFormatter = timeFormatter
        self.datetimeFormatter = datetimeFormatter
        self.dayMonthFormatter = dayMonthFormatter
        self.temperatureFormatter = temperatureFormatter
        self.speedFormatter = speedFormatter
        self.speedUnits = speedUnits
    }

    // MARK: - Metods

//
//
//
//    private func bindToSettings() {
//         func bindToSettingsTemperature() {
//            settings.$temperature
//               .sink { [weak self] format in
//                   guard let self = self else { return }
//                   self.configureTemperatureFormatters(with: format)
//                   self.didChanged.send()
//                }
//                .store(in: &subscriptions)
//        }
//
//        func bindToSettingsSpeed() {
//            settings.$speed
//                .sink { [weak self] format in
//                    guard let self = self else { return }
//                    self.configureSpeedFormatters(with: format)
//                    self.didChanged.send()
//                }
//                .store(in: &subscriptions)
//        }
//
//        func bindToSettingsTimeFormat() {
//            settings.$timeFormat
//                .sink { [weak self] format in
//                    guard let self = self else { return }
//                    self.configureDateFormatters(with: format)
//                    self.didChanged.send()
//                }
//                .store(in: &subscriptions)
//        }
//
//        //        func bindToSettingsNotificationsState() {
//        //            settings.$notificationsState
//        //                .receive(on: DispatchQueue.main)
//        //                .sink { [weak self] format in
//        //                    self?.configureNotificationss(format: format)
//        //                }
//        //                .store(in: &subscriptions)
//        //        }
//
//
//        bindToSettingsTemperature()
//        bindToSettingsSpeed()
//        bindToSettingsTimeFormat()
//
//
//    }
//
//
//    private func configureTemperatureFormatters(with format: Settings.Temperature) {
//        let formatter = MeasurementFormatter()
//
//        switch format {
//            case .celcius:
//                formatter.locale = Locale(identifier: "ru_RU")
//                formatter.unitOptions = .temperatureWithoutUnit
//
//            case .farenheit:
//                formatter.locale = Locale(identifier: "en_US")
//        }
//
//        formatter.unitStyle = .short
//         formatter.numberFormatter.maximumFractionDigits = 0
//
//
//
//        print("configureTemperatureFormatters \(format)")
//
//        temperatureFormatter = formatter
//    }
//
////    private func makeTemperatureFormatters(with format: Settings.Temperature) -> MeasurementFormatter {
////        let formatter = MeasurementFormatter()
////
////        switch format {
////            case .celcius:
////                formatter.locale = Locale(identifier: "ru_RU")
////
////            case .farenheit:
////                formatter.locale = Locale(identifier: "en_US")
////        }
////
////        formatter.unitStyle = .short
////        formatter.unitOptions = .temperatureWithoutUnit
////        formatter.numberFormatter.maximumFractionDigits = 0
////
////        return formatter
//    //
//    //    }
//
//    private func configureSpeedFormatters(with format: Settings.Speed) {
//        let formatter = MeasurementFormatter()
//
//        switch format {
//            case .kilometers:
//                formatter.locale = Locale(identifier: "ru_RU")
//                speedUnits = .metersPerSecond
//
//            case .miles:
//                formatter.locale = Locale(identifier: "en_US")
//                speedUnits = .milesPerHour
//        }
//
//        formatter.unitStyle = .medium
//        formatter.unitOptions = .providedUnit
//        formatter.numberFormatter.maximumFractionDigits = 1
//
//        speedFormatter = formatter
//    }
//
//    private func configureDateFormatters(with format: Settings.TimeFormat) {
//        if case .format12 = format {
//            timeFormatter.dateFormat = "hh:mm a"
//            datetimeFormatter.dateFormat = "hh:mm a, E dd MMMM"
//        } else {
//            timeFormatter.dateFormat = "HH:mm"
//            datetimeFormatter.dateFormat = "HH:mm, E dd MMMM"
//            //            timestampFormatter.dateStyle = .medium
//            //            timestampFormatter.timeStyle = .short
//        }
//
////        guard let currentWeather = currentWeather
////                //              let timezone = currentWeather.timezone
////        else { return }
//
//        //        timeFormatter.timeZone = TimeZone(identifier: currentWeather.timezone)
//        //        timestampFormatter.timeZone = TimeZone(identifier: currentWeather.timezone)
//    }
//
//
////    func format(temperature : Double) -> String {
////
////    }
}

extension UnitsFormatter: WeartherFormatterProtocol {
    public func format(temperature: Double) -> String {
        //  "\(temperature)\(Settings.shared.temperatureSymbol)"

        print("format(temperature: Double)")

        print(Date(timeIntervalSince1970: 0))

        return temperatureFormatter.string(from: Measurement(value: temperature, unit: UnitTemperature.celsius))
    }

    public func format(speed: Double) -> String {
//        "\(String(format: "%.0f", speed)) \(Settings.shared.speedSymbol)"



//print(speed)


//        guard let speedUnits = speedUnits else { return "" }

        var metersPerSecond = Measurement(value: speed, unit: UnitSpeed.kilometersPerHour)
        metersPerSecond.convert(to: speedUnits)
//        measurementFormatter.unitOptions = .providedUnit

        return speedFormatter.string(from: metersPerSecond)
    }

    public func format(time: Date) -> String {

        print(time)
        return timeFormatter.string(from: time)
    }

    public func format(dateTime: Date) -> String {
        datetimeFormatter.string(from: dateTime)
    }

    public func format(dayMonth: Date) -> String {
        dayMonthFormatter.string(from: dayMonth)
    }

    public func format(cloudcover: Double) -> String {
        "\(String(format: "%.0f", cloudcover))"
    }

    public func format(humidity: Double) -> String {
        "\(String(format: "%.0f", humidity))%"
    }

    public func format(precipcover: Double) -> String {
        "\(String(format: "%.0f", precipcover))%"
    }



}

extension UnitsFormatter: Hashable {
    public static func == (lhs: UnitsFormatter, rhs: UnitsFormatter) -> Bool {
        lhs.timeFormatter == rhs.timeFormatter &&
        lhs.datetimeFormatter == rhs.datetimeFormatter &&
        lhs.temperatureFormatter == rhs.temperatureFormatter &&
        lhs.speedFormatter == rhs.speedFormatter &&
        lhs.speedUnits == rhs.speedUnits
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(timeFormatter)
        hasher.combine(datetimeFormatter)
        hasher.combine(temperatureFormatter)
        hasher.combine(speedFormatter)
        hasher.combine(speedUnits)
    }
}
