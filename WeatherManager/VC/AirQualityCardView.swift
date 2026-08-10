//
//  AirQualityCardView.swift
//  WeatherManager
//
//  Created by Timur Zakirov on 10/08/26.
//

import UIKit

final class AirQualityCardView: UIView {
    
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Качество воздуха"
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    // Закругленная цветная плашка-индикатор
    private let statusButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        return button
    }()
    
    
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .systemGray
        label.numberOfLines = 0
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCard()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupCard() {
        backgroundColor = UIColor(red: 245/255, green: 248/255, blue: 255/255, alpha: 1.0) // Светлый фон карточки
        layer.cornerRadius = 16
        
        [titleLabel, statusButton, descriptionLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            // Позиционируем плашку-индикатор справа от заголовка
            statusButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            statusButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            statusButton.heightAnchor.constraint(equalToConstant: 28),
            statusButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 80),
            
            // Текстовое описание под заголовком
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
    
    
    func configure(with aqi: Int) {
        let buttonTitle: String
        switch aqi {
        case 1:
            statusButton.backgroundColor = .green // Зеленый
            buttonTitle = "Чистый"
            descriptionLabel.text = "Качество воздуха считается удовлетворительным, а загрязнение воздуха представляет незначительный риск или вообще отсутствует."
            
        case 2, 3:
            statusButton.backgroundColor = .orange // Оранжевый / Умеренный
            buttonTitle = "Умеренный"
            descriptionLabel.text = "Качество воздуха приемлемо, однако для некоторых загрязняющих веществ может существовать умеренная забота о здоровье лиц, чувствительных к загрязнению."
            
        default: // Степень 4 и 5 (Опасный уровень загрязнения)
            statusButton.backgroundColor = .red // Красный
            buttonTitle = "Опасный"
            descriptionLabel.text = "Воздух сильно загрязнен. Рекомендуется ограничить длительное пребывание на улице людям с респираторными заболеваниями, детям и пожилым людям."
        }
        statusButton.setTitle(buttonTitle, for: .normal)
    }
}
