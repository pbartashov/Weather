//
//  Settings.swift
//  Weather
//
//  Created by Павел Барташов on 17.09.2022.
//

import Foundation
import Combine

final class Settings {

    static let shared = Settings()

    let settingsStorage = SettingsStorage()

    enum Temperature: String {
        case celcius
        case farenheit
    }

    enum Velocity: String {
        case miles
        case kilometers
    }



    enum TimeFormat: String {
        case format12
        case format24
    }

    //    enum Switch: String {
    //        case on
    //        case off
    //
    //        static let defaultValue = Switch.off
    //    }

    // MARK: - Properties

    private var subscriptions: [AnyCancellable]?

    @Published var temperature: Temperature {
        didSet {
            settingsStorage.save(temperature)
        }
    }

    @Published var velocity: Velocity {
        didSet {
            settingsStorage.save(velocity)
        }
    }

    @Published var timeFormat: TimeFormat {
        didSet {
            settingsStorage.save(timeFormat)
        }
    }

    @Published var notificationsEnabled: Bool {
        didSet {
            settingsStorage.save(notificationsEnabled)
        }
    }

    // MARK: - Views

    // MARK: - LifeCicle



    private init() {
        temperature = settingsStorage.restoreTemperature()
        velocity = settingsStorage.restoreVelocity()
        timeFormat = settingsStorage.restoreTimeFormat()
        notificationsEnabled = settingsStorage.restoreNotificationsEnabled()

        defer {
            subscriptions?.append(
                settingsStorage.temperatureUnitValueChanged
                    .sink { [weak self] value in
                        self?.temperature = Temperature(value)
                    })

            subscriptions?.append(
                settingsStorage.velocityUnitValueChanged
                    .sink { [weak self] value in
                        self?.velocity = Velocity(value)
                    })

            subscriptions?.append(
                settingsStorage.timeFormatValueChanged
                    .sink { [weak self] value in
                        self?.timeFormat = TimeFormat(value)
                    })

            subscriptions?.append(
                settingsStorage.notificationsEnabledValueChanged
                    .sink { [weak self] value in
                        self?.notificationsEnabled = value
                    })
        }
    }


    // MARK: - Metods

//    private func handleStoredValueChanged() {
//        let newTemperature = settingsStorage.restoreNotificationsEnabled()
//        if temperature !=
//    }
}


extension Settings.Temperature {
    static let defaultValue = Settings.Temperature.celcius


    init(_ value: String) {
        self = .init(rawValue: value) ?? Settings.Temperature.defaultValue
    }
}

extension Settings.Velocity {
    static let defaultValue = Settings.Velocity.kilometers


    init(_ value: String) {
        self = .init(rawValue: value) ?? Settings.Velocity.defaultValue
    }
}

extension Settings.TimeFormat {
    static let defaultValue = Settings.TimeFormat.format12


    init(_ value: String) {
        self = .init(rawValue: value) ?? Settings.TimeFormat.defaultValue
    }
}
