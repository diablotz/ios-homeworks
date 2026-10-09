//
//  CoreDataNotificationRepository.swift
//  VKApp
//
//  Created by Timur Zakirov on 02/10/26.
//

import CoreData
import Foundation

final class CoreDataNotificationRepository:
    NotificationRepository {

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func fetchNotifications() throws -> [AppNotification] {
        let request = NSFetchRequest<NotificationEntity>(
            entityName: "NotificationEntity"
        )

        request.sortDescriptors = [
            NSSortDescriptor(
                key: "createdAt",
                ascending: false
            )
        ]

        do {
            return try context.fetch(request).compactMap {
                entity in

                guard let id = entity.id else {
                    return nil
                }

                return AppNotification(
                    id: id,
                    kind: entity.notificationKind,
                    message: entity.message ?? "",
                    createdAt: entity.createdAt ?? Date(),
                    isRead: entity.isRead,
                    senderName: entity.sender?.displayName,
                    senderAvatarName: entity.sender?.avatarName,
                    postID: entity.post?.id
                )
            }
        } catch {
            throw NotificationRepositoryError.fetchFailed(
                error
            )
        }
    }

    func markAsRead(id: UUID) throws {
        let notification = try findNotification(id: id)

        guard !notification.isRead else {
            return
        }

        notification.isRead = true

        do {
            try context.save()
        } catch {
            context.rollback()
            throw NotificationRepositoryError.saveFailed(error)
        }
    }

    func delete(id: UUID) throws {
        let notification = try findNotification(id: id)

        context.delete(notification)

        do {
            try context.save()
        } catch {
            context.rollback()
            throw NotificationRepositoryError.saveFailed(error)
        }
    }

    func unreadCount() throws -> Int {
        let request = NSFetchRequest<NotificationEntity>(
            entityName: "NotificationEntity"
        )

        request.predicate = NSPredicate(
            format: "isRead == NO"
        )

        do {
            return try context.count(for: request)
        } catch {
            throw NotificationRepositoryError.fetchFailed(
                error
            )
        }
    }

    private func findNotification(
        id: UUID
    ) throws -> NotificationEntity {
        let request = NSFetchRequest<NotificationEntity>(
            entityName: "NotificationEntity"
        )

        request.fetchLimit = 1
        request.predicate = NSPredicate(
            format: "id == %@",
            id as NSUUID
        )

        do {
            guard
                let notification =
                    try context.fetch(request).first
            else {
                throw NotificationRepositoryError
                    .notificationNotFound
            }

            return notification
        } catch let error as NotificationRepositoryError {
            throw error
        } catch {
            throw NotificationRepositoryError.fetchFailed(
                error
            )
        }
    }
}
