//
//  CoreDataManager.swift
//  NavigationSmpl
//
//  Created by Timur Zakirov on 27/07/26.
//

import Foundation
import CoreData
import StorageService

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private init() {}
    
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Navigation")
        
        container.loadPersistentStores {_, error in
            if let error {
                fatalError(error.localizedDescription)
            }
        }
        return container
    }()
    // меняем переменную для работы в фоне
//    var context: NSManagedObjectContext {
//        persistentContainer.viewContext
//    }
    private lazy var backgroundContext: NSManagedObjectContext = {
        persistentContainer.newBackgroundContext()
    }()
    
    
    enum SavePostResults {
        case saved
        case dublicate
    }
    
    // сохранение
    
    func save(post: Post) -> SavePostResults {
        
        if isPostSaved(
            author: post.author,
            description: post.description
        )
        {
            return .dublicate
        }
     
        let favorite = FavoritePost(context: backgroundContext)
        
        favorite.author = post.author
        favorite.descriptionText = post.description
        favorite.imageName = post.image
        favorite.likes = Int64(post.likes)
        favorite.views = Int64(post.views)
        
        do {
            try backgroundContext.save()
        }
        catch {print (error)}
        
        return .saved
    }
    
    // чтение
    
    func fetchPosts() -> [FavoritePost] {
        
        let request: NSFetchRequest<FavoritePost> = FavoritePost.fetchRequest()
        
        do {
            return try backgroundContext.fetch(request)
        }
        catch {return []}
        
    }
    // перегруженный метод для поиска по автору
    func fetchPosts(author: String) -> [FavoritePost] {

        let request: NSFetchRequest<FavoritePost> =
            FavoritePost.fetchRequest()

        request.predicate = NSPredicate(
            format: "author CONTAINS[cd] %@",
            author
        )

        do {
            return try backgroundContext.fetch(request)
        } catch {
            return []
        }
    }
    
    // удаление
    
    func deletePost(post: FavoritePost) {
        backgroundContext.delete(post)
        do {
            try backgroundContext.save()
        }
        catch {print (error)}
    }
    
    // проверка на дублирование
    func isPostSaved(author: String, description: String) -> Bool {
        let request: NSFetchRequest<FavoritePost> = FavoritePost.fetchRequest()
        
        request.predicate = NSPredicate(
            format: "author == %@ and descriptionText == %@",
            author,
            description
        )
        
        do {
            return try backgroundContext.count(for: request) > 0
        }
        catch {
            print("Пост уже был добавлен ", error)
            
            return false
        }
        
        
    }
    
    
}
