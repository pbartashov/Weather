//
//  MainSceneState.swift
//  WeatherKit
//
//  Created by Павел Барташов on 15.10.2022.
//

public enum MainSceneState {
    case showWeather
    case showWeatherAt(index: Int)
    case showOnboarding
    case showLocationDenied
    case showLocationRestricted
    case showSearchLocation//(named: String?)
    case showWaitingLocation
}

extension MainSceneState: Equatable { }
