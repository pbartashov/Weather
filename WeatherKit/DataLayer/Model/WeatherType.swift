//
//  WeatherType.swift
//  WeatherKit
//
//  Created by Павел Барташов on 28.09.2022.
//

public enum WeatherType: Int {
    case none = 0
    case current// = 0
    case hourly
    case daily
}

extension WeatherType: Codable { }
