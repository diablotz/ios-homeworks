//
//  CheckerService.swift
//  NavigationSmpl
//
//  Created by Timur Zakirov on 10/07/26.
//

import Foundation

import FirebaseAuth

final class CheckerService: CheckerServiceProtocol {
    
    func checkCredentials(email: String, password: String, completion: @escaping (Result<Void, any Error>) -> Void) {
        Auth.auth().signIn(withEmail: email,password: password)
        { _, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func signUp(email: String, password: String, completion: @escaping (Result<Void, any Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { _, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
}
