//
//  Weather.swift
//  WeatherManager
//
//  Created by Timur Zakirov on 04/08/26.
//

import Foundation

struct Weather: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}
