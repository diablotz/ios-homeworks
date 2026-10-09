//
//  PhotoItem.swift
//  VKApp
//
//  Created by Timur Zakirov on 01/10/26.
//

import Foundation

struct PhotoItem {
    
    let id: UUID
    let imageName: String
    let authorID: UUID
    let authorName: String
    let createdAt: Date
    let likesCount: Int64
    let isLiked: Bool
}
