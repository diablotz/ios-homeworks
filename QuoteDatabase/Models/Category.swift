//
//  Category.swift
//  QuoteDatabase
//
//  Created by Timur Zakirov on 22/07/26.
//

import Foundation
import RealmSwift

class Category: Object {
    @Persisted(primaryKey: true) var name: String
    
    @Persisted(originProperty: "category") var quotes: LinkingObjects<Quote>
}
