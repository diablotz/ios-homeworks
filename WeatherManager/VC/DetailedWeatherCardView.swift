//
//  DetailedWeatherCardView.swift
//  WeatherManager
//
//  Created by Timur Zakirov on 10/08/26.
//


import UIKit

final class DetailedWeatherCardView: UIView {
    
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    private let tempLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .black
        return label
    }()
    
    // Внутренний список параметров таблицы
    private let paramsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        return stack
    }()
    
    // Сохраняем ссылки на строки параметров, чтобы обновлять их значения динамически
    private var feelsLikeRow = UIView()
    private var windRow = UIView()
    private var uvRow = UIView()
    private var rainRow = UIView()
    private var cloudsRow = UIView()
    
    // Ссылки на UILabel значений внутри строк
    private let feelsLikeValueLabel = UILabel()
    private let windValueLabel = UILabel()
    private let uvValueLabel = UILabel()
    private let rainValueLabel = UILabel()
    private let cloudValueLabel = UILabel()
    
   
    init(title: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        setupCard()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCard() {
        backgroundColor = UIColor(red: 235/255, green: 242/255, blue: 255/255, alpha: 1.0) // Светло-голубой фон карточки
        layer.cornerRadius = 16
        
        [titleLabel, tempLabel, descriptionLabel, paramsStackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        // Создаем строки параметров
        feelsLikeRow = createParamRow(icon: "thermometer.medium", name: "По ощущениям", valueLabel: feelsLikeValueLabel)
        windRow = createParamRow(icon: "wind", name: "Ветер", valueLabel: windValueLabel)
        uvRow = createParamRow(icon: "sun.max", name: "Уф индекс", valueLabel: uvValueLabel)
        rainRow = createParamRow(icon: "cloud.rain", name: "Осадки", valueLabel: rainValueLabel)
        cloudsRow = createParamRow(icon: "cloud.fill", name: "Облачность", valueLabel: cloudValueLabel)
        
        // Наполняем вертикальный стек
        paramsStackView.addArrangedSubview(feelsLikeRow)
        paramsStackView.addArrangedSubview(windRow)
        paramsStackView.addArrangedSubview(uvRow)
        paramsStackView.addArrangedSubview(rainRow)
        paramsStackView.addArrangedSubview(cloudsRow)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            tempLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            tempLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            descriptionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            paramsStackView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            paramsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            paramsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            paramsStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
    
    private func createParamRow(icon: String, name: String, valueLabel: UILabel) -> UIView {
        let row = UIView()
        
        let iconView = UIImageView(image: UIImage(systemName: icon))
        iconView.tintColor = .systemBlue
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        
        let nameLabel = UILabel()
        nameLabel.text = name
        nameLabel.font = .systemFont(ofSize: 14)
        nameLabel.textColor = .systemGray
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        valueLabel.font = .systemFont(ofSize: 14, weight: .medium)
        valueLabel.textColor = .black
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        row.addSubview(iconView)
        row.addSubview(nameLabel)
        row.addSubview(valueLabel)
        
        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: row.leadingAnchor),
            iconView.centerYAnchor.constraint(equalTo: row.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 20),
            iconView.heightAnchor.constraint(equalToConstant: 20),
            
            nameLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 8),
            nameLabel.centerYAnchor.constraint(equalTo: row.centerYAnchor),
            
            valueLabel.trailingAnchor.constraint(equalTo: row.trailingAnchor),
            valueLabel.centerYAnchor.constraint(equalTo: row.centerYAnchor),
            row.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        return row
    }
    
    // Метод для динамического обновления данных в карточке
    func configure(temp: String, desc: String, humidity: String, uvIndex: Double, windSpeed: Double, rainProb: Double, clouds: Double) {
        tempLabel.text = temp
        descriptionLabel.text = desc
        
        // Подставляем значения в нижнюю таблицу параметров
        feelsLikeValueLabel.text = temp // Для простоты ставим ту же температуру
        let windIndex = UserDefaults.standard.integer(forKey: "wind_unit_index")
        let windSign = windIndex == 0 ? "ми/ч" : "м/с"
        windValueLabel.text = String(format: "💨 %.0f %@", windSpeed, windSign)
        //windValueLabel.text = "5 м/с"
        //uvValueLabel.text = "4 (умерен.)"
        let uvText: String
            switch uvIndex {
            case 0..<3:
                uvText = String(format: "%.0f (низкий)", uvIndex)
            case 3..<6:
                uvText = String(format: "%.0f (умерен.)", uvIndex)
            case 6..<8:
                uvText = String(format: "%.0f (высокий)", uvIndex)
            case 8..<11:
                uvText = String(format: "%.0f (очень выс.)", uvIndex)
            default:
                uvText = String(format: "%.0f (экстрем.)", uvIndex)
            }
            
        uvValueLabel.text = uvText
        
        rainValueLabel.text = "\(Int(rainProb * 100))%"
        cloudValueLabel.text = "\(Int(clouds))%"
    }
}


