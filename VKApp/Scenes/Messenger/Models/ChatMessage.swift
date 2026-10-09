//
//  ChatMessage.swift
//  VKApp
//
//  Created by Timur Zakirov on 02/10/26.
//

import Foundation

struct ChatMessage {
    let id: UUID
    let text: String
    let sentAt: Date
    let senderID: UUID
    let isOutgoing: Bool
    let isRead: Bool
}
