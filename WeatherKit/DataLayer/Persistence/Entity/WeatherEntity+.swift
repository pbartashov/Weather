//
//  WeatherEntity+.swift
//  WeatherKit
//
//  Created by Павел Барташов on 01.09.2022.
//

import UIKit
import CoreData

//https://www.userdesk.io/blog/repository-pattern-using-core-data-and-swift/
extension WeatherEntity: DomainModel {
    typealias DomainModelType = Weather
    
    func toDomainModel() -> Weather {
        Weather(weatherType: weatherType,
                humidity: humidity,
                cloudcover: cloudcover,
                windspeed: windspeed,
                precipcover: precipcover,
                sunriseEpoch: sunriseEpoch ?? Date(),
                sunsetEpoch: sunsetEpoch ?? Date(),
                datetimeEpoch: datetimeEpoch ?? Date(),
                temp: temp,
                tempmax: tempmax,
                tempmin: tempmin,
                conditions: conditions ?? "",
                icon: icon ?? "",
                hourlyWeathers: nil)
    }

    func copyDomainModel(model: Weather) {
//        guard let latitude = model.latitude,
//              let longitude = model.longitude,
//              let weatherType = model.weatherType
//        else {
//            fatalError("Weather model has missing values")
//        }

//        self.latitude = Int16(latitude)
//        self.longitude = Int16(longitude)
//        self.weatherType = Int16(weatherType.rawValue)
        latitude = Double(model.latitude)
        longitude = Double(model.longitude)
        weatherTypeRaw = Int16(model.weatherType.rawValue)

        humidity = Double(model.humidity)
        cloudcover = Double(model.cloudcover)
        windspeed = Double(model.windspeed)
        precipcover = Double(model.precipcover)
        sunriseEpoch = model.sunriseEpoch
        sunsetEpoch = model.sunsetEpoch
        datetimeEpoch  = model.datetimeEpoch
        temp = model.temp
        tempmax = model.tempmax
        tempmin = model.tempmin
        conditions = model.conditions
        icon = model.icon
    }
}

extension WeatherEntity {
    var weatherType: WeatherType {
        .init(rawValue: Int(weatherTypeRaw)) ?? .none
    }
}

//
//extension UIImage {
//    convenience init?(data: Data?) {
//        guard let data = data else {
//            return nil
//        }
//        self.init(data: data)
//    }
//}
