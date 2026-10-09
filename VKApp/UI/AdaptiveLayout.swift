//
//  AdaptiveLayout.swift
//  VKApp
//
//  Created by Timur Zakirov on 08/10/26.
//

import UIKit

enum AdaptiveLayout {

    static let phoneHorizontalInset: CGFloat = 12
    static let padHorizontalInset: CGFloat = 24

    static let feedMaximumWidth: CGFloat = 720
    static let formMaximumWidth: CGFloat = 600
    static let messengerMaximumWidth: CGFloat = 900
    static let reelsMaximumWidth: CGFloat = 600

    static func horizontalInset(
        for traitCollection: UITraitCollection
    ) -> CGFloat {
        if traitCollection.userInterfaceIdiom == .pad {
            return padHorizontalInset
        }

        return phoneHorizontalInset
    }

    static func numberOfGridColumns(
        availableWidth: CGFloat,
        minimumItemWidth: CGFloat = 120
    ) -> Int {
        let calculatedColumns = Int(
            availableWidth / minimumItemWidth
        )

        return max(2, calculatedColumns)
    }
}

