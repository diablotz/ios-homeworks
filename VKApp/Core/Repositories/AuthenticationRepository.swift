//
//  AuthenticationRepository.swift
//  VKApp
//
//  Created by Timur Zakirov on 22/09/26.
//

import Foundation

protocol AuthenticationRepository {
    func login(phone: String) throws -> AppUser
    func register(phone: String) throws -> AppUser
    func currentUser() throws -> AppUser?
    func logout()
}
