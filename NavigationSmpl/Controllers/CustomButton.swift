//
//  CustomButton.swift
//  NavigationSmpl
//
//  Created by Timur Zakirov on 11/05/26.
//

import UIKit

class CustomButton: UIButton {
    
    var action: (() -> Void)?
    
    init(title: String, titleColor: UIColor, action: ( () -> Void)? = nil, backgroundColor: UIColor, cornerRadius: CGFloat)
    {
        
        
        self.action = action
        super.init(frame: .zero)
    
        setupButton(title: title, titleColor: titleColor, backgroundColor: backgroundColor, cornerRadius: cornerRadius)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupButton(title: String, titleColor: UIColor, backgroundColor: UIColor, cornerRadius: CGFloat) {
        
        translatesAutoresizingMaskIntoConstraints = false
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        self.backgroundColor = backgroundColor
        layer.cornerRadius = cornerRadius
        addTarget(
            self,
            action: #selector(buttonTapped),
            for: .touchUpInside
        )
    }
    
    @objc private func buttonTapped() {
        print("Кнопка нажата")
        action?()
    }
}
