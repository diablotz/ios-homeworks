//
//  AppFonts.swift
//  VKApp
//
//  Created by Timur Zakirov on 17/09/26.
//

import UIKit

public enum AppFonts {
    
    static let title = UIFontMetrics(
        forTextStyle: .title2
    ).scaledFont(
        for: .systemFont(
            ofSize: 22,
            weight: .bold
        )
    )

    static let headline = UIFontMetrics(
        forTextStyle: .headline
    ).scaledFont(
        for: .systemFont(
            ofSize: 17,
            weight: .semibold
        )
    )

    static let body = UIFontMetrics(
        forTextStyle: .body
    ).scaledFont(
        for: .systemFont(
            ofSize: 16
        )
    )

    static let subheadline = UIFontMetrics(
        forTextStyle: .subheadline
    ).scaledFont(
        for: .systemFont(
            ofSize: 14
        )
    )

    static let caption = UIFontMetrics(
        forTextStyle: .caption1
    ).scaledFont(
        for: .systemFont(
            ofSize: 12
        )
    )
}



