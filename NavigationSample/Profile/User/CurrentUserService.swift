//
//  CurrentUserService.swift
//  NavigationSample
//
//  Created by Timur Zakirov on 28/04/26.
//

import UIKit

class CurrentUserService: UserService {
    private let user: User
    
    init(user: User) {
        self.user = user
    }
    
    func getUser(by login: String) -> User? {
         if login == user.login {
             return user
        }
        else {
            return nil
        }
    }
}
