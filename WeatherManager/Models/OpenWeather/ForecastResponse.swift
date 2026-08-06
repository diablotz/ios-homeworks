//
//  ForecastResponse.swift
//  WeatherManager
//
//  Created by Timur Zakirov on 04/08/26.
//

import Foundation

struct ForecastResponse: Decodable {
    let list: [ForecastItem]
}

struct ForecastItem: Decodable {
    let weather: [WeatherInfo]
    let main: MainInfo
    let wind: WindInfo
    let dt: TimeInterval
}
