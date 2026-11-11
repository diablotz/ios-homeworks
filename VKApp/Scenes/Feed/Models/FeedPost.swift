//
//  FeedPost.swift
//  VKApp
//
//  Created by Timur Zakirov on 24/09/26.
//


import Foundation

struct FeedPost {
    let id: UUID
    let authorID: UUID

    let authorName: String
    let authorAvatarName: String?

    let text: String

    let imageName: String?
    let videoName: String?
    let mediaType: PostMediaType

    let createdAt: Date

    let likesCount: Int
    let commentsCount: Int
    let sharesCount: Int
    let viewsCount: Int

    let isLiked: Bool

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "d MMM yyyy, HH:mm"

        return formatter.string(from: createdAt)
    }
    
    let externalID: String?
    let externalTitle: String?
    let externalSubtitle: String?
    let externalImageURL: String?
    let externalMediaURL: String?
    let externalStoreURL: String?
}


extension FeedPost {

    var remoteImageURL: URL? {
        guard let externalImageURL else {
            return nil
        }

        return URL(string: externalImageURL)
    }

    var remoteMediaURL: URL? {
        guard let externalMediaURL else {
            return nil
        }

        return URL(string: externalMediaURL)
    }

    var storeURL: URL? {
        guard let externalStoreURL else {
            return nil
        }

        return URL(string: externalStoreURL)
    }
}




//import Foundation
//
//struct FeedPost {
//    let id: UUID
//    let authorID: UUID
//    let authorName: String
//    let authorAvatarName: String?
//    let text: String
//    let imageName: String?
//    let createdAt: Date
//    let likesCount: Int64
//    let viewsCount: Int64
//    let commentsCount: Int64
//    let sharesCount: Int64
//    let isLiked: Bool
//    let videoName: String?
//    let mediaType: PostMediaType
//}
