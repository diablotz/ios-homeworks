//
//  ForecastDayViewCell.swift
//  WeatherManager
//
//  Created by Timur Zakirov on 07/08/26.
//

import UIKit

final class ForecastDayCell: UITableViewCell {

    static let reuseID = "ForecastDayCell"

    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5) // Полупрозрачный фон
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let leftVerticalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 2
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .white // Серый цвет даты
        return label
    }()
    
    private let weatherStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 6
        stack.alignment = .center
        return stack
    }()
    
    private let weatherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .systemBlue // Синий цвет иконки
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let humidityLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 1
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    private let chevronImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        imageView.tintColor = .systemGray3
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

  
    func configure(with forecast: ForecastDay) { // Изменили тип на ForecastDay
        
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "dd/04" // Формат даты как на макете
        
        // 1. Привязываем дату
        dateLabel.text = formatter.string(from: forecast.date)
        
        // 2. Привязываем температуру
//        let isMetric = UserDefaults.standard.integer(forKey: "temp_unit_index") == 0
//        let unitSign = isMetric ? "°" : "°"
//        let minTemp = Int(forecast.minTemp)
//        let maxTemp = Int(forecast.maxTemp)
//        temperatureLabel.text = "\(minTemp)-\(maxTemp)\(unitSign)°"//text = "\(Int(forecast.temperature))°"
        temperatureLabel.text = "\(Int(forecast.temperature))°"
        // 3. Привязываем описание погоды
        descriptionLabel.text = forecast.description.capitalized
        
        // 4. Привязываем влажность
        humidityLabel.text = "\(forecast.humidity)%"
        
        // 5. Устанавливаем системную иконку погоды
        weatherImageView.image = UIImage(systemName: iconName(from: forecast.icon))
    }


    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        
        containerView.addSubview(leftVerticalStack)
        leftVerticalStack.addArrangedSubview(dateLabel)
        leftVerticalStack.addArrangedSubview(weatherStack)
        
        weatherStack.addArrangedSubview(weatherImageView)
        weatherStack.addArrangedSubview(humidityLabel)
        
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(temperatureLabel)
        containerView.addSubview(chevronImageView)
        
        descriptionLabel.lineBreakMode = .byTruncatingTail // Поставит "..." в конце, если текст упрется в температуру
        descriptionLabel.numberOfLines = 1
        temperatureLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        temperatureLabel.textAlignment = .right
        
        
        [descriptionLabel, temperatureLabel, chevronImageView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            // Отступы для фоновой плашки карточки
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Левый блок (Дата + Иконка + Проценты)
            leftVerticalStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            leftVerticalStack.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            leftVerticalStack.widthAnchor.constraint(equalToConstant: 70),
            
            weatherImageView.widthAnchor.constraint(equalToConstant: 22),
            weatherImageView.heightAnchor.constraint(equalToConstant: 22),
            
            
            
            // Стрелочка шеврона справа
            chevronImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            chevronImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            chevronImageView.widthAnchor.constraint(equalToConstant: 12),
            chevronImageView.heightAnchor.constraint(equalToConstant: 12),
            
            // Диапазон температур перед стрелочкой
            temperatureLabel.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor, constant: -12),
            // 2. Задаем ЖЕСТКУЮ постоянную ширину (60 поинтов хватит для текста вида "30° - 40°")
            temperatureLabel.widthAnchor.constraint(equalToConstant: 65),
            temperatureLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            // Текстовое описание по центру
            descriptionLabel.leadingAnchor.constraint(equalTo: leftVerticalStack.trailingAnchor, constant: 12),
            descriptionLabel.trailingAnchor.constraint(equalTo: temperatureLabel.leadingAnchor, constant: -30),
            //descriptionLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 200),
            descriptionLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
        ])
    }

    private func iconName(from icon: String) -> String {
        switch icon {
        case "01d": return "sun.max.fill"
        case "01n": return "moon.stars.fill"
        case "02d", "02n": return "cloud.sun.fill"
        case "03d", "03n", "04d", "04n": return "cloud.fill"
        case "09d", "09n": return "cloud.drizzle.fill"
        case "10d", "10n": return "cloud.heavyrain.fill"
        case "11d", "11n": return "cloud.bolt.fill"
        case "13d", "13n": return "snow"
        case "50d", "50n": return "cloud.fog.fill"
        default: return "cloud.rain.fill"
        }
    }
}


