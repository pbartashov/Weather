//
//  CurrentWeather.swift
//  WeatherKit
//
//  Created by Павел Барташов on 24.09.2022.
//

import Foundation

// MARK: - WeatherContainer
public struct WeatherContainer: Codable {
//    let queryCost: Int?
    let latitude, longitude: Double
//    let resolvedAddress, address
    let timezone: String
//    let tzoffset: Int?
    public let days: [Weather]
//    let stations: [String: Station]?
    public let currentConditions: Weather?
}

// MARK: - Weather
public struct Weather: Codable {
    public var weatherType: WeatherType = .none
    public var longitude: Double = 0.0
    public var latitude: Double = 0.0
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
    public let sunriseEpoch, sunsetEpoch, datetimeEpoch: Date
    public let temp, tempmax, tempmin: Double
    public let conditions: String
    public let hours: [Weather]?

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

