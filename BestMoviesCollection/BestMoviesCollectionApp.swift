//
//  BestMoviesCollectionApp.swift
//  BestMoviesCollection
//
//  Created by Timur Zakirov on 27/08/26.
//

import SwiftUI
import CoreData

@main
struct BestMoviesCollectionApp: App {
    let persistenceController = PersistenceController.shared
       
       init() {
           CoreDataManager.shared.addInitialPosts()
           //CoreDataManager.shared.resetMovies()
       }
       
       var body: some Scene {
           
           WindowGroup {
               
               ContentView()
                   .environment(
                       \.managedObjectContext,
                       persistenceController.container.viewContext
                   )
           }
       }

}
