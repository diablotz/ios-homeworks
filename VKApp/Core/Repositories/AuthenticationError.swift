//
//  AuthenticationError.swift
//  VKApp
//
//  Created by Timur Zakirov on 22/09/26.
//

import Foundation

enum AuthenticationError: LocalizedError {
    case invalidPhone
    case userNotFound
    case phoneAlreadyRegistered
    case storageError(Error)

    var errorDescription: String? {
        switch self {
        case .invalidPhone:
            return "Введите корректный номер телефона"

        case .userNotFound:
            return "Пользователь с таким номером не найден"

        case .phoneAlreadyRegistered:
            return "Этот номер телефона уже зарегистрирован"

        case .storageError:
            return "Не удалось выполнить операцию с базой данных"
        }
    }
}
