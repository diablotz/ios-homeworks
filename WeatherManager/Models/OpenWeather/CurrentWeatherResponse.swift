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
}

struct MainInfo: Decodable, Sendable {
    let temp: Double
    let humidity: Int
}

struct WeatherInfo: Decodable, Sendable {
    let main: String
    let description: String
    let icon: String
}

struct WindInfo: Decodable, Sendable {
    let speed: Double
}
