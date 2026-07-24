//
//  Quote.swift
//  QuoteDatabase
//
//  Created by Timur Zakirov on 22/07/26.
//

import Foundation
import RealmSwift

class Quote: Object {
    @Persisted(primaryKey: true) var text: String
    
    @Persisted var createdDate: Date = Date()
    
    @Persisted var category: Category?
}
