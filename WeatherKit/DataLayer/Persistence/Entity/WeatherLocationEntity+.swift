//
//  WeatherLocationEntity+.swift
//  WeatherKit
//
//  Created by Павел Барташов on 14.10.2022.
//

extension WeatherLocationEntity: DomainModel {
    typealias DomainModelType = WeatherLocation

    func toDomainModel() -> WeatherLocation {
        WeatherLocation(index: Int(index),
                        cityName: cityName ?? "",
                        timeZone: timeZone,
                        latitude: latitude,
                        longitude: longitude)
    }

    func copyDomainModel(model: WeatherLocation) {
        latitude = model.latitude
        longitude = model.longitude
        index = Int16(model.index)
        cityName = model.cityName
        timeZone = model.timeZone
     }
}
