//
//  ForecastDay.swift
//  WeatherManager
//
//  Created by Timur Zakirov on 07/08/26.
//

import Foundation

struct ForecastDay {
    
    let date: Date
    
    let temperature: Double
    
    //let minTemp: Double
    
    //let maxTemp: Double
    
    let description: String
    
    let icon: String
    
    let humidity: Int
    
    let uvIndex: Double
    
    let windSpeed: Double
    
    let rainProbability: Double // Добавлено: вероятность дождя (0.0 - 1.0)
    
    let cloudiness: Double
    
    let sunrise: TimeInterval
    
    let sunset: TimeInterval
    
    let moonrise: TimeInterval
    
    let moonset: TimeInterval
    
    let moonPhase: Double
    
    let timezoneOffset: Int // Сдвиг времени города в секундах
    
    let air_pollution: Int
    
}
