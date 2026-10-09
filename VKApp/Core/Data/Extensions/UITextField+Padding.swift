//
//  UITextField+Padding.swift
//  VKApp
//
//  Created by Timur Zakirov on 02/10/26.
//

import UIKit

extension UITextField {

    func setLeftPadding(_ value: CGFloat) {
        let paddingView = UIView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: value,
                height: 1
            )
        )

        leftView = paddingView
        leftViewMode = .always
    }
}
