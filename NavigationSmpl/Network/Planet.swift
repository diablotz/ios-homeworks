//
//  Planet.swift
//  NavigationSmpl
//
//  Created by Timur Zakirov on 02/07/26.
//

import Foundation

struct Planet: Decodable {
    let name: String
    let orbitalPeriod: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case orbitalPeriod = "orbital_period"
    }
}
