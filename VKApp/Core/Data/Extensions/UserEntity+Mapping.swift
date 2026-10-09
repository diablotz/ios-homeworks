//
//  UserEntity+Mapping.swift
//  VKApp
//
//  Created by Timur Zakirov on 22/09/26.
//

import Foundation

extension UserEntity {

    func toModel() -> AppUser {
        AppUser(
            id: id ?? UUID(),
            phone: phone,
            firstName: firstName ?? "",
            lastName: lastName ?? "",
            avatarName: avatarName,
            statusText: statusText
        )
    }
}

