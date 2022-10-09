//
//  WeatherViewModel.swift
//  WeatherKit
//
//  Created by Павел Барташов on 02.10.2022.
//

public struct WeatherViewModel {

    // MARK: - Properties

    private let weather: Weather
    private let formatter: UnitsFormatter
    private let uuid = UUID()


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

    public var cloudcoverWithPercentSign: String {
        formatter.format(cloudcoverWithPercentSign: weather.cloudcover)
    }

    public var windspeed: String {
        formatter.format(speed: weather.windspeed)
    }

    public var windDirection: String {
        formatter.format(windDirection: weather.winddir)
    }

    public var precipcover: String {
        formatter.format(precipcover: weather.precipcover)
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

    public var dayMonth: String {
        formatter.format(dayMonth: weather.datetimeEpoch)
    }

    public var weekDayMonth: String {
        formatter.format(weekDayMonth: weather.datetimeEpoch)
    }

    public var time: String {
        formatter.format(time: weather.datetimeEpoch)
    }

    public var tempValue: Double {
        weather.temp
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

    public var feelslike: String {
        formatter.format(feelslike: weather.feelslike)
    }
    
    public var conditions: String {
        weather.conditions
    }




    public var icon: WeatherIcon {
        WeatherIcon(rawValue: weather.icon) ?? .none
    }

    public var isHighLighted: Bool {
        let weatherHour = Calendar.current.component(.hour, from: weather.datetimeEpoch)
        let nowHour = Calendar.current.component(.hour, from: .now)

        return weatherHour == nowHour
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
