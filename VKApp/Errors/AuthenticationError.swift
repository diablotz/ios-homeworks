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
            return L10n.string("error.valid_phone")

        case .userNotFound:
            return L10n.string("error.number_not_found")

        case .phoneAlreadyRegistered:
            return L10n.string("error.number_registred")

        case .storageError:
            return L10n.string("error.database")
        }
    }
}
