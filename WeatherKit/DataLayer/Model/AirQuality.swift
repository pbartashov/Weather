//
//  AirQuality.swift
//  WeatherKit
//
//  Created by Павел Барташов on 13.10.2022.
//

import Foundation

// MARK: - AirQualityPack
public struct AirQualityPack: Codable {
    public let list: [AirQuality]?
}

// MARK: - AirQuality
public struct AirQuality: Codable {
    public let main: AirQualityMain?
    public let datetimeEpoch: Date

    enum CodingKeys: String, CodingKey {
        case main
        case datetimeEpoch = "dt"
    }
}

// MARK: - Main
public struct AirQualityMain: Codable {
    public let airQualityIndex: Int

    enum CodingKeys: String, CodingKey {
        case airQualityIndex = "aqi"
    }
}
