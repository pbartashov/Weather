//
//  UnitsFormatter.swift
//  WeatherKit
//
//  Created by Павел Барташов on 01.10.2022.
//

import Combine

public final class UnitsFormatter {

    // MARK: - Properties

    private let timeFormatter: DateFormatter
    private let datetimeFormatter: DateFormatter
    private let dayMonthFormatter: DateFormatter
    private let weekDayMonthFormatter: DateFormatter

    private let temperatureFormatter: MeasurementFormatter
    private let speedFormatter: MeasurementFormatter

    private let speedUnits: UnitSpeed

    private let windDirectionFormatter: WindDirectionFormatter
    private let moonphaseFormatter: MoonphaseFormatter

    private let calendar: Calendar

    // MARK: - LifeCicle

    public init(timeFormatter: DateFormatter,
                datetimeFormatter: DateFormatter,
                dayMonthFormatter: DateFormatter,
                weekDayMonthFormatter: DateFormatter,
                temperatureFormatter: MeasurementFormatter,
                speedFormatter: MeasurementFormatter,
                speedUnits: UnitSpeed,
                windDirectionFormatter: WindDirectionFormatter,
                moonphaseFormatter: MoonphaseFormatter,
                calendar: Calendar
    ) {
        self.timeFormatter = timeFormatter
        self.datetimeFormatter = datetimeFormatter
        self.dayMonthFormatter = dayMonthFormatter
        self.weekDayMonthFormatter = weekDayMonthFormatter
        self.temperatureFormatter = temperatureFormatter
        self.speedFormatter = speedFormatter
        self.speedUnits = speedUnits
        self.windDirectionFormatter = windDirectionFormatter
        self.moonphaseFormatter = moonphaseFormatter
        self.calendar = calendar
    }
}

extension UnitsFormatter: WeartherFormatterProtocol {
    public func format(temperature: Double) -> String {
        var rounded = temperature.rounded()
        if rounded == -0.0 {
            rounded = 0.0
        }

        return temperatureFormatter.string(from: Measurement(value: rounded, unit: UnitTemperature.celsius))
    }

    public func format(unsignedTemperature: Double) -> String {
        let unsigned = unsignedTemperature.magnitude

        return temperatureFormatter.string(from: Measurement(value: unsigned, unit: UnitTemperature.celsius))
    }

    public func format(feelslike: Double) -> String {
        temperatureFormatter.string(from: Measurement(value: feelslike, unit: UnitTemperature.celsius))
    }

    public func format(speed: Double) -> String {
        var metersPerSecond = Measurement(value: speed, unit: UnitSpeed.kilometersPerHour)
        metersPerSecond.convert(to: speedUnits)

        return speedFormatter.string(from: metersPerSecond)
    }

    public func format(windDirection: Double) -> String {
        windDirectionFormatter.string(from: windDirection)
    }

    public func format(time: Date) -> String {
        return timeFormatter.string(from: time)
    }

    public func format(dateTime: Date) -> String {
        datetimeFormatter.string(from: dateTime)
    }

    public func format(dayMonth: Date) -> String {
        dayMonthFormatter.string(from: dayMonth)
    }

    public func format(weekDayMonth: Date) -> String {
        weekDayMonthFormatter.string(from: weekDayMonth).lowercased()
    }

    public func format(cloudcover: Double) -> String {
        "\(String(format: "%.0f", cloudcover))"
    }

    public func format(cloudcoverWithPercentSign: Double) -> String {
        "\(format(cloudcover: cloudcoverWithPercentSign))%"
    }

    public func format(humidity: Double) -> String {
        "\(String(format: "%.0f", humidity))%"
    }

    public func format(precipprob: Double) -> String {
        "\(String(format: "%.0f", precipprob))%"
    }

    public func format(uvIndex: Double) -> String {
        String(format: "%.1f", uvIndex)
    }

    public func format(moonphase: Double) -> String {
        moonphaseFormatter.string(from: moonphase)
    }

    public func format(fromDate: Date, toDate: Date) -> String {
        let diffComponents = calendar.dateComponents([.hour, .minute], from: fromDate, to: toDate)
        return "\(diffComponents.hour ?? 0) ч \(diffComponents.minute ?? 0) мин"
    }

    public func getWeatherLocalHour(from date: Date) -> Int {
        calendar.component(.hour, from: date)
    }
}

extension UnitsFormatter: Hashable {
    public static func == (lhs: UnitsFormatter, rhs: UnitsFormatter) -> Bool {
        lhs.timeFormatter == rhs.timeFormatter &&
        lhs.datetimeFormatter == rhs.datetimeFormatter &&
        lhs.temperatureFormatter == rhs.temperatureFormatter &&
        lhs.speedFormatter == rhs.speedFormatter &&
        lhs.speedUnits == rhs.speedUnits &&
        lhs.dayMonthFormatter == rhs.dayMonthFormatter &&
        lhs.speedUnits == rhs.weekDayMonthFormatter &&
        lhs.windDirectionFormatter == rhs.windDirectionFormatter &&
        lhs.moonphaseFormatter == rhs.moonphaseFormatter &&
        lhs.calendar == rhs.calendar
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(timeFormatter)
        hasher.combine(datetimeFormatter)
        hasher.combine(temperatureFormatter)
        hasher.combine(speedFormatter)
        hasher.combine(speedUnits)
        hasher.combine(dayMonthFormatter)
        hasher.combine(weekDayMonthFormatter)
        hasher.combine(windDirectionFormatter)
        hasher.combine(moonphaseFormatter)
        hasher.combine(calendar)
    }
}
