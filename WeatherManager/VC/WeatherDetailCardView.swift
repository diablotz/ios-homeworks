//
//  WeatherDetailCardView.swift
//  WeatherManager
//
//  Created by Timur Zakirov on 05/08/26.
//

import UIKit

final class WeatherDetailCardView: UIView {

    private let titleLabel = UILabel()
    private let valueLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        
    }
    required init? (coder: NSCoder) {
        fatalError("Fatal Error!")
    }
    
    func configure(title: String, value: String) {
        titleLabel.text = title
        valueLabel.text = value
    }
    
    func setupView() {
        backgroundColor = .white.withAlphaComponent(0.2)
        layer.cornerRadius = 20
        
        titleLabel.font = .systemFont(ofSize: 15)
        titleLabel.textColor = .white.withAlphaComponent(0.8)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        valueLabel.font = .systemFont(ofSize: 25, weight: .bold)
        valueLabel.textColor = .white
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        addSubview(valueLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            valueLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            valueLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
    }
    

}
