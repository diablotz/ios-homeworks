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
    
    // контекст CoreData для чтения и изменения объектов Coredata Movies
    private let context =
        PersistenceController.shared.container.viewContext
    
    
    // если CoreData пустая, то добавляем список фильмов
    func addInitialPosts() {

        let request: NSFetchRequest<Movies> = Movies.fetchRequest()

        do {

            // проверяем количество существующих записей
            let existingPosts = try context.count(
                for: request
            )

            print("Фильмов в CoreData: \(existingPosts)")

            // если записи уже есть? их не добавляем повторно
            guard existingPosts == 0 else {
                return
            }

            for post in PostData.posts {

                // создаем объект Movies в контексте Coredata
                let movie = Movies(context: context)

                movie.title = post.title
                movie.movieDescription = post.description
                movie.imageName = post.imageName
                movie.rating = post.rating
                movie.genre = post.genre
                movie.year = post.year
                movie.viewsCount = 0
                movie.trailerURL = post.trailerURL
            }
            
            // сохраняем в Coredata
            try context.save()

            print("Фильмы успешно добавлены: \(PostData.posts.count)")

        } catch {

            print("Ошибка CoreData: \(error)")
        }
    }


    // чистим хранилище Coredata
    func deleteAllMovies() {
        
        let request: NSFetchRequest<Movies> =
        Movies.fetchRequest()
        
        do {
            
            let movies = try context.fetch(request)
            
            for movie in movies {
                context.delete(movie)
            }
            
            try context.save()
            
            print("Фильмы успешно удалены")
        }
        catch {
            print("Ошибка удаления: \(error.localizedDescription)")
        }
    }
    
    // пересохраняем хранилище CoreData
    func resetMovies() {
        deleteAllMovies()
        addInitialPosts()
    }
    
    
}

