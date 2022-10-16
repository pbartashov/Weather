//
//  WeatherViewModel.swift
//  WeatherKit
//
//  Created by Павел Барташов on 02.10.2022.
//

public struct WeatherViewModel {

    // MARK: - Properties

    private let weather: Weather
    private let formatter: WeartherFormatterProtocol
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

    public var timestamp: Date {
        weather.datetimeEpoch
    }

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

    public var precipprob: String {
        formatter.format(precipprob: weather.precipprob)
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

    public var tempmaxUnsigned: String {
        formatter.format(unsignedTemperature: weather.tempmax)
    }


    public var tempmin: String {
        formatter.format(temperature: weather.tempmin)
    }

//    public var feelslikeFormatted: String {
//        "По ощущению \(feelslike)"
//    }

    public var feelslike: String {
        formatter.format(temperature: weather.feelslike)
    }

    public var conditions: String {
        weather.conditions
    }

    public var uvIndex: String {
        formatter.format(uvIndex: weather.uvIndex)
    }

    public var moonphase: String {
        formatter.format(moonphase: weather.moonphase)
    }

    public var moonriseEpoch: String {
        guard let moonriseEpoch = weather.moonriseEpoch else { return "_" }
        return formatter.format(time: moonriseEpoch)
    }

    public var moonsetEpoch: String {
        guard let moonsetEpoch = weather.moonsetEpoch else { return "_" }
        return formatter.format(time: moonsetEpoch)
    }

    public var sunDuratuion: String {
        formatter.format(fromDate: weather.sunriseEpoch, toDate: weather.sunsetEpoch)
    }

    public var moonDuration: String {
        guard let moonriseEpoch = weather.moonriseEpoch,
              let moonsetEpoch = weather.moonsetEpoch else { return "_" }
        return formatter.format(fromDate: moonriseEpoch, toDate: moonsetEpoch)
    }

    public var icon: WeatherIcon {
        WeatherIcon(rawValue: weather.icon) ?? .none
    }

    public var isHighLighted: Bool {
        let weatherHour = Calendar.current.component(.hour, from: weather.datetimeEpoch)
        let nowHour = Calendar.current.component(.hour, from: .now)
        return weatherHour == nowHour
    }

    public var isNoon: Bool {
        weatherLocalHour == 12
    }

    public var isMidnight: Bool {
        weatherLocalHour == 0
    }

    public var weatherLocalHour: Int {
        formatter.getWeatherLocalHour(from: weather.datetimeEpoch)
    }



//    public var hours: [Weather]?


    // MARK: - Views

    // MARK: - LifeCicle

    public init(weather: Weather,
         formatter: WeartherFormatterProtocol
    ) {
        self.weather = weather
        self.formatter = formatter
    }

    // MARK: - Metods



}


extension WeatherViewModel: Hashable {
    public static func == (lhs: WeatherViewModel, rhs: WeatherViewModel) -> Bool {
        lhs.uuid == rhs.uuid
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(weather)
        hasher.combine(uuid)
    }
}
