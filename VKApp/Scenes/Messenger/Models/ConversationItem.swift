//
//  ConversationItem.swift
//  VKApp
//
//  Created by Timur Zakirov on 02/10/26.
//

import Foundation

struct ConversationItem {
    let id: UUID
    let title: String
    let avatarName: String?
    let lastMessage: String
    let updatedAt: Date
    let unreadCount: Int64
}
