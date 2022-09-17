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

    var temperatureUnitValueChanged: AnyPublisher<String, Never> {
        userDefaults
            .publisher(for: \.temperatureUnit, options: [.new])
            .removeDuplicates()
            .compactMap{ $0 }
            .eraseToAnyPublisher()
    }

    var velocityUnitValueChanged: AnyPublisher<String, Never> {
        userDefaults
            .publisher(for: \.velocityUnit, options: [.new])
            .removeDuplicates()
            .compactMap{ $0 }
            .eraseToAnyPublisher()
    }

    var timeFormatValueChanged: AnyPublisher<String, Never> {
        userDefaults
            .publisher(for: \.timeFormat, options: [.new])
            .removeDuplicates()
            .compactMap{ $0 }
            .eraseToAnyPublisher()
    }

    var notificationsEnabledValueChanged: AnyPublisher<Bool, Never> {
        userDefaults
            .publisher(for: \.notificationsEnabled, options: [.new])
            .removeDuplicates()
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
        guard let saved = userDefaults.temperatureUnit else {
            return .defaultValue
        }

        return Settings.Temperature.init(saved)
    }

    func save(_ velocity: Settings.Velocity) {
        userDefaults.set(velocity.rawValue,
                         forKey: SettingsStorage.Key.velocityUnits)
    }


    func restoreVelocity() -> Settings.Velocity {
        guard let saved = userDefaults.velocityUnit else {
            return .defaultValue
        }

        return Settings.Velocity.init(saved)
    }

    func save(_ timeFormat: Settings.TimeFormat) {
        userDefaults.set(timeFormat.rawValue,
                         forKey: SettingsStorage.Key.timeFormat)
    }


    func restoreTimeFormat() -> Settings.TimeFormat {
        guard let saved = userDefaults.timeFormat else {
            return .defaultValue
        }

        return Settings.TimeFormat.init(saved)
    }


    func save(_ notificationsEnabled: Bool) {
        userDefaults.set(notificationsEnabled,
                         forKey: SettingsStorage.Key.notificationsEnabled)
    }


    func restoreNotificationsEnabled() -> Bool {
        userDefaults.notificationsEnabled
    }

}


extension UserDefaults {
    @objc var temperatureUnit: String? {
        string(forKey: SettingsStorage.Key.temperatureUnits)
    }

    @objc var velocityUnit: String? {
        string(forKey: SettingsStorage.Key.velocityUnits)
    }

    @objc var timeFormat: String? {
        string(forKey: SettingsStorage.Key.timeFormat)
    }

    @objc var notificationsEnabled: Bool {
        bool(forKey: SettingsStorage.Key.notificationsEnabled)
    }


}
