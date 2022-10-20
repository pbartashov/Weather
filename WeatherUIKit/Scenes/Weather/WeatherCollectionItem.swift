//
//  Item.swift
//  WeatherUIKit
//
//  Created by Павел Барташов on 24.09.2022.
//

import WeatherKit

enum WeatherCollectionItem: Hashable {
    case empty(UUID)
    case currentWeatherItem(WeatherViewModel)
    case hourlyWeatherItem(WeatherViewModel)
    case dailyWeatherItem(WeatherViewModel)
}
