//
//  WeatherHeaderView.swift
//  WeatherManager
//
//  Created by Timur Zakirov on 04/08/26.
//

import UIKit

final class WeatherHeaderView: UIView {
    
    let settingsButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "gear"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    let cityLabel: UIButton = {
        let button = UIButton()
        button.setTitle("Tashkent", for: .normal)
        button.setTitleColor(UIColor.black.withAlphaComponent(0.8), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        
        return button
    }()
    
    let addButton: UIButton = {
        let button = UIButton()
        button.tintColor = .black
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //backgroundColor = .systemBlue
        setupViews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    func setupViews() {
        [
            settingsButton,
            cityLabel,
            addButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            settingsButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            settingsButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            settingsButton.widthAnchor.constraint(equalToConstant: 40),
            settingsButton.heightAnchor.constraint(equalTo: settingsButton.widthAnchor),
            
            cityLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            cityLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            addButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            addButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            addButton.widthAnchor.constraint(equalToConstant: 40),
            addButton.heightAnchor.constraint(equalTo: addButton.widthAnchor)
            
        ])
        
        
    }
    
}

