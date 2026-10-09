//
//  NotificationEntity+Kind.swift
//  VKApp
//
//  Created by Timur Zakirov on 22/09/26.
//

import Foundation

extension NotificationEntity {

    var notificationKind: NotificationKind {
        get {
            guard let kind else {
                return .system
            }

            return NotificationKind(rawValue: kind) ?? .system
        }

        set {
            kind = newValue.rawValue
        }
    }
}

