//
//  CoreDataMessengerRepository.swift
//  VKApp
//
//  Created by Timur Zakirov on 02/10/26.
//

import Foundation
import CoreData


final class CoreDataMessengerRepository:
    MessengerRepository {

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func fetchConversations() throws -> [ConversationItem] {
        let request = NSFetchRequest<ConversationEntity>(
            entityName: "ConversationEntity"
        )

        request.sortDescriptors = [
            NSSortDescriptor(
                key: "updatedAt",
                ascending: false
            )
        ]

        do {
            return try context.fetch(request).compactMap {
                conversation in

                guard let id = conversation.id else {
                    return nil
                }

                let messages =
                    conversation.messages as? Set<MessageEntity>
                    ?? []

                let lastMessage = messages.max {
                    ($0.sentAt ?? .distantPast)
                    < ($1.sentAt ?? .distantPast)
                }

                return ConversationItem(
                    id: id,
                    title: conversation.title ?? "Диалог",
                    avatarName: conversation.avatarName,
                    lastMessage: lastMessage?.text ?? "",
                    updatedAt:
                        lastMessage?.sentAt
                        ?? conversation.updatedAt
                        ?? Date(),
                    unreadCount: conversation.unreadCount
                )
            }
        } catch {
            throw MessengerRepositoryError.fetchFailed(error)
        }
    }

    func fetchMessages(
        conversationID: UUID,
        currentUserID: UUID
    ) throws -> [ChatMessage] {
        let request = NSFetchRequest<MessageEntity>(
            entityName: "MessageEntity"
        )

        request.predicate = NSPredicate(
            format: "conversation.id == %@",
            conversationID as NSUUID
        )

        request.sortDescriptors = [
            NSSortDescriptor(
                key: "sentAt",
                ascending: true
            )
        ]

        do {
            return try context.fetch(request).compactMap {
                message in

                guard
                    let id = message.id,
                    let senderID = message.sender?.id
                else {
                    return nil
                }

                return ChatMessage(
                    id: id,
                    text: message.text ?? "",
                    sentAt: message.sentAt ?? Date(),
                    senderID: senderID,
                    isOutgoing: senderID == currentUserID,
                    isRead: message.isRead
                )
            }
        } catch {
            throw MessengerRepositoryError.fetchFailed(error)
        }
    }

    func sendMessage(
        text: String,
        conversationID: UUID,
        senderID: UUID
    ) throws {
        let trimmedText = text.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !trimmedText.isEmpty else {
            throw MessengerRepositoryError.emptyMessage
        }

        do {
            let conversation = try findConversation(
                id: conversationID
            )

            let sender = try findUser(id: senderID)

            let message = MessageEntity(context: context)
            message.id = UUID()
            message.text = trimmedText
            message.sentAt = Date()
            message.isRead = true
            message.sender = sender
            message.conversation = conversation

            conversation.updatedAt = Date()
            conversation.unreadCount = 0

            try context.save()
        } catch let error as MessengerRepositoryError {
            throw error
        } catch {
            context.rollback()
            throw MessengerRepositoryError.saveFailed(error)
        }
    }

    func markConversationAsRead(
        conversationID: UUID,
        currentUserID: UUID
    ) throws {
        do {
            let conversation = try findConversation(
                id: conversationID
            )

            let request = NSFetchRequest<MessageEntity>(
                entityName: "MessageEntity"
            )

            request.predicate = NSPredicate(
                format: """
                conversation.id == %@ AND \
                sender.id != %@ AND \
                isRead == NO
                """,
                conversationID as NSUUID,
                currentUserID as NSUUID
            )

            let messages = try context.fetch(request)

            messages.forEach {
                $0.isRead = true
            }

            conversation.unreadCount = 0

            if context.hasChanges {
                try context.save()
            }
        } catch let error as MessengerRepositoryError {
            throw error
        } catch {
            context.rollback()
            throw MessengerRepositoryError.saveFailed(error)
        }
    }

    private func findConversation(
        id: UUID
    ) throws -> ConversationEntity {
        let request = NSFetchRequest<ConversationEntity>(
            entityName: "ConversationEntity"
        )

        request.fetchLimit = 1
        request.predicate = NSPredicate(
            format: "id == %@",
            id as NSUUID
        )

        guard
            let conversation =
                try context.fetch(request).first
        else {
            throw MessengerRepositoryError
                .conversationNotFound
        }

        return conversation
    }

    private func findUser(
        id: UUID
    ) throws -> UserEntity {
        let request = NSFetchRequest<UserEntity>(
            entityName: "UserEntity"
        )

        request.fetchLimit = 1
        request.predicate = NSPredicate(
            format: "id == %@",
            id as NSUUID
        )

        guard
            let user = try context.fetch(request).first
        else {
            throw MessengerRepositoryError.userNotFound
        }

        return user
    }
}
