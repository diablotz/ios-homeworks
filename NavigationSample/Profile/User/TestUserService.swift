//
//  TestUserService.swift
//  NavigationSample
//
//  Created by Timur Zakirov on 30/04/26.
//

import UIKit

final class TestUserService: UserService {
    let user = User(
        login: "dog",
        fullName: "Running dog",
        //avatar: UIImage(named: "test-avatar"),
        avatar: UIImage(systemName: "person.circle"),
        status: "DEBUG mode"
    )
    /*
    func getUser(by login: String) -> User? {
        if login == user.login {
            return user
        }
        return nil
    }
     */
}
