//
//  WeatherViewModel.swift
//  WeatherKit
//
//  Created by Павел Барташов on 24.09.2022.
//

import Combine

public final class WeatherViewModel {

    // MARK: - Properties



    public let location: WeatherLocation
    @Published public var currentWeather: CurrentWeather?


//    public var errorMessages: AnyPublisher<Error, Never> {
//        errorMessagesSubject.eraseToAnyPublisher()
//    }
//    private let errorMessagesSubject = PassthroughSubject<Error, Never>()
//
//    private var subscriptions = Set<AnyCancellable>()

    private let weatherRepository: WeatherRepositoryProtocol




    // MARK: - LifeCicle

    public init(
        location: WeatherLocation,
        weatherRepository: WeatherRepositoryProtocol

    ) {
        self.location = location
        self.weatherRepository = weatherRepository



        
//        Task {
//            await self.fetchCurrentWeather(latitude: 63,
//                                      longitude: 43)
//        }
    }
    
    // MARK: - Metods

    public func fetchWeather() async {
        await fetchCurrentWeather()
    }

    func fetchCurrentWeather(//latitude: Double,
    //                         longitude: Double
    ) async {
        do {
            currentWeather = try await weatherRepository.fetchCurrentWeather(location: location)

            print(currentWeather)
//            for var animal in animalsContainer.animals {
//                animal.toManagedObject()
//            }
        } catch {
            print("Error fetching animals...\(error)")
        }
    }
    //     public let errorPresentation = PassthroughSubject<ErrorPresentation?, Never>()




}
