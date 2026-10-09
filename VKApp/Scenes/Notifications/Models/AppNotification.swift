//
//  AppNotification.swift
//  VKApp
//
//  Created by Timur Zakirov on 02/10/26.
//

import Foundation

struct AppNotification {
    let id: UUID
    let kind: NotificationKind
    let message: String
    let createdAt: Date
    let isRead: Bool
    let senderName: String?
    let senderAvatarName: String?
    let postID: UUID?
}
