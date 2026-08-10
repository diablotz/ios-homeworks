//
//  WeatherInfoView.swift
//  WeatherManager
//
//  Created by Timur Zakirov on 05/08/26.
//


import UIKit

final class WeatherInfoView: UIView {

    
    private let arcLayer = CAShapeLayer()
    
    private let minMaxLabel: UILabel = {
        let label = UILabel()
        label.text = "30° / 40°"
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textColor = .white.withAlphaComponent(0.9)
        label.textAlignment = .center
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "40°"
        label.font = .systemFont(ofSize: 26, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Ясно"
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let rainLabel = UILabel()
    
    private let windLabel = UILabel()
    private let humidityLabel = UILabel()
    
    private let weatherStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .center
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "17:48, сб 8 августа"
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = UIColor.systemYellow
        label.textAlignment = .center
        return label
    }()
    
    // рассвет
    private let sunriseIcon: UILabel = {
        let label = UILabel()
        label.text = "☀️↑"
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    private let sunriseTimeLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    // закат
    private let sunsetIcon: UILabel = {
        let label = UILabel()
        label.text = "☀️↓"
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    private let sunsetTimeLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        return label
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //backgroundColor = .systemBlue
        setupViews()
        setupConstraints()
        setupArcLayer()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Перерисовываем дугу при изменении размеров экрана
        updateArcPath()
    }
    
    
    private func setupViews() {
        [minMaxLabel, temperatureLabel, descriptionLabel, dateLabel,
         sunriseIcon, sunriseTimeLabel, sunsetIcon, sunsetTimeLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        addSubview(weatherStackView)
        
        // Настраиваем шрифты и белый цвет для всех параметров
        [rainLabel, windLabel, humidityLabel].forEach {
            $0.font = .systemFont(ofSize: 18, weight: .semibold)
            $0.textColor = .white
            weatherStackView.addArrangedSubview($0)
        }
    }

    private func setupArcLayer() {
        arcLayer.strokeColor = UIColor.systemYellow.cgColor
        arcLayer.fillColor = UIColor.clear.cgColor
        arcLayer.lineWidth = 4
        arcLayer.lineCap = .round
        layer.addSublayer(arcLayer)
    }
    
    private func updateArcPath() {
        let center = CGPoint(x: bounds.midX, y: bounds.maxY - 80)
        let radius = bounds.width * 0.42
        
        
        let path = UIBezierPath(
            arcCenter: .zero,
            radius: radius,
            startAngle: .pi,
            endAngle: 0,
            clockwise: true
        )
        var transform = CGAffineTransform(translationX: center.x, y: center.y)
            transform = transform.scaledBy(x: 1.0, y: 0.8)
            
        
        path.apply(transform)
        arcLayer.path = path.cgPath
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            minMaxLabel.topAnchor.constraint(equalTo: topAnchor, constant: 40),
            minMaxLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            temperatureLabel.topAnchor.constraint(equalTo: minMaxLabel.bottomAnchor, constant: 2),
            temperatureLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 16),
            descriptionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            weatherStackView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            weatherStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            rainLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 100),
            
            dateLabel.topAnchor.constraint(equalTo: weatherStackView.bottomAnchor, constant: 16),
            dateLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            
            // Рассвет
            sunriseIcon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            sunriseIcon.bottomAnchor.constraint(equalTo: sunriseTimeLabel.topAnchor, constant: -4),
            sunriseTimeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            sunriseTimeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -40),
            
            // Закат
            sunsetIcon.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            sunsetIcon.bottomAnchor.constraint(equalTo: sunsetTimeLabel.topAnchor, constant: -4),
            sunsetTimeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            sunsetTimeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -40)
        ])
    }
    
    
    func configure(with weather: CurrentWeatherResponse) {
        let isMetric = UserDefaults.standard.integer(forKey: "temp_unit_index") == 0
        let unitSign = isMetric ? "°" : "°"
        
        let minTemp = Int(weather.main.temp_min)
        let maxTemp = Int(weather.main.temp_max)
        
        minMaxLabel.text = "\(minTemp)-\(maxTemp)\(unitSign)"
        
        temperatureLabel.text = "\(Int(weather.main.temp))\(unitSign)"
        descriptionLabel.text = weather.weather.first?.description.capitalized
        
        // Создаем общий форматер времени
        let timeFormatter = DateFormatter()
        timeFormatter.locale = Locale(identifier: "ru_RU")
        timeFormatter.dateFormat = "HH:mm"
        
        // Устанавливаем часовой пояс выбранного города для рассвета и заката
        if let cityTimeZone = TimeZone(secondsFromGMT: weather.timezone) {
            timeFormatter.timeZone = cityTimeZone
        }
        
        // Конвертируем Unix-время в объекты Date
        let sunriseDate = Date(timeIntervalSince1970: weather.sys.sunrise)
        let sunsetDate = Date(timeIntervalSince1970: weather.sys.sunset)
        
        // Подставляем реальное местное время в UILabel
        sunriseTimeLabel.text = timeFormatter.string(from: sunriseDate)
        sunsetTimeLabel.text = timeFormatter.string(from: sunsetDate)
        
        // форматируем текущую дату по местному времени города
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "HH:mm, ee d MMMM"
        if let cityTimeZone = TimeZone(secondsFromGMT: weather.timezone) {
            dateFormatter.timeZone = cityTimeZone
        }
        dateLabel.text = dateFormatter.string(from: Date())
        
        //  Осадки
        //rainLabel.text = "☁️ 0"
        if let weatherInfo = weather.weather.first {
            let conditionEmoji = getWeatherEmoji(id: weatherInfo.id)
            let conditionText = weatherInfo.description.capitalized
            
            // показываем в формате: "☀️ Ясно" или "🌧️ Небольшой Дождь"
            rainLabel.text = "\(conditionEmoji) \(conditionText)"
            rainLabel.lineBreakMode = .byTruncatingTail
            rainLabel.numberOfLines = 1
            
        } else {
            rainLabel.text = "☁️ --"
        }
        
        // ветер с динамическими единицами
        let windIndex = UserDefaults.standard.integer(forKey: "wind_unit_index")
        let windSign = windIndex == 0 ? "ми/ч" : "м/с"
        windLabel.text = String(format: "💨 %.0f %@", weather.wind.speed, windSign)
        
        // влажность
        humidityLabel.text = "💧 \(weather.main.humidity)%"
    }
    
    
    // функция, показывающая иконку погоды в зависимости от id
    private func getWeatherEmoji(id: Int) -> String {
        switch id {
        case 200...232: return "⛈️" // Гроза
        case 300...321: return "🌧️" // Морось
        case 500...531: return "🌧️" // Дождь
        case 600...622: return "❄️" // Снег
        case 701...781: return "🌫️" // Туман
        case 800: return "☀️"       // Ясно
        case 801...804: return "☁️"  // Облачно
        default: return "✨"
        }
    }



}

