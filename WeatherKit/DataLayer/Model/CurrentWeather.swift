//
//  CurrentWeather.swift
//  WeatherKit
//
//  Created by Павел Барташов on 24.09.2022.
//

import Foundation

// MARK: - CurrentWeatherContainer
public struct CurrentWeatherContainer: Hashable, Decodable {
    public let data: [CurrentWeather]?
    public let count: Int?
}

// MARK: - CurrentWeather
public struct CurrentWeather {
//
//    private let dateFormatter: DateFormatter = {
//        let dateFormatter = DateFormatter()
//        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
//
//        return dateFormatter
//    }()

    public let rh: Double
    public let lon, lat: Double
    public let timezone: String
    public let clouds: Double
    public let windSpd: Double
    public let sunrise, sunset, obTime: Date
    public let temp: Double
    public let weather: Weather

    enum CodingKeys: String, CodingKey {
        case rh, lon, lat, timezone, clouds
        case temp, sunrise, sunset, weather
        case obTime = "ob_time"
        case windSpd = "wind_spd"
    }

//    public let windCdir: String?
//    public let rh: Double?
//    public let pod: String?
//    public let lon, lat: Double?
//    public let timezone, obTime, countryCode: String?
//    public let clouds, ts, solarRAD: Double?
//    public let stateCode, cityName: String?
//    public let windSpd, slp: Double?
//    public let windCdirFull: String?
//    public let appTemp: Double?
//    public let dni, vis: Double?
//    public let sources: [String]?
//    public let hAngle: Double?
//    public let dewpt: Double?
//    public let snow, aqi, dhi, windDir: Double?
//    public let elevAngle: Double?
//    public let ghi, precip: Double?
//    public let sunrise, sunset: String?
//    public let pres: Double?
//    public let uv: Double?
//    public let datetime: String?
//    public let temp: Double?
//    public let weather: Weather?
//    public let station: String?
//
//    enum CodingKeys: String, CodingKey {
//        case windCdir = "wind_cdir"
//        case rh, pod, lon, pres, timezone
//        case obTime = "ob_time"
//        case countryCode = "country_code"
//        case clouds, ts
//        case solarRAD = "solar_rad"
//        case stateCode = "state_code"
//        case cityName = "city_name"
//        case windSpd = "wind_spd"
//        case slp
//        case windCdirFull = "wind_cdir_full"
//        case sunrise, sunset
//        case appTemp = "app_temp"
//        case dni, vis, sources
//        case hAngle = "h_angle"
//        case dewpt, snow, aqi, dhi
//        case windDir = "wind_dir"
//        case elevAngle = "elev_angle"
//        case ghi, precip, lat, uv, datetime, temp, weather, station
//    }
}

extension CurrentWeather: Hashable {}

extension CurrentWeather: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        rh = try container.decode(Double.self, forKey: .rh)
        lon = try container.decode(Double.self, forKey: .lon)
        lat = try container.decode(Double.self, forKey: .lat)
        clouds = try container.decode(Double.self, forKey: .clouds)
        windSpd = try container.decode(Double.self, forKey: .windSpd)
        temp = try container.decode(Double.self, forKey: .temp)

        timezone = try container.decode(String.self, forKey: .timezone)

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        if let timeZone = TimeZone(identifier: timezone) {
            dateFormatter.timeZone = timeZone
        }

        dateFormatter.dateFormat = "YYYY-MM-DD HH:mm"
        let obTimeString = try container.decode(String.self, forKey: .obTime)
        obTime = dateFormatter.date(from: obTimeString) ?? Date()

        dateFormatter.dateFormat = "HH:mm"

        let sunriseString = try container.decode(String.self, forKey: .sunrise)
        sunrise = dateFormatter.date(from: sunriseString) ?? Date()

        let sunsetString = try container.decode(String.self, forKey: .sunset)
        sunset = dateFormatter.date(from: sunsetString) ?? Date()

        weather = try Weather(from: decoder)
    }
}



// MARK: - Weather
public struct Weather: Hashable, Codable {
    public let icon: String?
    public let code: Int?
    public let weatherDescription: String?

    enum CodingKeys: String, CodingKey {
        case icon, code
        case weatherDescription = "description"
    }
}

