//
//  CurrentWeather.swift
//  WeatherKit
//
//  Created by Павел Барташов on 24.09.2022.
//

import Foundation

public struct CurrentWeatherContainer: Hashable, Codable {
    public let data: [CurrentWeather]?
    public let count: Int?
}

// MARK: - Datum
public struct CurrentWeather: Hashable, Codable {
    public let windCdir: String?
    public let rh: Double?
    public let pod: String?
    public let lon, lat: Double?
    public let timezone, obTime, countryCode: String?
    public let clouds, ts, solarRAD: Double?
    public let stateCode, cityName: String?
    public let windSpd, slp: Double?
    public let windCdirFull, sunrise: String?
    public let appTemp: Double?
    public let dni, vis: Double?
    public let sources: [String]?
    public let hAngle: Double?
    public let dewpt: Double?
    public let snow, aqi, dhi, windDir: Double?
    public let elevAngle: Double?
    public let ghi, precip: Double?
    public let sunset: String?
    public let pres: Double?
    public let uv: Double?
    public let datetime: String?
    public let temp: Double?
    public let weather: Weather?
    public let station: String?

    enum CodingKeys: String, CodingKey {
        case windCdir = "wind_cdir"
        case rh, pod, lon, pres, timezone
        case obTime = "ob_time"
        case countryCode = "country_code"
        case clouds, ts
        case solarRAD = "solar_rad"
        case stateCode = "state_code"
        case cityName = "city_name"
        case windSpd = "wind_spd"
        case slp
        case windCdirFull = "wind_cdir_full"
        case sunrise
        case appTemp = "app_temp"
        case dni, vis, sources
        case hAngle = "h_angle"
        case dewpt, snow, aqi, dhi
        case windDir = "wind_dir"
        case elevAngle = "elev_angle"
        case ghi, precip, sunset, lat, uv, datetime, temp, weather, station
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

