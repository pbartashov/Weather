//
//  WeatherRepository.swift
//  WeatherKit
//
//  Created by Павел Барташов on 24.09.2022.
//

public protocol WeatherRepositoryProtocol {
    func fetchCurrentWeather(location: WeatherLocation) async throws -> CurrentWeather
}

public final class WeatherRepository: WeatherRepositoryProtocol {

    // MARK: - Properties
    private let requestManager: RequestManagerProtocol


    // MARK: - Views

    // MARK: - LifeCicle

    public init(requestManager: RequestManagerProtocol = RequestManager()) {
        self.requestManager = requestManager
    }

    // MARK: - Metods

//    public func fetchWeather(location: WeatherLocation) async {
//        await fetchCurrentWeather(location: location)
//    }

    public func fetchCurrentWeather(location: WeatherLocation
//        latitude: Double,
//                                 longitude: Double
    ) async throws -> CurrentWeather {
            let currentWeatherContainer: CurrentWeatherContainer = try await requestManager.perform(
                CurrentWeatherRequest.getWeatherFor(latitude: location.latitude,
                                                    longitude: location.longitude)

            )

        guard let currentWeather = currentWeatherContainer.data?.first else { throw NetworkError.invalidServerResponse }

        return currentWeather

            //            for var animal in animalsContainer.animals {
            //                animal.toManagedObject()
            //            }
    }
}
