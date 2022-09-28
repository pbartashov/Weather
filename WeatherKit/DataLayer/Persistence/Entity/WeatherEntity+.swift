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
        Weather(weatherType: WeatherType.init(rawValue: Int(weatherType)) ?? .none,
                humidity: humidity,
                cloudcover: cloudcover,
                windspeed: windspeed,
                sunriseEpoch: sunriseEpoch ?? Date(),
                sunsetEpoch: sunsetEpoch ?? Date(),
                datetimeEpoch: datetimeEpoch ?? Date(),
                temp: temp,
                tempmax: tempmax,
                tempmin: tempmin,
                conditions: conditions ?? "",
                hours: nil)
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
        latitude = Int16(model.latitude)
        longitude = Int16(model.longitude)
        weatherType = Int16(model.weatherType.rawValue)

        humidity = Double(model.humidity)
        cloudcover = Double(model.cloudcover)
        windspeed = Double(model.windspeed)
        sunriseEpoch = model.sunriseEpoch
        sunsetEpoch = model.sunsetEpoch
        datetimeEpoch  = model.datetimeEpoch
        temp = model.temp
        tempmax = model.tempmax
        tempmin = model.tempmin
        conditions = model.conditions
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
