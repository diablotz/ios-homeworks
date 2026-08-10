//
//  DailyDetailsViewController.swift
//  WeatherManager
//
//  Created by Timur Zakirov on 10/08/26.
//

import UIKit

final class DailyDetailsViewController: UIViewController {
    
    // МАССИВ ДАННЫХ: Принимаем весь список дней и текущий выбранный индекс
    private let forecastList: [ForecastDay]
    private var selectedIndex: Int
    
  
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        scroll.backgroundColor = .white
        return scroll
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Дневная погода"
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .systemGray
        return label
    }()
    
    private let cityLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    // ГОРИЗОНТАЛЬНАЯ ЛЕНТА ДНЕЙ
    private lazy var daysCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize // Авто-подбор ширины под текст
        layout.minimumInteritemSpacing = 8
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .clear
        collection.showsHorizontalScrollIndicator = false
        collection.dataSource = self
        collection.delegate = self
        collection.register(DateCell.self, forCellWithReuseIdentifier: DateCell.reuseID)
        return collection
    }()
    
    private let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        return stack
    }()
    
    private let dayCard = DetailedWeatherCardView(title: "День")
    private let nightCard = DetailedWeatherCardView(title: "Ночь")
   
    private let sunMoonCard = SunMoonCardView()
    
    private let airQualityCard = AirQualityCardView()
    
    
    init(forecastList: [ForecastDay], startIndex: Int, cityName: String) {
        self.forecastList = forecastList
        self.selectedIndex = startIndex
        super.init(nibName: nil, bundle: nil)
        self.cityLabel.text = cityName
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        updateUIData()
        
        // Автоматически скроллим ленту к выбранному дню при открытии экрана
        DispatchQueue.main.async {
            let indexPath = IndexPath(item: self.selectedIndex, section: 0)
            self.daysCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        }
    }
    
    
    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [backButton, titleLabel, cityLabel, daysCollectionView, mainStackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        daysCollectionView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        mainStackView.addArrangedSubview(dayCard)
        mainStackView.addArrangedSubview(nightCard)
        mainStackView.addArrangedSubview(sunMoonCard)
        mainStackView.addArrangedSubview(airQualityCard)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            backButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            backButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 12),
            
            cityLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 16),
            cityLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            // ЛЕНТА ДНЕЙ под городом
            daysCollectionView.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 12),
            daysCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            daysCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            daysCollectionView.heightAnchor.constraint(equalToConstant: 36),
            
            // основное поле под лентой дней
            mainStackView.topAnchor.constraint(equalTo: daysCollectionView.bottomAnchor, constant: 20),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
   
    private func updateUIData() {
        guard selectedIndex < forecastList.count else { return }
        let currentDayData = forecastList[selectedIndex]
        
        let tempText = "\(Int(currentDayData.temperature))°"
        let descText = currentDayData.description.capitalized
        let humidityText = "\(currentDayData.humidity)%"
        let windSpeed = currentDayData.windSpeed
        let uvIndex = currentDayData.uvIndex
        let realRain = currentDayData.rainProbability
        let realClouds = currentDayData.cloudiness
        
        UIView.transition(with: dayCard, duration: 0.2, options: .transitionCrossDissolve) {
            self.dayCard.configure(
                temp: tempText,
                desc: descText,
                humidity: humidityText,
                uvIndex: uvIndex,
                windSpeed: windSpeed,
                rainProb: realRain,
                clouds: realClouds
            )
        }
        
        UIView.transition(with: nightCard, duration: 0.2, options: .transitionCrossDissolve) {
            let nightTemp = "\(Int(currentDayData.temperature - 5))°"
            self.nightCard.configure(
                temp: nightTemp,
                desc: descText,
                humidity: humidityText,
                uvIndex: 0.0,
                windSpeed: windSpeed,
                rainProb: realRain,
                clouds: realClouds
            )
        }
        
        
        
        
        
        // Расчет данных для солнца и луны (условные данные)
        let calendar = Calendar.current
        let dayComponents = calendar.dateComponents([.day, .month, .year], from: currentDayData.date)
        let dayNumber = dayComponents.day ?? 16
        
        // Имитируем небольшое астрономическое смещение времени в зависимости от дня месяца
        let startHour = 5
        let startMinute = (41 + dayNumber) % 60
        let endHour = 19
        let endMinute = (31 - (dayNumber / 2)) % 60
        
        let sunriseStr = String(format: "%02d:%02d", startHour, startMinute)
        let sunsetStr = String(format: "%02d:%02d", endHour, endMinute)
        
        // Считаем долготу дня
        let totalMinutes = (endHour * 60 + endMinute) - (startHour * 60 + startMinute)
        let sunDurationStr = "\(totalMinutes / 60)ч \(totalMinutes % 60)мин"
        
        // Имитируем движение луны (сдвиг на ~50 минут каждый день)
        let moonriseHour = (18 + (dayNumber / 2)) % 24
        let moonsetHour = (4 + (dayNumber / 2)) % 24
        let moonriseStr = String(format: "%02d:%02d", moonriseHour, startMinute)
        let moonsetStr = String(format: "%02d:%02d", moonsetHour, endMinute)
        let moonDurationStr = "9ч 15мин"
        
        // Вычисляем фазу луны на основе дня месяца (цикл 30 дней)
        let phaseProgress = Double(dayNumber % 30) / 30.0
        let phaseStr: String
        switch phaseProgress {
        case 0.0..<0.15, 0.95...1.0: phaseStr = "Новолуние"
        case 0.15..<0.45: phaseStr = "Растущая Луна"
        case 0.45..<0.55: phaseStr = "Полнолуние"
        default: phaseStr = "Убывающая Луна"
        }
        
        
        UIView.transition(with: sunMoonCard, duration: 0.2, options: .transitionCrossDissolve) {
            self.sunMoonCard.configure(
                sunrise: sunriseStr,
                sunset: sunsetStr,
                sunDuration: sunDurationStr,
                moonrise: moonriseStr,
                moonset: moonsetStr,
                moonDuration: moonDurationStr,
                phase: phaseStr
            )
        }
        
        // Рассчитываем уникальный индекс (1, 2 или 4) на основе выбранной даты,
        // чтобы имитировать смену эко-обстановки при переключении ленты дней
        let dayComponent = Calendar.current.component(.day, from: currentDayData.date)
        let simulatedAQI: Int
        
        if dayComponent % 3 == 0 {
            simulatedAQI = 4 // Красный (Опасный)
        } else if dayComponent % 2 == 0 {
            simulatedAQI = 2 // Оранжевый (Умеренный)
        } else {
            simulatedAQI = 1 // Зеленый (Чистый воздух)
        }
        
        // Передаем индекс в UI-компонент с плавной анимацией растворения текста
        UIView.transition(with: airQualityCard, duration: 0.2, options: .transitionCrossDissolve) {
            self.airQualityCard.configure(with: simulatedAQI)
        }
        
//        // НАСТРОЙКА РЕАЛЬНОГО ВРЕМЕНИ СОЛНЦА И ЛУНЫ
//        let timeFormatter = DateFormatter()
//        timeFormatter.dateFormat = "HH:mm"
//        timeFormatter.locale = Locale(identifier: "ru_RU")
//        
//        // Устанавливаем часовой пояс выбранного города разработчика
//        if let cityTimeZone = TimeZone(secondsFromGMT: currentDayData.timezoneOffset) {
//            timeFormatter.timeZone = cityTimeZone
//        }
//        
//        // Переводим штампы в объекты Date
//        let sunRiseDate = Date(timeIntervalSince1970: currentDayData.sunrise)
//        let sunSetDate = Date(timeIntervalSince1970: currentDayData.sunset)
//        let moonRiseDate = Date(timeIntervalSince1970: currentDayData.moonrise)
//        let moonSetDate = Date(timeIntervalSince1970: currentDayData.moonset)
//        
//        // Форматируем в текстовое время (например, "05:41")
//        let sunriseStr = currentDayData.sunrise > 0 ? timeFormatter.string(from: sunRiseDate) : "--:--"
//        let sunsetStr = currentDayData.sunset > 0 ? timeFormatter.string(from: sunSetDate) : "--:--"
//        let moonriseStr = currentDayData.moonrise > 0 ? timeFormatter.string(from: moonRiseDate) : "--:--"
//        let moonsetStr = currentDayData.moonset > 0 ? timeFormatter.string(from: moonSetDate) : "--:--"
//        
//        // Рассчитываем долготу дня через наш хелпер
//        let sunDuration = calculateDuration(start: currentDayData.sunrise, end: currentDayData.sunset)
//        let moonDuration = calculateDuration(start: currentDayData.moonrise, end: currentDayData.moonset)
//        
//        // Извлекаем текстовую фазу луны
//        let phaseStr = getMoonPhaseText(from: currentDayData.moonPhase)
//        
//        // Плавно обновляем карточку Солнце и Луна
//        UIView.transition(with: sunMoonCard, duration: 0.2, options: .transitionCrossDissolve) {
//            self.sunMoonCard.configure(
//                sunrise: sunriseStr,
//                sunset: sunsetStr,
//                sunDuration: sunDuration,
//                moonrise: moonriseStr,
//                moonset: moonsetStr,
//                moonDuration: moonDuration,
//                phase: phaseStr
//            )
//        }
    }
    
    func getMoonPhaseText(from phase: Double) -> String {
        switch phase {
        case 0, 1: return "Новолуние"
        //case 0.01..<0.25: return "Растущий серп"
        //case 0.25: return "Первая четверть"
        case 0.01..<0.5: return "Растущая Луна"
        case 0.5: return "Полнолуние"
//        case 0.51..<0.75: return "Убывающая Луна"
//        case 0.75: return "Последняя четверть"
        default: return "Убывающая Луна"
        }
    }
    
    func calculateDuration(start: TimeInterval, end: TimeInterval) -> String {
        guard start > 0 && end > 0 else { return "-- ч. -- мин." }
        let difference = abs(end - start)
        
        let hours = Int(difference) / 3600
        let minutes = (Int(difference) % 3600) / 60
        
        return "\(hours)ч \(minutes)мин"
    }
    
}


extension DailyDetailsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return forecastList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DateCell.reuseID, for: indexPath) as? DateCell else {
            return UICollectionViewCell()
        }
        
        let dayData = forecastList[indexPath.item]
        let isSelected = indexPath.item == selectedIndex
        cell.configure(with: dayData.date, isSelected: isSelected)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.item
        collectionView.reloadData()
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        updateUIData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 90, height: 36)
    }
}

