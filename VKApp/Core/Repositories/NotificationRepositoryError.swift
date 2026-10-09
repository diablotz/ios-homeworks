//
//  NotificationRepositoryError.swift
//  VKApp
//
//  Created by Timur Zakirov on 02/10/26.
//

import Foundation

enum NotificationRepositoryError: LocalizedError {
    case notificationNotFound
    case fetchFailed(Error)
    case saveFailed(Error)

    var errorDescription: String? {
        switch self {
        case .notificationNotFound:
            return "Уведомление не найдено"

        case .fetchFailed:
            return "Не удалось загрузить уведомления"

        case .saveFailed:
            return "Не удалось сохранить изменение"
        }
    }
}
