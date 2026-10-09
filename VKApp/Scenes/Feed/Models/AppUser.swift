//
//  AppUser.swift
//  VKApp
//
//  Created by Timur Zakirov on 01/10/26.
//

import Foundation

struct AppUser {
    let id: UUID
    let phone: String?
    let firstName: String
    let lastName: String
    let avatarName: String?
    let statusText: String?

    var displayName: String {
        [firstName, lastName]
            .filter { !$0.isEmpty }
            .joined(separator: " ")
    }
}
