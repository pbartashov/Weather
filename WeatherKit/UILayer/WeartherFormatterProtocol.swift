//
//  WeartherFormatterProtocol.swift
//  WeatherKit
//
//  Created by Павел Барташов on 01.10.2022.
//

public protocol WeartherFormatterProtocol {
    func format(temperature: Double) -> String
    func format(speed: Double) -> String
    func format(time: Date) -> String
    func format(dateTime: Date) -> String
    func format(cloudcover: Double) -> String
    func format(humidity: Double) -> String

}
