//
//  CurrentWeather.swift
//  WeatherKit
//
//  Created by Павел Барташов on 24.09.2022.
//

import Foundation

// MARK: - WeatherContainer
public struct WeatherContainer {
//    let queryCost: Int?
    let latitude, longitude: Double
//    let resolvedAddress, address
    let timezone: String
//    let tzoffset: Int?
    public let days: [Weather]
//    let stations: [String: Station]?
    public let currentWeather: Weather?

    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
        case timezone
        case days
        case currentWeather = "currentConditions"
    }

//    static var dateFormatterUserInfoKey: CodingUserInfoKey? {
//        return CodingUserInfoKey(rawValue: "dateFormatter")
//    }

    static var boxUserInfoKey: CodingUserInfoKey? {
        return CodingUserInfoKey(rawValue: "box")
    }


//    static var weatherTypeUserInfoKey: CodingUserInfoKey? {
//        return CodingUserInfoKey(rawValue: "weatherType")
//    }
//
//    static var longitudeUserInfoKey: CodingUserInfoKey? {
//        return CodingUserInfoKey(rawValue: "longitude")
//    }
//
//    static var latitudeUserInfoKey: CodingUserInfoKey? {
//        return CodingUserInfoKey(rawValue: "latitude")
//    }

}

extension WeatherContainer: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        latitude = try container.decodeIfPresent(Double.self, forKey: .latitude) ?? 0.0
        longitude = try container.decodeIfPresent(Double.self, forKey: .longitude) ?? 0.0

        timezone = try container.decodeIfPresent(String.self, forKey: .timezone) ?? ""

//        if let weatherTypeUserInfoKey = WeatherContainer.weatherTypeUserInfoKey {
//            jsonDecoder.userInfo[key] = WeatherType.none
//        }
//
//        if let longitudeUserInfoKey = WeatherContainer.longitudeUserInfoKey {
//            jsonDecoder.userInfo[key] = 0.0
//        }
//
//        if let latitudeUserInfoKey = WeatherContainer.latitudeUserInfoKey {
//            jsonDecoder.userInfo[key] = 0.0
//        }
//        guard let key = WeatherContainer.weatherTypeUserInfoKey,
//              let dateFormatter = decoder.userInfo[key] as? DateFormatter
//        else {
//            throw NetworkError.decoderNotConfigured
//        }

//        decoder.userInfo.updateValue(5, forKey: key)

//        dateFormatter.timeZone = TimeZone(identifier: "timezone")

        guard let key = WeatherContainer.boxUserInfoKey,
              let box = decoder.userInfo[key] as? ParserBox
        else {
            throw NetworkError.decoderNotConfigured
        }

        box.latitude = latitude
        box.longitude = longitude
        box.weatherType = .daily

        days = try container.decodeIfPresent([Weather].self, forKey: .days) ?? []

        box.weatherType = .current
        currentWeather = try container.decodeIfPresent(Weather.self, forKey: .currentWeather)
    }
}

// MARK: - Weather
public struct Weather {


    public var weatherType: WeatherType = .none
    public var longitude: Double = 0.0
    public var latitude: Double = 0.0
//    public var weatherType: WeatherType
//    public var longitude: Double
//    public var latitude: Double

    //    var lat: Int?
//    public var latitude: Double? {
//        get {
//            guard let lat = lat else {
//                return nil
//            }
//            return Double(lat / 1000)
//        }
//        set {
//            if let newValue = newValue {
//                lat = Int(newValue * 1000)
//            } else {
//                lat = nil
//            }
//
//        }
//    }
//
//    public var longitude: Double?
//    public var latitude: Double? {
//        get {
//            guard let lat = lat else {
//                return nil
//            }
//            return Double(lat / 1000)
//        }
//        set {
//            if let newValue = newValue {
//                lat = Int(newValue * 1000)
//            } else {
//                lat = nil
//            }
//
//        }
//    }

    public let humidity: Double
    public let cloudcover: Double
    public let windspeed: Double
    public let precipcover: Double
    public let sunriseEpoch, sunsetEpoch, datetimeEpoch: Date
    public let temp, tempmax, tempmin: Double
    public let conditions: String
    public let icon: String
    public let hourlyWeathers: [Weather]?


//    public init(weatherType: WeatherType = .none,
//                  longitude: Double = 0.0,
//                  latitude: Double = 0.0,
//                  humidity: Double, cloudcover: Double,
//                  windspeed: Double,
//                  sunriseEpoch: Date,
//                  sunsetEpoch: Date,
//                  datetimeEpoch: Date,
//                  temp: Double,
//                  tempmax: Double,
//                  tempmin: Double,
//                  conditions: String,
//                  hours: [Weather]?) {
//
//        self.weatherType = weatherType
//        self.longitude = longitude
//        self.latitude = latitude
//        self.humidity = humidity
//        self.cloudcover = cloudcover
//        self.windspeed = windspeed
//        self.sunriseEpoch = sunriseEpoch
//        self.sunsetEpoch = sunsetEpoch
//        self.datetimeEpoch = datetimeEpoch
//        self.temp = temp
//        self.tempmax = tempmax
//        self.tempmin = tempmin
//        self.conditions = conditions
//        self.hours = hours
//    }

    enum CodingKeys: String, CodingKey {
        case humidity
        case cloudcover
        case windspeed, precipcover
        case sunriseEpoch, sunsetEpoch, datetimeEpoch
//        case sunrise, sunset, datetime
        case temp, tempmax, tempmin
        case conditions, icon
        case hours
    }

//    enum CodingKeys: String, CodingKey {
////        case weatherDescription = "description"
//        case hours, humidity, cloudcover, windspeed
//        case temp, tempmax, tempmin
//        case sunrise, sunset, datetime
//        case conditions
//    }

}

//extension Weather {
//    public var weatherType: WeatherType {
//
//    }
//
//    public var longitude: Double
//    public var latitude: Double

extension Weather: Hashable { }

//extension Weather {
//    func filledWith(weatherType: WeatherType,
//                       longitude: Double,
//                       latitude: Double) -> Weather {
//
//        Weather(weatherType: weatherType,
//                longitude: longitude,
//                latitude: latitude,
//                humidity: humidity,
//                cloudcover: cloudcover,
//                windspeed: windspeed,
//                sunriseEpoch: sunriseEpoch,
//                sunsetEpoch: sunsetEpoch,
//                datetimeEpoch: datetimeEpoch,
//                temp: temp,
//                tempmax: tempmax,
//                tempmin: tempmin,
//                conditions: conditions,
//                hours: hours)
////
////        self.weatherType = weatherType
////        self.longitude = longitude
////        self.latitude = latitude
//
////        return self
//    }
//}

extension Weather: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        humidity = try container.decodeIfPresent(Double.self, forKey: .humidity) ?? 0.0
        cloudcover = try container.decodeIfPresent(Double.self, forKey: .cloudcover) ?? 0.0
        windspeed = try container.decodeIfPresent(Double.self, forKey: .windspeed) ?? 0.0
        temp = try container.decodeIfPresent(Double.self, forKey: .temp) ?? 0.0
        tempmax = try container.decodeIfPresent(Double.self, forKey: .tempmax) ?? 0.0
        tempmin = try container.decodeIfPresent(Double.self, forKey: .tempmin) ?? 0.0
        precipcover = try container.decodeIfPresent(Double.self, forKey: .precipcover) ?? 0.0

        conditions = try container.decodeIfPresent(String.self, forKey: .conditions) ?? ""
        icon = try container.decodeIfPresent(String.self, forKey: .icon) ?? ""

//        guard let key = WeatherContainer.dateFormatterUserInfoKey,
//              let dateFormatter = decoder.userInfo[key] as? DateFormatter
//        else {
//            throw NetworkError.decoderNotConfigured
//        }

//        let sunriseSeconds = try container.decodeIfPresent(Int.self, forKey: .sunriseEpoch) ?? 0
//        sunsetEpoch = dateFormatter.date(from: "") ?? Date(timeIntervalSince1970: 0)

//        sunsetEpoch = dateFormatter.date(from: "") ?? Date(timeIntervalSince1970: 0)

        sunriseEpoch = try container.decodeIfPresent(Date.self, forKey: .sunriseEpoch) ?? Date(timeIntervalSince1970: 0)
        sunsetEpoch = try container.decodeIfPresent(Date.self, forKey: .sunsetEpoch) ?? Date(timeIntervalSince1970: 0)
        datetimeEpoch = try container.decodeIfPresent(Date.self, forKey: .datetimeEpoch) ?? Date(timeIntervalSince1970: 0)
//        datetimeEpoch = Date()

        guard let key = WeatherContainer.boxUserInfoKey,
              let box = decoder.userInfo[key] as? ParserBox
        else {
            throw NetworkError.decoderNotConfigured
        }

        weatherType = box.weatherType
        latitude = box.latitude
        longitude = box.longitude

        print(weatherType)

        if container.contains(.hours) {
            box.weatherType = .hourly
            hourlyWeathers = try container.decode([Weather].self, forKey: .hours)
            box.weatherType = weatherType
        } else {
            hourlyWeathers = nil
        }
    }
}
//extension Weather: Decodable {
//    public init(from decoder: Decoder) throws {
//        let container = try decoder.container( keyedBy: CodingKeys.self)
//
//        humidity = try container.decode(Double.self, forKey: .humidity)
//        cloudcover = try container.decode(Double.self, forKey: .cloudcover)
//        windspeed = try container.decode(Double.self, forKey: .windspeed)
//        temp = try container.decode(Double.self, forKey: .temp)
//        tempmax = try container.decode(Double.self, forKey: .tempmax)
//        tempmin = try container.decode(Double.self, forKey: .tempmin)
//
//        conditions = try container.decode(String.self, forKey: .conditions)
//
//        let dateFormatter = DateFormatter()
//        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
//        if let timeZone = TimeZone(identifier: timezone) {
//            dateFormatter.timeZone = timeZone
//        }
//
//        dateFormatter.dateFormat = "YYYY-MM-DD HH:mm"
//        let obTimeString = try container.decode(String.self, forKey: .obTime)
//        obTime = dateFormatter.date(from: obTimeString) ?? Date()
//
//        dateFormatter.dateFormat = "HH:mm"
//
//        let sunriseString = try container.decode(String.self, forKey: .sunrise)
//        sunrise = dateFormatter.date(from: sunriseString) ?? Date()
//
//        let sunsetString = try container.decode(String.self, forKey: .sunset)
//        sunset = dateFormatter.date(from: sunsetString) ?? Date()
//
//        weather = try Weather(from: decoder)
//    }
//}

