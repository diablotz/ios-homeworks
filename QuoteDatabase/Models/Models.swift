//
//  Models.swift
//  QuoteDatabase
//
//  Created by Timur Zakirov on 22/07/26.
//

import Foundation
import RealmSwift


struct ReceivedQuote: Codable {
    let value: String
    let categories: [String]
}


