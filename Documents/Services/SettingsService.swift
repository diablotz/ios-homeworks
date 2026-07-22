//
//  SettingsService.swift
//  Documents
//
//  Created by Timur Zakirov on 18/07/26.
//

import Foundation

final class SettingsService{
    
    static let shared = SettingsService()
    
    private let defaults = UserDefaults.standard
    
    var ascending: Bool {
        get {
            defaults.object(forKey: "ascending") as? Bool ?? true
        }
        
        set {
            defaults.set(newValue, forKey: "ascending")
        }
    }
    
}
