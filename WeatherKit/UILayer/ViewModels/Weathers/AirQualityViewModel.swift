//
//  AirQualityViewModel.swift
//  WeatherKit
//
//  Created by Павел Барташов on 13.10.2022.
//

import Foundation


public struct AirQualityViewModel {

    // MARK: - Properties

    private let airQuality: AirQuality

    public var indexValue: Int? {
        airQuality.main?.airQualityIndex
    }

    public var timestamp: Date {
        airQuality.datetimeEpoch
    }

    public var index: String? {
        guard let index = indexValue else { return nil }
        return "\(index)"
    }

    public var mark: String? {
        switch indexValue {
            case 1:
                return "хорошо"
            case 2:
                return "умеренно"
            case 3:
                return "удовлетворительно"
            case 4:
                return "плохо"
            case 5:
                return "опаснo"
            default:
                return nil
        }
    }

    public var description: String? {
        switch indexValue {
            case 1:
                return "Качество воздуха хорошее, опасности нет"
            case 2:
                return "Умеренное загрязнение. Чувствительные люди могут испытывать респираторные симптомы. Рекомендуется избегать активности на открытом воздухе"
            case 3:
                return "Уровень загрязнения повышенный. Нездоровый для чувствительных групп населения. Представители групп риска могут испытать проблемы со здоровьем"
            case 4:
                return "Очень вредный. Значительное влияние на все группы населения. Рекомендуется ограничить или избегать пребывание на открытом воздухе"
            case 5:
                return "Очень опасный. Все люди подвергаются высокому риску серьезных последствий для здоровья. Необходимо воздержаться от активностей на открытом воздухе и оставаться в помещении"
            default:
                return nil
        }
    }

    // MARK: - LifeCicle

    public init(airQuality: AirQuality) {
        self.airQuality = airQuality
    }
}
