//
//  WindDirectionFormatter.swift
//  WeatherKit
//
//  Created by Павел Барташов on 08.10.2022.
//
//https://stackoverflow.com/questions/13220367/cardinal-wind-direction-from-degrees

public struct WindDirectionFormatter {
    let directions = ["С", "ССВ", "СВ", "ВСВ", "В", "ВЮВ", "ЮВ", "ЮЮВ", "Ю", "ЮЮЗ", "ЮЗ", "ЗЮЗ", "З", "ЗСЗ", "СЗ", "ССЗ"]

    func string(from degrees: Double) -> String {
        let i: Int = Int((degrees + 11.25) / 22.5)
        return directions[i % 16]
    }
}

extension WindDirectionFormatter: Hashable { }
