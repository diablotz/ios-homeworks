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
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
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
     
        let favorite = FavoritePost(context: context)
        
        favorite.author = post.author
        favorite.descriptionText = post.description
        favorite.imageName = post.image
        favorite.likes = Int64(post.likes)
        favorite.views = Int64(post.views)
        
        do {
            try context.save()
        }
        catch {print (error)}
        
        return .saved
    }
    
    // чтение
    
    func fetchPosts() -> [FavoritePost] {
        
        let request: NSFetchRequest<FavoritePost> = FavoritePost.fetchRequest()
        
        do {
            return try context.fetch(request)
        }
        catch {return []}
        
    }
    
    // удаление
    
    func deletePost(post: FavoritePost) {
        context.delete(post)
        do {
            try context.save()
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
            return try context.count(for: request) > 0
        }
        catch {
            print("Пост уже был добавлен ", error)
            
            return false
        }
        
        
    }
    
    
}
