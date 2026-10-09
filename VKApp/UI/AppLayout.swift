//
//  AppLayout.swift
//  VKApp
//
//  Created by Timur Zakirov on 17/09/26.
//

import UIKit

public enum AppLayout {

    static let smallSpacing: CGFloat = 8
    static let standardSpacing: CGFloat = 16
    static let largeSpacing: CGFloat = 24
    static let extraLargeSpacing: CGFloat = 32

    static let horizontalInset: CGFloat = 20

    static let minimumTouchSize: CGFloat = 44
    static let buttonHeight: CGFloat = 50

    static let cornerRadius: CGFloat = 12

    // Ограничение - контент не растягивается на всю ширину iPad.
    static let compactContentMaximumWidth: CGFloat = 440

    // Максимальная ширина ленты на iPad.
    static let feedMaximumWidth: CGFloat = 680
}


