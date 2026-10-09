//
//  UserRepository.swift
//  VKApp
//
//  Created by Timur Zakirov on 01/10/26.
//

import Foundation

protocol UserRepository {
    
    func fetchFriends() throws -> [FriendListItem]
    func fetchUser(id: UUID) throws -> AppUser?
    func fetchUsers() throws ->[FriendListItem]
}
