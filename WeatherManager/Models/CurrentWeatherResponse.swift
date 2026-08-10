//
//  CurrentWeatherResponse.swift
//  WeatherManager
//
//  Created by Timur Zakirov on 04/08/26.
//

import Foundation

nonisolated struct CurrentWeatherResponse: Decodable, Sendable {
    let name: String
    let main: MainInfo
    let weather: [WeatherInfo]
    let wind: WindInfo
    let sys: SysClass
    let timezone: Int
    
}

struct MainInfo: Decodable, Sendable {
    let temp: Double
    let humidity: Int
    let temp_min: Double
    let temp_max: Double
}

struct WeatherInfo: Decodable, Sendable {
    let main: String
    let description: String
    let icon: String
    let id: Int
}

struct WindInfo: Decodable, Sendable {
    let speed: Double
}

struct SysClass: Decodable, Sendable {
    let sunrise: TimeInterval
    let sunset: TimeInterval
}


