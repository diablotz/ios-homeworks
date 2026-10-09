//
//  ReelItem.swift
//  VKApp
//
//  Created by Timur Zakirov on 03/10/26.
//

import Foundation

struct ReelItem {
    let id: UUID
    let authorID: UUID
    let authorName: String
    let authorAvatarName: String?
    let videoName: String
    let captionText: String
    let createdAt: Date
    let likesCount: Int64
    let commentsCount: Int64
    let sharesCount: Int64
    let isLiked: Bool
    let isSaved: Bool
}
