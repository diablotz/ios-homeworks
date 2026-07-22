//
//  KeychainService.swift
//  Documents
//
//  Created by Timur Zakirov on 18/07/26.
//

import Foundation
import KeychainAccess


final class KeychainService{
    
    static let shared = KeychainService()
    private let keychain = Keychain(service: "Documents")
    
    func save(password: String) {
        try? keychain.set(password, key: "password")
        
    }
    
    func loadPassword() -> String? {
        try? keychain.get("password")
    }
    
    func removePassword() {
        try? keychain.remove("password")
    }
    
}
