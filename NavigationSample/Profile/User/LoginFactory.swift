//
//  LoginFactory.swift
//  NavigationSample
//
//  Created by Timur Zakirov on 01/05/26.
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

