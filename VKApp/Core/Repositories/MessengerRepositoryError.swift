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
            return "Диалог не найден"

        case .userNotFound:
            return "Пользователь не найден"

        case .emptyMessage:
            return "Введите сообщение"

        case .fetchFailed:
            return "Не удалось загрузить сообщения"

        case .saveFailed:
            return "Не удалось отправить сообщение"
        }
    }
}
