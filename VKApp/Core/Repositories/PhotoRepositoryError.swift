//
//  PhotoRepositoryError.swift
//  VKApp
//
//  Created by Timur Zakirov on 01/10/26.
//

import Foundation

enum PhotoRepositoryError: LocalizedError {
    case photoNotFound
    case fetchFailed(Error)
    case saveFailed(Error)

    var errorDescription: String? {
        switch self {
        case .photoNotFound:
            return "Фотография не найдена"

        case .fetchFailed:
            return "Не удалось загрузить фотографии"

        case .saveFailed:
            return "Не удалось сохранить изменение"
        }
    }
}
