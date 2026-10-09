//
//  ReelRepositoryError.swift
//  VKApp
//
//  Created by Timur Zakirov on 03/10/26.
//

import Foundation

enum ReelRepositoryError: LocalizedError {
    case reelNotFound
    case authorNotFound
    case videoNotSelected
    case emptyCaption
    case fetchFailed(Error)
    case saveFailed(Error)

    var errorDescription: String? {
        switch self {
        case .reelNotFound:
            return "Клип не найден"

        case .authorNotFound:
            return "Автор клипа не найден"

        case .videoNotSelected:
            return "Выберите видео"

        case .emptyCaption:
            return "Введите описание клипа"

        case .fetchFailed:
            return "Не удалось загрузить клипы"

        case .saveFailed:
            return "Не удалось сохранить клип"
        }
    }
}


