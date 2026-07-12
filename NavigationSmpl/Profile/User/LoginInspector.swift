//
//  LoginInspector.swift
//  NavigationSmpl
//
//  Created by Timur Zakirov on 07/05/26.
//

import UIKit

final class LoginInspector: LoginViewControllerDelegate {
    /*
    func check(login: String, password: String) -> Bool {
        return Checker.shared.check(login: login, password: password)
    }
     */
    
    private let checker: CheckerServiceProtocol
    
    init(checker: CheckerServiceProtocol) {
        self.checker = checker
    }
    
    func checkCredentials(
        email: String,
        password: String,
        completion: @escaping (Result<Void, any Error>) -> Void
    ) {
        checker.checkCredentials(
            email: email,
            password: password,
            completion: completion
        )
    }
    
    func signUp(
        email: String,
        password: String,
        completion: @escaping (Result<Void, any Error>) -> Void
    )
    {
        checker.signUp(
            email: email,
            password: password,
            completion: completion
        )
    }
    
    
}
