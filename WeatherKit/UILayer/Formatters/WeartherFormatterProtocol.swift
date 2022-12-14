//
//  WeartherFormatterProtocol.swift
//  WeatherKit
//
//  Created by Павел Барташов on 01.10.2022.
//

public protocol WeartherFormatterProtocol {
    func format(temperature: Double) -> String
    func format(unsignedTemperature: Double) -> String
    func format(speed: Double) -> String
    func format(windDirection: Double) -> String
    func format(time: Date) -> String
    func format(dateTime: Date) -> String
    func format(dayMonth: Date) -> String
    func format(fromDate: Date, toDate: Date) -> String
    func format(weekDayMonth: Date) -> String
    func format(cloudcover: Double) -> String
    func format(cloudcoverWithPercentSign: Double) -> String
    func format(humidity: Double) -> String
    func format(precipprob: Double) -> String
    func format(uvIndex: Double) -> String
    func format(moonphase: Double) -> String

    func getWeatherLocalHour(from: Date) -> Int
}
