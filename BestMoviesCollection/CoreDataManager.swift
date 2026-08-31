//
//  CoreDataManager.swift
//  BestMoviesCollection
//
//  Created by Timur Zakirov on 27/08/26.
//

import Foundation
import CoreData

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private init() {}
    
    private let context =
        PersistenceController.shared.container.viewContext
    
    func addInitialPosts() {
        
        let request: NSFetchRequest<Movies> =
        Movies.fetchRequest()
        
        do {
            
            let existingPosts = try context.count(for: request)
            
            print("Фильмов в CoreData: \(existingPosts)")
            
            guard existingPosts == 0 else {
                return
            }
            
            for post in PostData.posts {
                
                let movie = Movies(context: context)
                
                movie.title = post.title
                movie.movieDescription = post.description
                movie.imageName = post.imageName
                movie.rating = post.rating
                movie.genre = post.genre
                movie.date = post.date
            }
            
            try context.save()
            
            print("Фильмы успешно добавлены")
            
        } catch {
            
            print("Ошибка CoreData: \(error)")
        }
    }
}

