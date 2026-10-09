//
//  CoreDataPhotoRepository.swift
//  VKApp
//
//  Created by Timur Zakirov on 01/10/26.
//

import Foundation
import CoreData

final class CoreDataPhotoRepository: PhotoRepository {

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func fetchPhotos() throws -> [PhotoItem] {
        let request = NSFetchRequest<PhotoEntity>(
            entityName: "PhotoEntity"
        )

        request.sortDescriptors = [
            NSSortDescriptor(
                key: "createdAt",
                ascending: false
            )
        ]

        do {
            return try context.fetch(request).compactMap {
                photo in

                guard
                    let id = photo.id,
                    let imageName = photo.imageName,
                    let author = photo.author,
                    let authorID = author.id
                else {
                    return nil
                }

                return PhotoItem(
                    id: id,
                    imageName: imageName,
                    authorID: authorID,
                    authorName: author.displayName,
                    createdAt: photo.createdAt ?? Date(),
                    likesCount: photo.likesCount,
                    isLiked: photo.isLiked
                )
            }
        } catch {
            throw PhotoRepositoryError.fetchFailed(error)
        }
    }

    func toggleLike(photoID: UUID) throws {
        let request = NSFetchRequest<PhotoEntity>(
            entityName: "PhotoEntity"
        )

        request.fetchLimit = 1
        request.predicate = NSPredicate(
            format: "id == %@",
            photoID as NSUUID
        )

        do {
            guard let photo = try context.fetch(request).first else {
                throw PhotoRepositoryError.photoNotFound
            }

            photo.isLiked.toggle()

            if photo.isLiked {
                photo.likesCount += 1
            } else {
                photo.likesCount = max(
                    0,
                    photo.likesCount - 1
                )
            }

            try context.save()
        } catch let error as PhotoRepositoryError {
            throw error
        } catch {
            context.rollback()
            throw PhotoRepositoryError.saveFailed(error)
        }
    }
}
