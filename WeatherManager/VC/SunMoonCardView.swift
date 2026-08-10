//
//  SunMoonCardView.swift
//  WeatherManager
//
//  Created by Timur Zakirov on 10/08/26.
//

import UIKit

final class SunMoonCardView: UIView {
    
   
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Солнце и Луна"
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    private let moonPhaseLabel: UILabel = {
        let label = UILabel()
        label.text = "Полнолуние"
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .systemBlue
        label.textAlignment = .right
        return label
    }()
    
    // Элементы Солнца (Левая колонка)
    private let sunIconLabel = UILabel()
    private let sunDurationLabel = UILabel()
    private let sunriseTimeLabel = UILabel()
    private let sunsetTimeLabel = UILabel()
    
    // Элементы Луны (Правая колонка)
    private let moonIconLabel = UILabel()
    private let moonDurationLabel = UILabel()
    private let moonriseTimeLabel = UILabel()
    private let moonsetTimeLabel = UILabel()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCard()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout Setup
    private func setupCard() {
        backgroundColor = UIColor(red: 245/255, green: 248/255, blue: 255/255, alpha: 1.0) // Светлый фон как на макете
        layer.cornerRadius = 16
        
        // Линии-разделители
        let centerVerticalLine = createDividerLine(axis: .vertical)
        let leftHorizontalLine = createDividerLine(axis: .horizontal)
        let rightHorizontalLine = createDividerLine(axis: .horizontal)
        
        [titleLabel, moonPhaseLabel, centerVerticalLine, leftHorizontalLine, rightHorizontalLine].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        // Сборка левой колонки (Солнце)
        let sunTopStack = UIStackView(arrangedSubviews: [sunIconLabel, sunDurationLabel])
        sunTopStack.axis = .horizontal
        sunTopStack.spacing = 8
        
        let sunriseRow = createTimeRow(title: "Восход", valueLabel: sunriseTimeLabel)
        let sunsetRow = createTimeRow(title: "Заход", valueLabel: sunsetTimeLabel)
        
        let sunLeftStack = UIStackView(arrangedSubviews: [sunTopStack, leftHorizontalLine, sunriseRow, sunsetRow])
        sunLeftStack.axis = .vertical
        sunLeftStack.spacing = 10
        sunLeftStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(sunLeftStack)
        
        // Сборка правой колонки (Луна)
        let moonTopStack = UIStackView(arrangedSubviews: [moonIconLabel, moonDurationLabel])
        moonTopStack.axis = .horizontal
        moonTopStack.spacing = 8
        
        let moonriseRow = createTimeRow(title: "Восход", valueLabel: moonriseTimeLabel)
        let moonsetRow = createTimeRow(title: "Заход", valueLabel: moonsetTimeLabel)
        
        let moonRightStack = UIStackView(arrangedSubviews: [moonTopStack, rightHorizontalLine, moonriseRow, moonsetRow])
        moonRightStack.axis = .vertical
        moonRightStack.spacing = 10
        moonRightStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(moonRightStack)
        
        
        setupDefaultStyles()
        
        // Констреинты
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            moonPhaseLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            moonPhaseLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            // Центральный вертикальный разделитель
            centerVerticalLine.centerXAnchor.constraint(equalTo: centerXAnchor),
            centerVerticalLine.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            centerVerticalLine.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            centerVerticalLine.widthAnchor.constraint(equalToConstant: 1),
            
            // Левый блок (Солнце)
            sunLeftStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            sunLeftStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            sunLeftStack.trailingAnchor.constraint(equalTo: centerVerticalLine.leadingAnchor, constant: -16),
            sunLeftStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            
            // Правый блок (Луна)
            moonRightStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            moonRightStack.leadingAnchor.constraint(equalTo: centerVerticalLine.trailingAnchor, constant: 16),
            moonRightStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            moonRightStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            
            // Высота горизонтальных линий внутри стеков
            leftHorizontalLine.heightAnchor.constraint(equalToConstant: 1),
            rightHorizontalLine.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
   
    private func setupDefaultStyles() {
        sunIconLabel.text = "☀️"
        moonIconLabel.text = "🌙"
        
        [sunDurationLabel, moonDurationLabel].forEach {
            $0.font = .systemFont(ofSize: 14, weight: .semibold)
            $0.textColor = .black
        }
        
        [sunriseTimeLabel, sunsetTimeLabel, moonriseTimeLabel, moonsetTimeLabel].forEach {
            $0.font = .systemFont(ofSize: 14, weight: .medium)
            $0.textColor = .black
            $0.textAlignment = .right
        }
    }
    
    private func createTimeRow(title: String, valueLabel: UILabel) -> UIStackView {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 14)
        titleLabel.textColor = .systemGray
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        return stack
    }
    
    private func createDividerLine(axis: NSLayoutConstraint.Axis) -> UIView {
        let view = UIView()
        view.backgroundColor = .systemGray5
        return view
    }
    
    
    func configure(sunrise: String, sunset: String, sunDuration: String, moonrise: String, moonset: String, moonDuration: String, phase: String) {
        sunriseTimeLabel.text = sunrise
        sunsetTimeLabel.text = sunset
        sunDurationLabel.text = sunDuration
        
        moonriseTimeLabel.text = moonrise
        moonsetTimeLabel.text = moonset
        moonDurationLabel.text = moonDuration
        
        moonPhaseLabel.text = "\(phase)"
        
        print("восход \(sunrise), закат \(sunset), световой день \(sunDuration), восход луны \(moonrise), закат луны \(moonset), \(moonDuration), фаза луны \(phase)")
    }
}
