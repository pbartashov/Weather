//
//  UnitsFormatterContainer.swift
//  WeatherKit
//
//  Created by Павел Барташов on 02.10.2022.
//

import Combine

public final class UnitsFormatterContainer {

    // MARK: - Properties

    private let settings: Settings
    private var timeFormat: Settings.TimeFormat? {
        didSet {
            configureDateFormatters()
        }
    }
    private var timeZone: String? {
        didSet {
            configureDateFormatters()
        }
    }

    private var subscriptions = Set<AnyCancellable>()

    var didChangedPublisher: AnyPublisher<Void, Never> {
        Publishers.MergeMany(
            $timeFormatter.eraseTypeAndDuplicates(),
            $datetimeFormatter.eraseTypeAndDuplicates(),
            $dayMonthFormatter.eraseTypeAndDuplicates(),
            $temperatureFormatter.eraseTypeAndDuplicates(),
            $speedFormatter.eraseTypeAndDuplicates(),
            $speedUnits.eraseTypeAndDuplicates(),
            $windDirectionFormatter.eraseTypeAndDuplicates(),
            $moonphaseFormatter.eraseTypeAndDuplicates(),
            $calendar.eraseTypeAndDuplicates()
        )
        .debounce(for: .seconds(0.1), scheduler: RunLoop.current)
        .eraseToAnyPublisher()
    }
    
    @Published private(set) var timeFormatter: DateFormatter?
    @Published private(set) var datetimeFormatter: DateFormatter?
    @Published private(set) var dayMonthFormatter: DateFormatter?
    @Published private(set) var weekDayMonthFormatter: DateFormatter?

    @Published private(set) var temperatureFormatter: MeasurementFormatter?
    @Published private(set) var speedFormatter: MeasurementFormatter?

    @Published private(set) var speedUnits: UnitSpeed?

    @Published private(set) var windDirectionFormatter: WindDirectionFormatter = WindDirectionFormatter()
    @Published private(set) var moonphaseFormatter: MoonphaseFormatter = MoonphaseFormatter()

    @Published private(set) var calendar: Calendar?

    // MARK: - LifeCicle
    public init(settings: Settings = Settings.shared) {
        self.settings = settings
        bindToSettings()
    }

    // MARK: - Metods

    private func bindToSettings() {
        func bindToSettingsTemperature() {
            settings.$temperature
                .sink { [weak self] format in
                    guard let self = self else { return }
                    self.configureTemperatureFormatters(with: format)
                }
                .store(in: &subscriptions)
        }

        func bindToSettingsSpeed() {
            settings.$speed
                .sink { [weak self] format in
                    guard let self = self else { return }
                    self.configureSpeedFormatters(with: format)
                }
                .store(in: &subscriptions)
        }

        func bindToSettingsTimeFormat() {
            settings.$timeFormat
                .sink { [weak self] format in
                    guard let self = self else { return }
                    self.timeFormat = format
                }
                .store(in: &subscriptions)
        }

        bindToSettingsTemperature()
        bindToSettingsSpeed()
        bindToSettingsTimeFormat()
    }

    private func configureTemperatureFormatters(with format: Settings.Temperature) {
        let formatter = MeasurementFormatter()

        switch format {
            case .celcius:
                formatter.locale = Locale(identifier: "ru_RU")
                formatter.unitOptions = .temperatureWithoutUnit

            case .farenheit:
                formatter.locale = Locale(identifier: "en_US")
        }

        formatter.unitStyle = .short
        formatter.numberFormatter.maximumFractionDigits = 0

        temperatureFormatter = formatter
    }

    private func configureSpeedFormatters(with format: Settings.Speed) {
        let formatter = MeasurementFormatter()

        switch format {
            case .kilometers:
                formatter.locale = Locale(identifier: "ru_RU")
                speedUnits = .metersPerSecond

            case .miles:
                formatter.locale = Locale(identifier: "en_US")
                speedUnits = .milesPerHour
        }

        formatter.unitStyle = .medium
        formatter.unitOptions = .providedUnit
        formatter.numberFormatter.maximumFractionDigits = 1

        speedFormatter = formatter
    }

    private func configureDateFormatters() {
        let timeFormatter = DateFormatter()

        let datetimeFormatter = DateFormatter()
        datetimeFormatter.locale = Locale(identifier: "ru_RU")

        let dayMonthFormatter = DateFormatter()

        let weekDayMonthFormatter = DateFormatter()
        weekDayMonthFormatter.locale = Locale(identifier: "ru_RU")

        var calendar = Calendar(identifier: .iso8601)

        if let timeZoneID = timeZone,
           let newTimeZone = TimeZone(identifier: timeZoneID){
            timeFormatter.timeZone = newTimeZone
            datetimeFormatter.timeZone = newTimeZone
            dayMonthFormatter.timeZone = newTimeZone
            weekDayMonthFormatter.timeZone = newTimeZone
            calendar.timeZone = newTimeZone
        }

        dayMonthFormatter.dateFormat = "dd/MM"
        weekDayMonthFormatter.dateFormat = "E dd/MM"

        if case .format12 = timeFormat {
            timeFormatter.dateFormat = "hh:mm a"
            datetimeFormatter.dateFormat = "hh:mm a, E dd MMMM"
        } else {
            timeFormatter.dateFormat = "HH:mm"
            datetimeFormatter.dateFormat = "HH:mm, E dd MMMM"
        }

        self.timeFormatter = timeFormatter
        self.datetimeFormatter = datetimeFormatter
        self.dayMonthFormatter = dayMonthFormatter
        self.weekDayMonthFormatter = weekDayMonthFormatter
        self.calendar = calendar
    }

    func makeUnitsFormatter() -> UnitsFormatter? {
        guard
            let timeFormatter = timeFormatter,
            let datetimeFormatter = datetimeFormatter,
            let dayMonthFormatter = dayMonthFormatter,
            let weekDayMonthFormatter = weekDayMonthFormatter,
            let temperatureFormatter = temperatureFormatter,
            let speedFormatter = speedFormatter,
            let speedUnits = speedUnits,
            let calendar = calendar
        else {
            return nil
        }

        return UnitsFormatter(timeFormatter: timeFormatter,
                              datetimeFormatter: datetimeFormatter,
                              dayMonthFormatter: dayMonthFormatter,
                              weekDayMonthFormatter: weekDayMonthFormatter,
                              temperatureFormatter: temperatureFormatter,
                              speedFormatter: speedFormatter,
                              speedUnits: speedUnits,
                              windDirectionFormatter: windDirectionFormatter,
                              moonphaseFormatter: moonphaseFormatter,
                              calendar: calendar)
    }

    func setup(timeZone: String) {
        self.timeZone = timeZone
    }
}
