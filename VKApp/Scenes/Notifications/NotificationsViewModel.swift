//
//  NotificationsViewModel.swift
//  VKApp
//
//  Created by Timur Zakirov on 02/10/26.
//

import Foundation

final class NotificationsViewModel {

    private let repository: NotificationRepository

    private(set) var notifications: [AppNotification] = []

    var onDataChanged: (() -> Void)?
    var onError: ((String) -> Void)?

    init(repository: NotificationRepository) {
        self.repository = repository
    }

    func loadNotifications() {
        do {
            notifications =
                try repository.fetchNotifications()

            onDataChanged?()
        } catch {
            show(error)
        }
    }

    func notification(
        at index: Int
    ) -> AppNotification? {
        guard notifications.indices.contains(index) else {
            return nil
        }

        return notifications[index]
    }

    func markAsRead(at index: Int) {
        guard let notification = notification(at: index) else {
            return
        }

        guard !notification.isRead else {
            return
        }

        do {
            try repository.markAsRead(id: notification.id)
            loadNotifications()
        } catch {
            show(error)
        }
    }

    func delete(at index: Int) {
        guard let notification = notification(at: index) else {
            return
        }

        do {
            try repository.delete(id: notification.id)
            loadNotifications()
        } catch {
            show(error)
        }
    }

    private func show(_ error: Error) {
        let message =
            (error as? LocalizedError)?.errorDescription
            ?? "Не удалось выполнить операцию"

        onError?(message)
    }
}
