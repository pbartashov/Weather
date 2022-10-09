//
//  MainViewModel.swift
//  WeatherKit
//
//  Created by Павел Барташов on 24.09.2022.
//

import Combine

public final class MainViewModel {

    // MARK: - Properties

    public var locations = [WeatherLocation(index: 0, cityName: "London", latitude: 30, longitude: 60),
                             WeatherLocation(index: 1, cityName: "Vladivostok", latitude: 50, longitude: 90),
                             WeatherLocation(index: 2, cityName: "San Diego", latitude: 100, longitude: 35)
    ]

    public var errorMessages: AnyPublisher<Error, Never> {
        errorMessagesSubject.eraseToAnyPublisher()
    }
    private let errorMessagesSubject = PassthroughSubject<Error, Never>()

    private var subscriptions = Set<AnyCancellable>()

    // MARK: - LifeCicle

    public init() {

    }
    // MARK: - Metods

    //     public let errorPresentation = PassthroughSubject<ErrorPresentation?, Never>()



}
