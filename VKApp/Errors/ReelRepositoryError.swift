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
            return L10n.string("error.clip_found")

        case .authorNotFound:
            return L10n.string("error.author_video_found")

        case .videoNotSelected:
            return L10n.string("create.select_video")

        case .emptyCaption:
            return L10n.string("error.description_clip")

        case .fetchFailed:
            return L10n.string("error.load_clip")

        case .saveFailed:
            return L10n.string("error.save_clip")
        }
    }
}


