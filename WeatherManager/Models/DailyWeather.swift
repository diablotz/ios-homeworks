//
//  DailyWeather.swift
//  WeatherManager
//
//  Created by Timur Zakirov on 04/08/26.
//

import Foundation

struct DailyWeather: Decodable {
    let dt: TimeInterval
    let temp: DailyTemperature
    let weather: [Weather]
    let humidity: Int
    let windSpeed: Double
    
    enum CodingKeys: String, CodingKey {
        case dt
        case temp
        case weather
        case humidity
        case windSpeed = "wind_speed"
    }
}
