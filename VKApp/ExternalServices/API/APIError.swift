//
//  APIError.swift
//  VKApp
//
//  Created by Timur Zakirov on 02/11/26.
//

import Foundation

enum APIError: LocalizedError {

    case invalidURL
    case invalidResponse
    case httpStatus(Int)
    case decoding
    case emptyData

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Не удалось создать URL."

        case .invalidResponse:
            return "Сервер вернул некорректный ответ."

        case let .httpStatus(code):
            return "Ошибка сервера: \(code)."

        case .decoding:
            return "Не удалось обработать данные сервера."

        case .emptyData:
            return "Данные не найдены."
        }
    }
}

