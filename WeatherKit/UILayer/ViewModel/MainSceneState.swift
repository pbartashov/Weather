//
//  MainSceneState.swift
//  WeatherKit
//
//  Created by Павел Барташов on 15.10.2022.
//

public enum MainSceneState {
    case showWeather
    case showOnboarding
    case showSearchLocation(named: String?)
}

extension MainSceneState: Equatable {

}
