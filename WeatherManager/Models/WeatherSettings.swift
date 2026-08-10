//
//  WeatherSettings.swift
//  WeatherManager
//
//  Created by Timur Zakirov on 07/08/26.
//

import Foundation

struct WeatherSettings {
    
    
    static var unitsParameter: String {
        let savedIndex = UserDefaults.standard.integer(forKey: "temp_unit_index")
        // 0 — Цельсии (метрическая система), 1 — Фаренгейты (имперская система)
        return savedIndex == 0 ? "metric" : "imperial"
    }
    
    // Получаем язык (для OpenWeatherMap, чтобы описание "ясно/пасмурно" было на русском)
    static var languageParameter: String {
        return "ru"
    }
}

