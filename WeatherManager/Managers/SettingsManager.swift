//
//  SettingsManager.swift
//  WeatherManager
//
//  Created by Timur Zakirov on 07/08/26.
//

import Foundation

enum TemperatureUnit: Int {
    case celsius
    case fahrenheit
}

enum WindSpeedUnit: Int {
    case kilometers
    case miles
}

enum TimeFormat: Int {
    case twelve
    case twentyFour
}


final class SettingsManager {

    static let shared = SettingsManager()

    private init() {}

    private let defaults = UserDefaults.standard

    enum Keys {

        static let temperature = "temperature"

        static let wind = "wind"

        static let time = "time"
    }

    var temperature: TemperatureUnit {

        get {
            TemperatureUnit(
                rawValue: defaults.integer(forKey: Keys.temperature)
            ) ?? .celsius
        }

        set {
            defaults.set(
                newValue.rawValue,
                forKey: Keys.temperature
            )
        }
    }

    var wind: WindSpeedUnit {

        get {
            WindSpeedUnit(
                rawValue: defaults.integer(forKey: Keys.wind)
            ) ?? .kilometers
        }

        set {
            defaults.set(
                newValue.rawValue,
                forKey: Keys.wind
            )
        }
    }

    var timeFormat: TimeFormat {

        get {
            TimeFormat(
                rawValue: defaults.integer(forKey: Keys.time)
            ) ?? .twentyFour
        }

        set {
            defaults.set(
                newValue.rawValue,
                forKey: Keys.time
            )
        }
    }
}
