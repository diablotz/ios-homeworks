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
            return L10n.string("error.found_photo")

        case .fetchFailed:
            return L10n.string("error.load_photos")

        case .saveFailed:
            return L10n.string("error.not_saved")
        }
    }
}
