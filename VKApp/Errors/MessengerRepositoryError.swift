//
//  MessengerRepositoryError.swift
//  VKApp
//
//  Created by Timur Zakirov on 02/10/26.
//

import Foundation

enum MessengerRepositoryError: LocalizedError {
    case conversationNotFound
    case userNotFound
    case emptyMessage
    case fetchFailed(Error)
    case saveFailed(Error)

    var errorDescription: String? {
        switch self {
        case .conversationNotFound:
            return L10n.string("error.dialog_not_found")

        case .userNotFound:
            return L10n.string("error.user_not_found")

        case .emptyMessage:
            return L10n.string("error.enter_message")

        case .fetchFailed:
            return L10n.string("error.load_message")

        case .saveFailed:
            return L10n.string("error.send_message")
        }
    }
}
