//
//  WeatherEntity+.swift
//  WeatherKit
//
//  Created by Павел Барташов on 01.09.2022.
//

//import UIKit
//import CoreData

//https://www.userdesk.io/blog/repository-pattern-using-core-data-and-swift/
extension WeatherEntity: DomainModel {
    typealias DomainModelType = Weather
    
    func toDomainModel() -> Weather {
        Weather(weatherType: weatherType,
                humidity: humidity,
                cloudcover: cloudcover,
                windspeed: windspeed,
                winddir: winddir,
                precipprob: precipprob,
                uvIndex: uvIndex,
                temp: temp,
                tempmax: tempmax,
                tempmin: tempmin,
                feelslike: feelslike,
                sunriseEpoch: sunriseEpoch ?? Date(),
                sunsetEpoch: sunsetEpoch ?? Date(),
                datetimeEpoch: datetimeEpoch ?? Date(),
                moonphase: moonphase,
                moonriseEpoch: moonriseEpoch,
                moonsetEpoch: moonsetEpoch,
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
        latitude = model.latitude
        longitude = model.longitude
        weatherTypeRaw = Int16(model.weatherType.rawValue)

        humidity = model.humidity
        cloudcover = model.cloudcover
        windspeed = model.windspeed
        winddir = model.winddir
        precipprob = model.precipprob
        sunriseEpoch = model.sunriseEpoch
        sunsetEpoch = model.sunsetEpoch
        datetimeEpoch  = model.datetimeEpoch
        temp = model.temp
        tempmax = model.tempmax
        tempmin = model.tempmin
        feelslike = model.feelslike
        conditions = model.conditions
        icon = model.icon
        uvIndex = model.uvIndex
        moonphase = model.moonphase
        moonriseEpoch = model.moonriseEpoch
        moonsetEpoch = model.moonsetEpoch
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
