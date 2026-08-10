//
//  CurrentWeather.swift
//  WeatherManager
//
//  Created by Timur Zakirov on 04/08/26.
//

import Foundation

struct CurrentWeather: Decodable {
    let dt: TimeInterval
    let temp: Double
    let humidity: Int
    let windSpeed: Double
    let weather: [Weather]
    let sunrise: TimeInterval
    let sunset: TimeInterval
    
    enum CodingKeys: String, CodingKey {
        case dt
        case temp
        case humidity
        case windSpeed = "wind_speed"
        case weather
        case sunrise
        case sunset
    }
}
