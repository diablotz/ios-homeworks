//
//  ChatViewModel.swift
//  VKApp
//
//  Created by Timur Zakirov on 02/10/26.
//

import Foundation

final class ChatViewModel {

    let title: String

    private let conversationID: UUID
    private let currentUserID: UUID
    private let repository: MessengerRepository

    private(set) var messages: [ChatMessage] = []

    var onDataChanged: (() -> Void)?
    var onError: ((String) -> Void)?

    init(
        conversation: ConversationItem,
        currentUserID: UUID,
        repository: MessengerRepository
    ) {
        title = conversation.title
        conversationID = conversation.id
        self.currentUserID = currentUserID
        self.repository = repository
    }

    func loadMessages() {
        do {
            try repository.markConversationAsRead(
                conversationID: conversationID,
                currentUserID: currentUserID
            )

            messages = try repository.fetchMessages(
                conversationID: conversationID,
                currentUserID: currentUserID
            )

            onDataChanged?()
        } catch {
            show(error)
        }
    }

    func send(text: String) -> Bool {
        do {
            try repository.sendMessage(
                text: text,
                conversationID: conversationID,
                senderID: currentUserID
            )

            loadMessages()
            return true
        } catch {
            show(error)
            return false
        }
    }

    private func show(_ error: Error) {
        onError?(
            (error as? LocalizedError)?.errorDescription
            ?? "Не удалось выполнить операцию"
        )
    }
}
