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
        static let speedUnits = "com.weather.settings.speedUnits"
        static let timeFormat = "com.weather.settings.timeFormat"
        static let notificationsEnabled = "com.weather.settings.notificationsEnabled"
        static let isFirstLaunch = "com.weather.settings.hasBeenLaunchedBefore"
//        static let keyTemperature = "com.weather.settings.temperature"
//        static let keySpeed = "com.weather.settings.speed"
//        static let keyTimeFormat = "com.weather.settings.timeFormat"
//        static let keyNotificationsEnabled = "com.weather.settings.notificationsEnabled"
//        case temperature = "com.weather.settings.temperature"
//        case speed = "com.weather.settings.speed"
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

    var speedUnitValueChanged: AnyPublisher<Int, Never> {
        userDefaults
            .publisher(for: \.speedUnit, options: [.new])
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

    //https://stackoverflow.com/questions/27208103/detect-first-launch-of-ios-app
    func isFirstLaunch() -> Bool {
        let isFirstLaunch = !userDefaults.bool(forKey: Key.isFirstLaunch)
        if (isFirstLaunch) {
            userDefaults.set(true, forKey: Key.isFirstLaunch)
        }
        return isFirstLaunch
    }



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
//    func save(_ speed: Settings.Speed) {
//        userDefaults.set(speed.rawValue,
//                         forKey: Constants.keySpeed)
//    }
//
//
//    func restoreSpeed() -> Settings.Speed {
//        guard let saved = userDefaults.object(forKey: Constants.keySpeed) as? String else {
//            return .defaultValue
//        }
//
//        return Settings.Speed.init(saved)
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

    func save(_ speed: Settings.Speed) {
        userDefaults.set(speed.rawValue,
                         forKey: SettingsStorage.Key.speedUnits)
    }


    func restoreSpeed() -> Settings.Speed {
        guard let saved = userDefaults.speedUnit as? Int else {
            return .defaultValue
        }

        return Settings.Speed.init(saved)
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
    @objc var temperatureUnit: NSNumber {
        let integer = integer(forKey: SettingsStorage.Key.temperatureUnits)
        return NSNumber(value: integer)
    }

    @objc var speedUnit: NSNumber {
        let integer = integer(forKey: SettingsStorage.Key.speedUnits)
        return NSNumber(value: integer)
    }

    @objc var timeFormat: NSNumber {
        let integer = integer(forKey: SettingsStorage.Key.timeFormat)
        return NSNumber(value: integer)
    }

    @objc var notificationsEnabled: NSNumber {
        let integer = integer(forKey: SettingsStorage.Key.notificationsEnabled)
        return NSNumber(value: integer)
    }
}
