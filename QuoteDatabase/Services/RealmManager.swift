//
//  RealmManager.swift
//  QuoteDatabase
//
//  Created by Timur Zakirov on 22/07/26.
//

import Foundation
import RealmSwift

final class RealmManager{
    
    static let shared = RealmManager()
    
    private let realm = try! Realm()
    
    private init(){}
    
    func save(receivedQuote: ReceivedQuote) {
        if realm.object(ofType: Quote.self, forPrimaryKey: receivedQuote.value) != nil {
            return
        }
        
        let quote = Quote()
        
        quote.text = receivedQuote.value
        
        if let categoryName = receivedQuote.categories.first {
            var category = realm.object(ofType: Category.self, forPrimaryKey: categoryName)
            
            
            if category == nil {
                let newCategory = Category()
                newCategory.name = categoryName
                
                try! realm.write {
                    realm.add(newCategory)
                }
                
                category = newCategory
            }
            
            quote.category = category
        }
            try! realm.write {
                realm.add(quote)
            }
                  
    }
    
    func getAllQuotes() -> Results<Quote> {
        
        realm.objects(Quote.self)
            .sorted(byKeyPath: "createdDate", ascending: false)
    }
    
    func getCategories() -> Results<Category> {
        
        realm.objects(Category.self)
            .sorted(byKeyPath: "name")
    }
    
    
    
}
