//
//  Localization.swift
//  VKApp
//
//  Created by Timur Zakirov on 04/11/26.
//

import Foundation

nonisolated enum L10n {

    static func string(
        _ key: String,
        comment: String = ""
    ) -> String {
        NSLocalizedString(
            key,
            comment: comment
        )
    }

    static func format(
        _ key: String,
        _ arguments: CVarArg...
    ) -> String {
        let format = NSLocalizedString(
            key,
            comment: ""
        )

        return String(
            format: format,
            locale: Locale.current,
            arguments: arguments
        )
    }
}


