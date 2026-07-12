//
//  CheckerServiceProtocol.swift
//  NavigationSmpl
//
//  Created by Timur Zakirov on 10/07/26.
//

import Foundation

protocol CheckerServiceProtocol {
    
    func checkCredentials(
        email: String,
        password: String,
        completion: @escaping (Result<Void, Error>) -> Void
    )
    
    func signUp(
        email: String,
        password: String,
        completion: @escaping (Result<Void, Error>) -> Void
    )
}
