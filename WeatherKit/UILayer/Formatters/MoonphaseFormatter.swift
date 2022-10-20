//
//  MoonphaseFormatter.swift
//  WeatherKit
//
//  Created by Павел Барташов on 11.10.2022.
//

public struct MoonphaseFormatter {
    let phases = ["Новолуние",
                  "Молодая луна",
                  "Первая четверть",
                  "Прибывающая луна",
                  "Полнолуние",
                  "Убывающая луна",
                  "Последняя четверть",
                  "Старая луна"]

    func string(from phase: Double) -> String {
        let i = Int(((phase + 0.0625) / 0.125))
        return phases[i % phases.count]
    }
}

extension MoonphaseFormatter: Hashable { }
