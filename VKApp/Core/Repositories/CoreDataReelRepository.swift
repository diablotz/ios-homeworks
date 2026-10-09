//
//  CoreDataReelRepository.swift
//  VKApp
//
//  Created by Timur Zakirov on 03/10/26.
//

import Foundation
import CoreData

final class CoreDataReelRepository: ReelRepository {

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func fetchReels() throws -> [ReelItem] {
        let request = NSFetchRequest<ReelEntity>(
            entityName: "ReelEntity"
        )

        request.sortDescriptors = [
            NSSortDescriptor(
                key: "createdAt",
                ascending: false
            )
        ]

        do {
            return try context.fetch(request).compactMap {
                reel in

                guard
                    let id = reel.id,
                    let videoName = reel.videoName,
                    let author = reel.author,
                    let authorID = author.id
                else {
                    return nil
                }

                return ReelItem(
                    id: id,
                    authorID: authorID,
                    authorName: author.displayName,
                    authorAvatarName: author.avatarName,
                    videoName: videoName,
                    captionText: reel.captionText ?? "",
                    createdAt: reel.createdAt ?? Date(),
                    likesCount: reel.likesCount,
                    commentsCount: reel.commentsCount,
                    sharesCount: reel.sharesCount,
                    isLiked: reel.isLiked,
                    isSaved: reel.isSaved
                )
            }
        } catch {
            throw ReelRepositoryError.fetchFailed(error)
        }
    }

    func toggleLike(id: UUID) throws {
        let reel = try findReel(id: id)

        reel.isLiked.toggle()

        if reel.isLiked {
            reel.likesCount += 1
        } else {
            reel.likesCount = max(
                0,
                reel.likesCount - 1
            )
        }

        try save()
    }

    func toggleSaved(id: UUID) throws {
        let reel = try findReel(id: id)
        reel.isSaved.toggle()
        try save()
    }

    private func findReel(id: UUID) throws -> ReelEntity {
        let request = NSFetchRequest<ReelEntity>(
            entityName: "ReelEntity"
        )

        request.fetchLimit = 1
        request.predicate = NSPredicate(
            format: "id == %@",
            id as NSUUID
        )

        do {
            guard let reel = try context.fetch(request).first else {
                throw ReelRepositoryError.reelNotFound
            }

            return reel
        } catch let error as ReelRepositoryError {
            throw error
        } catch {
            throw ReelRepositoryError.fetchFailed(error)
        }
    }

    private func save() throws {
        do {
            try context.save()
        } catch {
            context.rollback()
            throw ReelRepositoryError.saveFailed(error)
        }
    }
    
    
    func createReel(
        authorID: UUID,
        videoName: String,
        caption: String
    ) throws {
        let trimmedCaption = caption.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !videoName.isEmpty else {
            throw ReelRepositoryError.videoNotSelected
        }

        guard !trimmedCaption.isEmpty else {
            throw ReelRepositoryError.emptyCaption
        }

        let request = NSFetchRequest<UserEntity>(
            entityName: "UserEntity"
        )

        request.fetchLimit = 1
        request.predicate = NSPredicate(
            format: "id == %@",
            authorID as NSUUID
        )

        do {
            guard let author = try context.fetch(request).first else {
                throw ReelRepositoryError.authorNotFound
            }

            let reel = ReelEntity(context: context)

            reel.id = UUID()
            reel.author = author
            reel.videoName = videoName
            reel.captionText = trimmedCaption
            reel.createdAt = Date()
            reel.likesCount = 0
            reel.commentsCount = 0
            reel.sharesCount = 0
            reel.isLiked = false
            reel.isSaved = false

            try context.save()


        } catch let error as ReelRepositoryError {
            throw error
        } catch {
            context.rollback()
            throw ReelRepositoryError.saveFailed(error)
        }
    }


}
