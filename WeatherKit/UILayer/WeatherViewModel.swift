//
//  WeatherViewModel.swift
//  WeatherKit
//
//  Created by Павел Барташов on 02.10.2022.
//

import Foundation

public struct WeatherViewModel {

    // MARK: - Properties

    private let weather: Weather
    private let formatter: UnitsFormatter


//    public var weatherType: WeatherType {
//        weather.weatherType
//    }

//    public var longitude: Double {
//        weather.longitude
//    }
//
//    public var latitude: Double {
//        weather.latitude
//    }

    public var humidity: String {
        formatter.format(humidity: weather.humidity)
    }

    public var cloudcover: String {
        formatter.format(cloudcover: weather.cloudcover)
    }

    public var windspeed: String {
        formatter.format(speed: weather.windspeed)
    }

    public var sunriseEpoch: String {
        formatter.format(time: weather.sunriseEpoch)
    }

    public var sunsetEpoch: String {
        formatter.format(time: weather.sunsetEpoch)
    }

    public var datetimeEpoch: String {
        formatter.format(dateTime: weather.datetimeEpoch)
    }

    public var time: String {
        formatter.format(time: weather.datetimeEpoch)
    }

    public var temp: String {
        formatter.format(temperature: weather.temp)
    }

    public var tempmax: String {
        formatter.format(temperature: weather.tempmax)
    }

    public var tempmin: String {
        formatter.format(temperature: weather.tempmin)
    }
    
    public var conditions: String {
        weather.conditions
    }

//    public var hours: [Weather]?


    // MARK: - Views

    // MARK: - LifeCicle

    public init(weather: Weather,
         formatter: UnitsFormatter
    ) {
        self.weather = weather
        self.formatter = formatter
    }

    // MARK: - Metods



}


extension WeatherViewModel: Hashable {
//    public static func == (lhs: WeatherViewModel, rhs: WeatherViewModel) -> Bool {
//        lhs.weather == rhs.weather
//    }
//    
//    public func hash(into hasher: inout Hasher) {
//        hasher.combine(weather)
//        hasher.combine(formatter)
//    }
}
