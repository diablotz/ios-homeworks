//
//  LoginInspector.swift
//  NavigationSmpl
//
//  Created by Timur Zakirov on 07/05/26.
//

import UIKit

struct LoginInspector: LoginViewControllerDelegate {
    func check(login: String, password: String) -> Bool {
        return Checker.shared.check(login: login, password: password)
    }
}
