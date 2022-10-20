//
//  HourlyWeatherViewModel.swift
//  WeatherKit
//
//  Created by Павел Барташов on 04.10.2022.
//

import Combine

public final class HourlyWeatherViewModel {

    // MARK: - Properties

    public let cityName: String
    @Published public var weathers: [WeatherViewModel] = []

    // MARK: - LifeCicle

    public init(cityName: String,
                weathers: AnyPublisher<[WeatherViewModel], Never>
    ) {
        self.cityName = cityName
        weathers.assign(to: &$weathers)
    }
}
