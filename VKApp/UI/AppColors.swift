//
//  AppColors.swift
//  VKApp
//
//  Created by Timur Zakirov on 17/09/26.
//


import UIKit

enum AppColors {

    static let background = UIColor.systemBackground

    static let secondaryBackground =
        UIColor.secondarySystemBackground

    static let tertiaryBackground =
        UIColor.tertiarySystemBackground

    static let primaryText = UIColor.label

    static let secondaryText =
        UIColor.secondaryLabel

    static let tertiaryText =
        UIColor.tertiaryLabel

    static let separator = UIColor.separator

    static let accent = UIColor.systemBlue

    static let destructive = UIColor.systemRed

    static let cardBackground =
        UIColor.secondarySystemBackground

    static let navigationBackground =
        UIColor.systemBackground

    static let placeholder =
        UIColor.placeholderText
    
    
    static let vkBlue = UIColor(
        red: 0 / 255,
        green: 119 / 255,
        blue: 255 / 255,
        alpha: 1
    )
    
    
        static let welcomeButton = UIColor(
            red: 45 / 255,
            green: 60 / 255,
            blue: 67 / 255,
            alpha: 1
        )
    
        static let registrationAccent = UIColor(
            red: 1,
            green: 165 / 255,
            blue: 0,
            alpha: 1
        )

    static let mediaPlaceholder = UIColor {
        traits in

        if traits.userInterfaceStyle == .dark {
            return UIColor(
                red: 0.14,
                green: 0.14,
                blue: 0.16,
                alpha: 1
            )
        } else {
            return UIColor(
                red: 0.92,
                green: 0.92,
                blue: 0.94,
                alpha: 1
            )
        }
    }

    static let overlay = UIColor {
        traits in

        if traits.userInterfaceStyle == .dark {
            return UIColor.black.withAlphaComponent(
                0.55
            )
        } else {
            return UIColor.black.withAlphaComponent(
                0.30
            )
        }
    }
}



//import UIKit
//
//public enum AppColors {
//
//    static let background = UIColor.systemBackground
//    static let secondaryBackground = UIColor.secondarySystemBackground
//
//    static let primaryText = UIColor.label
//    static let secondaryText = UIColor.secondaryLabel
//
//    static let vkBlue = UIColor(
//        red: 38 / 255,
//        green: 136 / 255,
//        blue: 235 / 255,
//        alpha: 1
//    )
//
//    static let welcomeButton = UIColor(
//        red: 45 / 255,
//        green: 60 / 255,
//        blue: 67 / 255,
//        alpha: 1
//    )
//
//    static let registrationAccent = UIColor(
//        red: 1,
//        green: 165 / 255,
//        blue: 0,
//        alpha: 1
//    )
//
//    static let separator = UIColor.separator
//    static let destructive = UIColor.systemRed
//    
//    static let accent = UIColor.systemBlue
//}
//
