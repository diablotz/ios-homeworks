//
//  FeedRepositoryError.swift
//  VKApp
//
//  Created by Timur Zakirov on 01/10/26.
//

import Foundation

enum FeedRepositoryError: LocalizedError {
    case postNotFound
    case authorNotFound
    case emptyPost
    case fetchFailed(Error)
    case saveFailed(Error)
    case videoNotFound

    var errorDescription: String? {
        switch self {
        case .postNotFound:
            return "Публикация не найдена"

        case .authorNotFound:
            return "Автор публикации не найден"

        case .emptyPost:
            return "Введите текст публикации"

        case .fetchFailed:
            return "Не удалось загрузить ленту"

        case .saveFailed:
            return "Не удалось сохранить публикацию"
            
        case .videoNotFound:
            return "Сохранённое видео не найдено."
            
        }
        
        
    }
}
