//
//  Checker.swift
//  NavigationSample
//
//  Created by Timur Zakirov on 30/04/26.
//

import UIKit

final class Checker {
    static let shared = Checker()
    
    private let login = "John"
    private let password = "123"
    
    private init() {}
    
    func check (login: String, password: String) -> Bool {
        return self.login == login && self.password == password
    }
}
