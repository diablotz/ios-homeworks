//
//  FriendsListItem.swift
//  VKApp
//
//  Created by Timur Zakirov on 01/10/26.
//

import Foundation

struct FriendListItem {
    let id: UUID
    let fullName: String
    let avatarName: String?
    let statusText: String?
    let isOnline: Bool
}
