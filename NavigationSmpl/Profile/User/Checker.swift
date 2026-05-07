//
//  Checker.swift
//  NavigationSmpl
//
//  Created by Timur Zakirov on 07/05/26.
//

import UIKit

final class Checker {
    static let shared = Checker()
    #if DEBUG
        private let login = "test"
        private let password = "test"
    #else
        private let login = "John"
        private let password = "123"
    #endif
    
    
    private init() {}
    
    func check (login: String, password: String) -> Bool {
        return self.login == login && self.password == password
    }
}
