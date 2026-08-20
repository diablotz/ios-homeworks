//
//  BruteForce.swift
//  NavigationSmpl
//
//  Created by Timur Zakirov on 28/05/26.
//

import UIKit

final class BruteForce {
    // массив символов для генерации пароля
    private let symbols = Array("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
    
    // генерация пароля
    func generatePassword(length: Int) -> String {
        var password = ""
        for _ in 0..<length {
            let randomIndex = Int.random(in: 0..<symbols.count)
            password.append(symbols[randomIndex])
        }
        print ("password: \(password)")
        return password
    }
    
    
    var attempts: Int = 0 // для счетчика кол-ва операций
    
    // подборка пароля
    func bruteForce(password: String) -> String? {
        
        let targetLength = password.count
        
        func generate(current: String) -> String? {
            
            if current.count == targetLength {
                
                attempts += 1
                
                if current == password {
                    print ("found_password_key".localized + " \(current). " + "total_attempts_key".localized + " =  \(attempts)")
                    return current
                }
                return nil
            }
            
            for symbol in symbols {
                if let result = generate(current: current + String(symbol)) {
                    return result
                }
            }
            
            return nil
        }
        
        return generate(current: "")
    }
    
}
