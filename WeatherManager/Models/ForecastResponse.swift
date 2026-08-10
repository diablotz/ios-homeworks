//
//  ForecastResponse.swift
//  WeatherManager
//
//  Created by Timur Zakirov on 07/08/26.
//

import Foundation

struct ForecastResponse: Decodable, Sendable {
    let list: [WeatherForecastItem]
}

struct WeatherForecastItem: Decodable, Sendable {
    let dt: TimeInterval
    let main: ForecastMain
    let weather: [ForecastWeather]
    let wind: ForecastWind
    let uvi: Double?
    let pop: Double?
    let clouds: CloudsClass?
    
    let sunrise: TimeInterval?
    let sunset: TimeInterval?
    let moonrise: TimeInterval?
    let moonset: TimeInterval?
    let moon_phase: Double?
    let timezoneOffset: Int?
    
    let air_pollution: Int?
}

struct ForecastMain: Decodable, Sendable {
    let temp: Double
    let humidity: Int
    //let minTemp: Double
    //let maxTemp: Double
    
}

struct ForecastWeather: Decodable, Sendable {
    let main: String
    let description: String
    let icon: String
}

struct ForecastWind: Decodable, Sendable {
    let speed: Double
}

struct CloudsClass: Decodable, Sendable {
    let all: Double // Процент облачности (0-100)
}
