//
//  SettingsStorage.swift
//  Weather
//
//  Created by Павел Барташов on 17.09.2022.
//

import Foundation
import Combine

struct SettingsStorage {

    enum Key {
        static let temperatureUnits = "com.weather.settings.temperatureUnits"
        static let velocityUnits = "com.weather.settings.velocityUnits"
        static let timeFormat = "com.weather.settings.timeFormat"
        static let notificationsEnabled = "com.weather.settings.notificationsEnabled"
//        static let keyTemperature = "com.weather.settings.temperature"
//        static let keyVelocity = "com.weather.settings.velocity"
//        static let keyTimeFormat = "com.weather.settings.timeFormat"
//        static let keyNotificationsEnabled = "com.weather.settings.notificationsEnabled"
//        case temperature = "com.weather.settings.temperature"
//        case velocity = "com.weather.settings.velocity"
//        case timeFormat = "com.weather.settings.timeFormat"
//        case notificationsEnabled = "com.weather.settings.notificationsEnabled"
    }

    // MARK: - Properties

    let userDefaults = UserDefaults.standard

    // MARK: - Views

    // MARK: - LifeCicle

    // MARK: - Metods

//    private let publisher =  PassthroughSubject<SettingsStorageKey, Never>()

//    var storedValueChanged: AnyPublisher<SettingsStorageKey, Never> {
//        publisher
//        NotificationCenter.default
//            .publisher(for: UserDefaults.didChangeNotification, object: nil)
//            .map { _ in }
//            .eraseToAnyPublisher()
//    }

    var temperatureUnitValueChanged: AnyPublisher<Int, Never> {
        userDefaults
            .publisher(for: \.temperatureUnit, options: [.new])
            .removeDuplicates()
            .compactMap{ $0 as? Int }
            .eraseToAnyPublisher()
    }

    var velocityUnitValueChanged: AnyPublisher<Int, Never> {
        userDefaults
            .publisher(for: \.velocityUnit, options: [.new])
            .removeDuplicates()
            .compactMap{ $0 as? Int }
            .eraseToAnyPublisher()
    }

    var timeFormatValueChanged: AnyPublisher<Int, Never> {
        userDefaults
            .publisher(for: \.timeFormat, options: [.new])
            .removeDuplicates()
            .compactMap{ $0 as? Int }
            .eraseToAnyPublisher()
    }

    var notificationsEnabledValueChanged: AnyPublisher<Int, Never> {
        userDefaults
            .publisher(for: \.notificationsEnabled, options: [.new])
            .removeDuplicates()
            .compactMap{ $0 as? Int }
            .eraseToAnyPublisher()
    }


    // MARK: - Metods

//    func save(_ temperature: Settings.Temperature) {
//        userDefaults.set(temperature.rawValue,
//                         forKey: SettingsStorageKey.keyTemperature.rawValue)
//    }
//
//    func restoreTemperature() -> Settings.Temperature {
//        guard let saved = userDefaults.object(forKey: Constants.keyTemperature) as? String else {
//            return .defaultValue
//        }
//
//        return Settings.Temperature.init(saved)
//    }
//
//    func save(_ velocity: Settings.Velocity) {
//        userDefaults.set(velocity.rawValue,
//                         forKey: Constants.keyVelocity)
//    }
//
//
//    func restoreVelocity() -> Settings.Velocity {
//        guard let saved = userDefaults.object(forKey: Constants.keyVelocity) as? String else {
//            return .defaultValue
//        }
//
//        return Settings.Velocity.init(saved)
//    }
//
//    func save(_ timeFormat: Settings.TimeFormat) {
//        userDefaults.set(timeFormat.rawValue,
//                         forKey: Constants.keyTimeFormat)
//    }
//
//
//    func restoreTimeFormat() -> Settings.TimeFormat {
//        guard let saved = userDefaults.object(forKey: Constants.keyTimeFormat) as? String else {
//            return .defaultValue
//        }
//
//        return Settings.TimeFormat.init(saved)
//    }
//
//
//    func save(_ notificationsEnabled: Bool) {
//        userDefaults.set(notificationsEnabled,
//                         forKey: Constants.keyNotificationsEnabled)
//    }
//
//
//    func restoreNotificationsEnabled() -> Bool {
//        userDefaults.object(forKey: Constants.keyNotificationsEnabled) as? Bool ?? false
//    }

    func save(_ temperature: Settings.Temperature) {
        userDefaults.set(temperature.rawValue,
                         forKey: SettingsStorage.Key.temperatureUnits)
    }

    func restoreTemperature() -> Settings.Temperature {
        guard let saved = userDefaults.temperatureUnit as? Int else {
            return .defaultValue
        }

        return Settings.Temperature.init(saved)
    }

    func save(_ velocity: Settings.Velocity) {
        userDefaults.set(velocity.rawValue,
                         forKey: SettingsStorage.Key.velocityUnits)
    }


    func restoreVelocity() -> Settings.Velocity {
        guard let saved = userDefaults.velocityUnit as? Int else {
            return .defaultValue
        }

        return Settings.Velocity.init(saved)
    }

    func save(_ timeFormat: Settings.TimeFormat) {
        userDefaults.set(timeFormat.rawValue,
                         forKey: SettingsStorage.Key.timeFormat)
    }


    func restoreTimeFormat() -> Settings.TimeFormat {
        guard let saved = userDefaults.timeFormat as? Int else {
            return .defaultValue
        }

        return Settings.TimeFormat.init(saved)
    }


    func save(_ notificationsEnabled: Settings.Notifications) {
        userDefaults.set(notificationsEnabled.rawValue,
                         forKey: SettingsStorage.Key.notificationsEnabled)
    }


    func restoreNotificationsEnabled() -> Settings.Notifications {
        guard let saved = userDefaults.notificationsEnabled as? Int else {
            return .defaultValue
        }

        return Settings.Notifications.init(saved)
    }

}


extension UserDefaults {
    @objc var temperatureUnit: NSNumber? {
        let integer = integer(forKey: SettingsStorage.Key.temperatureUnits)
        return NSNumber(value: integer)
    }

    @objc var velocityUnit: NSNumber? {
        let integer = integer(forKey: SettingsStorage.Key.velocityUnits)
        return NSNumber(value: integer)
    }

    @objc var timeFormat: NSNumber? {
        let integer = integer(forKey: SettingsStorage.Key.timeFormat)
        return NSNumber(value: integer)
    }

    @objc var notificationsEnabled: NSNumber? {
        let integer = integer(forKey: SettingsStorage.Key.notificationsEnabled)
        return NSNumber(value: integer)
    }


}
