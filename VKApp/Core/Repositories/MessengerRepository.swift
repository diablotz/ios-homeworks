//
//  MessengerRepository.swift
//  VKApp
//
//  Created by Timur Zakirov on 02/10/26.
//

import Foundation

protocol MessengerRepository {
    func fetchConversations() throws -> [ConversationItem]

    func fetchMessages(
        conversationID: UUID,
        currentUserID: UUID
    ) throws -> [ChatMessage]

    func sendMessage(
        text: String,
        conversationID: UUID,
        senderID: UUID
    ) throws

    func markConversationAsRead(
        conversationID: UUID,
        currentUserID: UUID
    ) throws
}
