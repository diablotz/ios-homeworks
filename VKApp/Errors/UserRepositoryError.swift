//
//  UserRepositoryError.swift
//  VKApp
//
//  Created by Timur Zakirov on 01/10/26.
//

import Foundation

enum UserRepositoryError: LocalizedError {
    case fetchFailed(Error)

    var errorDescription: String? {
        switch self {
        case .fetchFailed:
            return "Не удалось загрузить пользователей"
        }
    }
}
