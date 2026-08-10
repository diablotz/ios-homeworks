//
//  DailyTemperature.swift
//  WeatherManager
//
//  Created by Timur Zakirov on 04/08/26.
//

import Foundation

struct DailyTemperature: Codable {
    let day: Double
    let night: Double
    let min: Double
    let max: Double
}
