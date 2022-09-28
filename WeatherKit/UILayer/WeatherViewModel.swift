//
//  WeatherViewModel.swift
//  WeatherKit
//
//  Created by Павел Барташов on 24.09.2022.
//

import Combine
import Foundation

public final class WeatherViewModel {

    // MARK: - Properties

    public let timeFormatter: DateFormatter = {
        let timeFormatter = DateFormatter()
        timeFormatter.locale = Locale(identifier: "en_US_POSIX")

        return timeFormatter
    }()

    public let timestampFormatter: DateFormatter = {
        let timestampFormatter = DateFormatter()
        timestampFormatter.locale = Locale(identifier: "ru_RU")

        return timestampFormatter
    }()


    public let location: WeatherLocation
    @Published public var currentWeather: Weather?


    public var errorMessages: AnyPublisher<Error, Never> {
        errorMessagesSubject.eraseToAnyPublisher()
    }
    private let errorMessagesSubject = PassthroughSubject<Error, Never>()

    private var subscriptions = Set<AnyCancellable>()

    private let weatherRepository: WeatherRepositoryProtocol




    // MARK: - LifeCicle

    public init(
        location: WeatherLocation,
        weatherRepository: WeatherRepositoryProtocol

    ) {
        self.location = location
        self.weatherRepository = weatherRepository

        bindToSettings()

//        configureDateFormatters(format: Settings.shared.timeFormat)

        
        //        Task {
        //            await self.fetchCurrentWeather(latitude: 63,
        //                                      longitude: 43)
        //        }





        
    }
    
    // MARK: - Metods

    private func bindToSettings() {
        let settings = Settings.shared

        func bindToSettingsTemperature() {
            settings.$timeFormat
                .receive(on: DispatchQueue.main)
                .sink { [weak self] format in
                    self?.configureDateFormatters(format: format)
                }
                .store(in: &subscriptions)
        }


        bindToSettingsTemperature()
    }
    public func fetchWeather() async {
        await fetchCurrentWeather()
    }

    private func fetchCurrentWeather(//latitude: Double,
        //                         longitude: Double
    ) async {
        do {
//            currentWeather = try await weatherRepository.fetchCurrentDayWeather(location: location)
            configureDateFormatters(format: Settings.shared.timeFormat)
            print(currentWeather)
            print(currentWeather?.sunsetEpoch)
            //            for var animal in animalsContainer.animals {
            //                animal.toManagedObject()
            //            }
        } catch {
            errorMessagesSubject.send(error)
        }
    }
    //     public let errorPresentation = PassthroughSubject<ErrorPresentation?, Never>()

    private func configureDateFormatters(format: Settings.TimeFormat) {
        if case .format12 = format {
            timeFormatter.dateFormat = "HH:mm"
            timestampFormatter.dateFormat = "HH:mm, DD LL"
        } else {
            timeFormatter.dateFormat = "hh:mm a"
            timestampFormatter.dateFormat = "hh:mm a, E dd MMMM"
//            timestampFormatter.dateStyle = .medium
//            timestampFormatter.timeStyle = .short
        }

        guard let currentWeather = currentWeather
//              let timezone = currentWeather.timezone
        else { return }

//        timeFormatter.timeZone = TimeZone(identifier: currentWeather.timezone)
//        timestampFormatter.timeZone = TimeZone(identifier: currentWeather.timezone)
    }


}

extension Weather {
    public var tempFormatted: String? {
//        guard let temp = temp else { return nil }

        return "\(temp)\(Settings.shared.temperatureSymbol)"
    }

    public var cloudsFormatted: String? {
//        guard let clouds = clouds else { return nil }

        return "\(cloudcover)"
    }

    public var humidityFormatted: String? {
//        guard let rh = rh else { return nil }

        return "\(String(format: "%.0f", humidity))%"
    }

    public var windSpeedFormatted: String? {
//        guard let windSpd = windSpd else { return nil }

        return "\(String(format: "%.0f", windspeed)) \(Settings.shared.velocitySymbol)"
    }

//    public var sunriseFormatted: String? {
//        guard let sunrise = sunrise else { return nil }
//        if case .format12 = Settings.shared.timeFormat {
//            return sunrise.formatted(date: .omitted, time: .shortened)
//        }
//
//        return sunrise.formatted(date: .omitted, time: .shortened)
//
//    }

//    public var sunsetFormatted: String? {
//        guard let windSpd = windSpd else { return nil }
//
//        return "\(String(format: "%.0f", windSpd))\(Settings.shared.velocitySymbol)"
//    }

//    public var timestamp: String? {
//        guard let windSpd = windSpd else { return nil }
//
//        return "\(String(format: "%.0f", windSpd))\(Settings.shared.velocitySymbol)"
//    }

}
