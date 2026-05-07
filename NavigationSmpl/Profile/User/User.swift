//
//  User.swift
//  NavigationSmpl
//
//  Created by Timur Zakirov on 06/05/26.
//

import UIKit

final class User {
    
    let login: String
    let fullName: String
    let avatar: UIImage?
    let status: String
    
    init(login: String, fullName: String, avatar: UIImage?, status: String) {
        self.login = login
        self.fullName = fullName
        self.avatar = avatar
        self.status = status
    }
}

protocol UserService {
    var user: User { get }
    func getUser(by login: String) -> User?
}

extension UserService {
    func getUser(by login: String) -> User? {
        return login == user.login ? user : nil
    }
}
