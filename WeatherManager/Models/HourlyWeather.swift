//
//  HourlyWeather.swift
//  WeatherManager
//
//  Created by Timur Zakirov on 04/08/26.
//

import Foundation

struct HourlyWeather: Decodable {
    let dt: TimeInterval
    let temp: Double
    let weather: [Weather]
}
