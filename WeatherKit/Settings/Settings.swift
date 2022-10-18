//
//  Settings.swift
//  Weather
//
//  Created by Павел Барташов on 17.09.2022.
//

import Foundation
import Combine

public final class Settings {

    public static let shared = Settings()

    private let settingsStorage = SettingsStorage()

    public enum Temperature: Int {
        case celcius = 0
        case farenheit
    }

    public enum Speed: Int {
        case miles = 0
        case kilometers
    }

    public enum TimeFormat: Int {
        case format12 = 0
        case format24
    }

    public enum Notifications: Int {
        case disabled = 0
        case enabled
    }

    // MARK: - Properties

    private var subscriptions: [AnyCancellable] = []

    @Published public var temperature: Temperature
//    {
//        didSet {
//            settingsStorage.save(temperature)
//        }
//    }

    @Published public var speed: Speed
//{
//        didSet {
//            settingsStorage.save(speed)
//        }
//    }

    @Published public var timeFormat: TimeFormat
//{
//        didSet {
//            settingsStorage.save(timeFormat)
//        }
//    }

    @Published public var notificationsState: Notifications
//{
//        didSet {
//            settingsStorage.save(notificationsEnabled)
//        }
//    }
//
//    public var temperatureSymbol: String {
//        switch temperature {
//            case .celcius:
//                return "°"
//
//            case .farenheit:
//                return "F"
//        }
//    }
//
//
//    public var speedSymbol: String {
//        switch speed {
//            case .miles:
//                return "mph"
//
//            case .kilometers:
//                return "м\\с"
//        }
//    }





    // MARK: - Views

    // MARK: - LifeCicle



    private init() {
        temperature = settingsStorage.restoreTemperature()
        speed = settingsStorage.restoreSpeed()
        timeFormat = settingsStorage.restoreTimeFormat()
        notificationsState = settingsStorage.restoreNotificationsEnabled()

        defer {
            subscriptions.append(
                settingsStorage.temperatureUnitValueChanged
                    .sink { [weak self] value in
                        self?.temperature = Temperature(value)
                    })

            subscriptions.append(
                settingsStorage.speedUnitValueChanged
                    .sink { [weak self] value in
                        self?.speed = Speed(value)
                    })

            subscriptions.append(
                settingsStorage.timeFormatValueChanged
                    .sink { [weak self] value in
                        self?.timeFormat = TimeFormat(value)
                    })

            subscriptions.append(
                settingsStorage.notificationsEnabledValueChanged
                    .sink { [weak self] value in
                        self?.notificationsState = Notifications(value)
                    })
        }
    }


        // MARK: - Metods

    public func save() {
        settingsStorage.save(temperature)
        settingsStorage.save(speed)
        settingsStorage.save(timeFormat)
        settingsStorage.save(notificationsState)
    }
    //    private func handleStoredValueChanged() {
    //        let newTemperature = settingsStorage.restoreNotificationsEnabled()
    //        if temperature !=
    //    }


    public func isFirstLaunch() -> Bool {
        settingsStorage.isFirstLaunch()
    }
}


extension Settings.Temperature {
    static let defaultValue = Settings.Temperature.celcius


    init(_ value: Int) {
        self = .init(rawValue: value) ?? Settings.Temperature.defaultValue
    }
}

extension Settings.Speed {
    static let defaultValue = Settings.Speed.kilometers


    init(_ value: Int) {
        self = .init(rawValue: value) ?? Settings.Speed.defaultValue
    }
}

extension Settings.TimeFormat {
    static let defaultValue = Settings.TimeFormat.format24


    init(_ value: Int) {
        self = .init(rawValue: value) ?? Settings.TimeFormat.defaultValue
    }
}

extension Settings.Notifications {
    static let defaultValue = Settings.Notifications.disabled


    init(_ value: Int) {
        self = .init(rawValue: value) ?? Settings.Notifications.defaultValue
    }
}
