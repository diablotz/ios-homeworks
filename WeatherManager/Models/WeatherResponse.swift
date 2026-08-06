//
//  WeatherResponse.swift
//  WeatherManager
//
//  Created by Timur Zakirov on 04/08/26.
//

import Foundation

struct WeatherResponse: Decodable{
    let current: CurrentWeather
    let daily: [DailyWeather]
    let hourly: [HourlyWeather]
}
