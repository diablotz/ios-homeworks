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
    case invalidExternalMedia
    case userNotFound

    var errorDescription: String? {
        switch self {
        case .postNotFound:
            return L10n.string("error.publication_not_found")

        case .authorNotFound:
            return L10n.string("error.author_not_found")

        case .emptyPost:
            return L10n.string("error.empty_post")

        case .fetchFailed:
            return L10n.string("error.feed_load")

        case .saveFailed:
            return L10n.string("error.save_failed")
            
        case .videoNotFound:
            return L10n.string("error.video_not_found")
            
        case .invalidExternalMedia:
            return L10n.string("error.failed_external")
            
        case .userNotFound:
            return L10n.string("error.user_not_found")
            
        }
        
    
        
        
    }
}
