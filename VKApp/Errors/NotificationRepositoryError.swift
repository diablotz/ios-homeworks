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
            return L10n.string("error.found_notification")

        case .fetchFailed:
            return L10n.string("error.load_notifications")

        case .saveFailed:
            return L10n.string("error.not_saved")
        }
    }
}
