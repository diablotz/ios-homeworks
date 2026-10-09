//
//  UserEntity+Display.swift
//  VKApp
//
//  Created by Timur Zakirov on 22/09/26.
//

import Foundation

extension UserEntity {

    var displayName: String {
        [firstName, lastName]
            .compactMap { $0 }
            .map {
                $0.trimmingCharacters(in: .whitespacesAndNewlines)
            }
            .filter { !$0.isEmpty }
            .joined(separator: " ")
    }
}

