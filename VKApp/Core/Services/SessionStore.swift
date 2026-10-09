//
//  SessionStore.swift
//  VKApp
//
//  Created by Timur Zakirov on 06/10/26.
//

import Foundation

final class SessionStore {

    static let shared = SessionStore()

    private enum Keys {
        static let currentUserID =
            "session.currentUserID"
    }

    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    var currentUserID: UUID? {
        guard
            let value = defaults.string(
                forKey: Keys.currentUserID
            )
        else {
            return nil
        }

        return UUID(uuidString: value)
    }

    var isAuthenticated: Bool {
        currentUserID != nil
    }

    func save(userID: UUID) {
        defaults.set(
            userID.uuidString,
            forKey: Keys.currentUserID
        )
    }

    func clear() {
        defaults.removeObject(
            forKey: Keys.currentUserID
        )
    }
}

