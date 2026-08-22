//
//  LoginViewModel.swift
//  NavigationSmpl
//
//  Created by Timur Zakirov on 22/08/26.
//

import Foundation

final class LoginViewModel {

    func isValid(
        email: String?,
        password: String?
  
  ) -> Bool {
        guard
            let email,
            let password,
            !email.isEmpty,
            !password.isEmpty
        else {
            return false
        }

        return email.contains("@")
    }
}

