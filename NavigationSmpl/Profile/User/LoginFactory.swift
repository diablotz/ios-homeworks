//
//  LoginFactory.swift
//  NavigationSmpl
//
//  Created by Timur Zakirov on 07/05/26.
//

import UIKit

protocol LoginFactory {
    func makeLoginInspector() -> LoginInspector
}

struct MyLoginFactory: LoginFactory {
    func makeLoginInspector() -> LoginInspector {
            return LoginInspector()
    }
}
