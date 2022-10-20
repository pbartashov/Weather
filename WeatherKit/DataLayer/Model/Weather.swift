//
//  CurrentWeather.swift
//  WeatherKit
//
//  Created by Павел Барташов on 24.09.2022.
//

import Foundation

// MARK: - WeatherPack
public struct WeatherPack {
    public let latitude, longitude: Double
    public let timezone: String
    public let days: [Weather]
    public let currentWeather: Weather?

    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
        case timezone
        case days
        case currentWeather = "currentConditions"
    }

    static var boxUserInfoKey: CodingUserInfoKey? {
        return CodingUserInfoKey(rawValue: "box")
    }
}

extension WeatherPack: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        latitude = try container.decodeIfPresent(Double.self, forKey: .latitude) ?? 0.0
        longitude = try container.decodeIfPresent(Double.self, forKey: .longitude) ?? 0.0

        timezone = try container.decodeIfPresent(String.self, forKey: .timezone) ?? ""

        guard let key = WeatherPack.boxUserInfoKey,
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

    public let humidity: Double
    public let cloudcover: Double
    public let windspeed, winddir: Double
    public let precipprob: Double
    public let uvIndex :Double
    public let temp, tempmax, tempmin, feelslike: Double
    public let sunriseEpoch, sunsetEpoch, datetimeEpoch: Date
    public let moonphase: Double
    public let moonriseEpoch, moonsetEpoch: Date?
    public let conditions: String
    public let icon: String
    public let hourlyWeathers: [Weather]?

    enum CodingKeys: String, CodingKey {
        case humidity
        case cloudcover, uvIndex = "uvindex"
        case windspeed, winddir, precipprob
        case sunriseEpoch, sunsetEpoch, datetimeEpoch
        //        case sunrise, sunset, datetime
        case moonphase, moonriseEpoch, moonsetEpoch
        case temp, tempmax, tempmin, feelslike
        case conditions, icon
        case hours
    }
}

extension Weather: Hashable { }

extension Weather: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        humidity = try container.decodeIfPresent(Double.self, forKey: .humidity) ?? 0.0
        cloudcover = try container.decodeIfPresent(Double.self, forKey: .cloudcover) ?? 0.0
        windspeed = try container.decodeIfPresent(Double.self, forKey: .windspeed) ?? 0.0
        winddir = try container.decodeIfPresent(Double.self, forKey: .winddir) ?? 0.0
        temp = try container.decodeIfPresent(Double.self, forKey: .temp) ?? 0.0
        tempmax = try container.decodeIfPresent(Double.self, forKey: .tempmax) ?? 0.0
        tempmin = try container.decodeIfPresent(Double.self, forKey: .tempmin) ?? 0.0
        feelslike = try container.decodeIfPresent(Double.self, forKey: .feelslike) ?? 0.0
        precipprob = try container.decodeIfPresent(Double.self, forKey: .precipprob) ?? 0.0
        uvIndex = try container.decodeIfPresent(Double.self, forKey: .uvIndex) ?? 0.0
        moonphase = try container.decodeIfPresent(Double.self, forKey: .moonphase) ?? 0.0

        conditions = try container.decodeIfPresent(String.self, forKey: .conditions) ?? ""
        icon = try container.decodeIfPresent(String.self, forKey: .icon) ?? ""

        sunriseEpoch = try container.decodeIfPresent(Date.self, forKey: .sunriseEpoch) ?? Date(timeIntervalSince1970: 0)
        sunsetEpoch = try container.decodeIfPresent(Date.self, forKey: .sunsetEpoch) ?? Date(timeIntervalSince1970: 0)
        datetimeEpoch = try container.decodeIfPresent(Date.self, forKey: .datetimeEpoch) ?? Date(timeIntervalSince1970: 0)

        moonriseEpoch = try container.decodeIfPresent(Date.self, forKey: .moonriseEpoch)
        moonsetEpoch = try container.decodeIfPresent(Date.self, forKey: .moonsetEpoch)

        guard let key = WeatherPack.boxUserInfoKey,
              let box = decoder.userInfo[key] as? ParserBox
        else {
            throw NetworkError.decoderNotConfigured
        }

        weatherType = box.weatherType
        latitude = box.latitude
        longitude = box.longitude

        if container.contains(.hours) {
            box.weatherType = .hourly
            hourlyWeathers = try container.decode([Weather].self, forKey: .hours)
            box.weatherType = weatherType
        } else {
            hourlyWeathers = nil
        }
    }
}
