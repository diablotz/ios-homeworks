//
//  TestUserService.swift
//  NavigationSample
//
//  Created by Timur Zakirov on 30/04/26.
//

import UIKit

final class TestUserService: UserService {
    let testUser = User(
        login: "test",
        fullName: "Test User",
        avatar: UIImage(named: "test-avatar"),
        status: "DEBUG mode"
    )
    
    func getUser(by login: String) -> User? {
        if login == testUser.login {
            return testUser
        }
        return nil
    }
}
