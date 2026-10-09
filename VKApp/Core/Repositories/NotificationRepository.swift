//
//  NotificationRepository.swift
//  VKApp
//
//  Created by Timur Zakirov on 02/10/26.
//

import Foundation

protocol NotificationRepository {
    func fetchNotifications() throws -> [AppNotification]
    func markAsRead(id: UUID) throws
    func delete(id: UUID) throws
    func unreadCount() throws -> Int
}
