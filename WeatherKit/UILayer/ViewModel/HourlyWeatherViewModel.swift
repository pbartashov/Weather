//
//  HourlyWeatherViewModel.swift
//  WeatherKit
//
//  Created by Павел Барташов on 04.10.2022.
//

import Combine

#warning("rename")
public final class HourlyWeatherViewModel {


    // MARK: - Properties
    public let cityName: String
    @Published public var weathers: [WeatherViewModel] = []

//    private let subscriptions: Set<AnyCancellable> = []

    // MARK: - Views

    // MARK: - LifeCicle

    public init(cityName: String,
                weathers: AnyPublisher<[WeatherViewModel], Never>
    ) {
        self.cityName = cityName
//        self.weathers = weathers
        weathers.assign(to: &$weathers)
    }

    // MARK: - Metods

}
