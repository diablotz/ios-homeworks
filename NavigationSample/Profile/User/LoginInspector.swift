//
//  LoginInspector.swift
//  NavigationSample
//
//  Created by Timur Zakirov on 30/04/26.
//

import UIKit

struct LoginInspector: LoginViewControllerDelegate {
    func check(login: String, password: String) -> Bool {
        return Checker.shared.check(login: login, password: password)
    }
}


