//
//  DailyWeatherViewModel.swift
//  WeatherKit
//
//  Created by Павел Барташов on 10.10.2022.
//
import Combine

public final class DailyWeatherViewModel: ViewModel {

    public enum Action {
        case setSelectedWeather(at: Int)
    }

    // MARK: - Properties

    public let location: WeatherLocation
    @Published public var weathers: [WeatherViewModel] = []
    @Published public var selectedWeather: WeatherViewModel?

    @Published public var selectedNoonWeather: WeatherViewModel?
    @Published public var selectedMidnightWeather: WeatherViewModel?

    @Published public var airQualityIndex: String = "_"
    @Published public var airQualityMark: String = "_"
    @Published public var airQualityDesctription: String = "_"

    private var airQualities: [AirQualityViewModel] = []

    private let requestManager: RequestManagerProtocol
    private let unitsFormatterContainer: UnitsFormatterContainer

    private var performActionSubscriptions: AnyCancellable?


    // MARK: - LifeCicle

    public init(location: WeatherLocation,
                weathers: AnyPublisher<[WeatherViewModel], Never>,
                unitsFormatterContainer: UnitsFormatterContainer,
                requestManager: RequestManagerProtocol = RequestManager()
    ) {
        self.location = location
        self.unitsFormatterContainer = unitsFormatterContainer
        self.requestManager = requestManager
        super.init()

        func setupBindings() {
            weathers
                .assign(to: &$weathers)

            $selectedWeather
                .sink { [weak self] _ in
                    self?.requestDayNightWeathers()
                }
                .store(in: &subscriptions)
        }
        setupBindings()
    }

    // MARK: - Metods

    public func subscribePerformAction(to publisher: AnyPublisher<Action, Never>) {
        performActionSubscriptions = publisher
            .sink { [weak self] action in
                switch action {
                    case let .setSelectedWeather(at: index):
                        guard let self = self else {
                            return
                        }
                        self.setSelectedWeather(at: index)
                        self.setAirQuality()
                }
            }
    }

    private func setSelectedWeather(at index: Int) {
        guard index < weathers.count else {
            selectedWeather = nil
            return
        }

        self.selectedWeather = self.weathers[index]
    }

    private func setAirQuality() {
        Task {
            do {
                if airQualities.isEmpty {
                    try await requestAirQuality()
                }

                guard
                    let selectedWeather = selectedWeather,
                    let airQuality = airQualities.first(where: {
                        $0.timestamp.isSameDay(as: selectedWeather.timestamp)
                    })
                else {
                    airQualityIndex = "_"
                    airQualityMark = "_"
                    airQualityDesctription = "_"
                    return
                }

                airQualityIndex = airQuality.index ?? "_"
                airQualityMark = airQuality.mark ?? "_"
                airQualityDesctription = airQuality.description ?? "_"
            } catch {
                errorMessagesSubject.send(error)
            }
        }
    }

    private func requestDayNightWeathers() {
        Task {
            guard let selectedWeather = selectedWeather else {
                return
            }

            do {
                let weatherPack: WeatherPack = try await requestManager.perform(
                    WeatherRequest.getHourlyWeatherFor(location: location,
                                                       date: selectedWeather.timestamp)
                )

                guard let dateWeather = weatherPack.days.first,
                      let hourlyWeathers = dateWeather.hourlyWeathers,
                      let formatter = unitsFormatterContainer.makeUnitsFormatter() else {
                    return
                }

                let hourlyWeatherViewModels = hourlyWeathers.map { WeatherViewModel(weather: $0, formatter: formatter) }

                selectedNoonWeather = hourlyWeatherViewModels.first { $0.isNoon }
                selectedMidnightWeather = hourlyWeatherViewModels.first { $0.isMidnight }
            } catch {
                errorMessagesSubject.send(error)
            }
        }
    }

    private func requestAirQuality() async throws {
        let airQualityPack: AirQualityPack = try await requestManager.perform(
            AirQualityRequest.getAirQualityForecastFor(location: location)
        )

        guard let list = airQualityPack.list else {
            return
        }

        airQualities = list.map { AirQualityViewModel(airQuality: $0) }
    }
}

fileprivate extension Date {
    func isSameDay(as date: Date) -> Bool {
        Calendar.current.isDate(self, inSameDayAs: date)
    }
}
