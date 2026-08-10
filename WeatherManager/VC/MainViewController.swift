//
//  MainViewController.swift
//  WeatherManager
//
//  Created by Timur Zakirov on 04/08/26.
//


                    
import UIKit
import MapKit
import CoreLocation
import _LocationEssentials

final class MainViewController: UIViewController {
    
    
    private let headerView = WeatherHeaderView()
    private let weatherInfoView = WeatherInfoView()
    //private let detailsView = WeatherDetailsView()
    private var isExtendedForecast = false
    private var daylyForecast: [ForecastDay] = []
    private var hourlyForecast: [HourlyForecast] = []
    
    
    private let pageControl: UIPageControl = {
        let control = UIPageControl()
        control.currentPageIndicatorTintColor = .white
        control.pageIndicatorTintColor = UIColor.white.withAlphaComponent(0.4)
        control.hidesForSinglePage = true
        return control
    }()
    
    private let hourlyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Подробнее на 24 часа", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.white.withAlphaComponent(0.18)
        button.layer.cornerRadius = 18
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        return button
    }()
    
    private let daysButton: UIButton = {
        let button = UIButton()
        button.setTitle("25 дней", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        return button
    
        
    }()
    
    private let tableView = UITableView(frame: .zero, style: .plain)
    
    
    //private var cities: [City] = []
    private var savedCities: [City] = []
    private var currentCityIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        setupGestures()
        
        //self.savedCities = CoreDataManager.shared.fetchWeather()
        let savedWeather = CoreDataManager.shared.fetchWeather()

        self.savedCities = savedWeather.compactMap { item in
            guard let name = item.cityName else { return nil }
            return City(
                name: name,
                latitude: item.latitude,
                longitude: item.longitude
            )
        }
        
        pageControl.numberOfPages = savedCities.count
        
        if savedCities.isEmpty {
            
            loadCity("Tashkent")
        } else {
            
            currentCityIndex = 0
            showCurrentCity()
        }
        
        hourlyButton.addTarget(
            self,
            action: #selector(openHourlyForecast),
            for: .touchUpInside)
    }
    
    func setupUI() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.backgroundColor = UIColor(named: "background") ?? .systemBlue
        
        [
            headerView, pageControl, weatherInfoView,
            //detailsView,
            hourlyButton, daysButton, tableView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            headerView.heightAnchor.constraint(equalToConstant: 30),
            
            pageControl.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 10),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            weatherInfoView.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 0),
            weatherInfoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            weatherInfoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
           // weatherInfoView.heightAnchor.constraint(equalToConstant: 100),
            
//            detailsView.topAnchor.constraint(equalTo: weatherInfoView.bottomAnchor, constant: 0),
//            detailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            detailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            //detailsView.heightAnchor.constraint(equalToConstant: 200),
            
            hourlyButton.topAnchor.constraint(equalTo: weatherInfoView.bottomAnchor, constant: 24),
            hourlyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            hourlyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            hourlyButton.heightAnchor.constraint(equalToConstant: 50),
            
            daysButton.topAnchor.constraint(equalTo: hourlyButton.bottomAnchor, constant: 10),
            daysButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            tableView.topAnchor.constraint(equalTo: daysButton.bottomAnchor, constant: 5),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        headerView.addButton.addTarget(
            self,
            action: #selector(addCityTapped),
            for: .touchUpInside
        )
        
        headerView.settingsButton.addTarget(
            self,
            action: #selector(settingsButtonTapped),
            for: .touchUpInside
        )
        
        headerView.cityLabel.addTarget(
            self,
            action: #selector(openCitiesTapped),
            for: .touchUpInside
        )
        
        daysButton.addTarget(
            self,
            action: #selector(toggleForecastDays),
            for: .touchUpInside
        )
        
    }
    
    func setupTableView() {
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(
            ForecastDayCell.self,
            forCellReuseIdentifier: ForecastDayCell.reuseID
        )
    }
    
    func setupGestures() {
        let left = UISwipeGestureRecognizer(target: self, action: #selector(nextCity))
        left.direction = .left
        view.addGestureRecognizer(left)
        
        let right = UISwipeGestureRecognizer(target: self, action: #selector(previousCity))
        right.direction = .right
        view.addGestureRecognizer(right)
    }
    
    @objc private func addCityTapped() {
        let alert = UIAlertController(title: "Добавить город", message: nil, preferredStyle: .alert)
        alert.addTextField { $0.placeholder = "Введите название" }
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        alert.addAction(UIAlertAction(title: "Добавить", style: .default) { [weak self] _ in
            guard let self,
                  let cityName = alert.textFields?.first?.text,
                  !cityName.isEmpty else { return }
            
            // Передаем строку напрямую в метод загрузки
            self.loadCity(cityName)
        })
        
        present(alert, animated: true)
    }
    
    @objc private func settingsButtonTapped() {
        let settingsVC = SettingsViewController()
        
        
        settingsVC.delegate = self
        
        
        navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    @objc private func openCitiesTapped() {
        let citiesVC = CitiesViewController()
        citiesVC.delegate = self
        navigationController?.pushViewController(citiesVC, animated: true)
    }
    
    @objc private func openHourlyForecast() {
        let hourlyVC = HourlyWeatherViewController(
            forecast: hourlyForecast
        )
        navigationController?.pushViewController(hourlyVC, animated: true)
        
    }
    
    @objc private func toggleForecastDays() {
        isExtendedForecast.toggle()
        
        // Меняем текст кнопки в зависимости от состояния
        let buttonTitle = isExtendedForecast ? "7 дней" : "25 дней"
        daysButton.setTitle(buttonTitle, for: .normal)
        
        // Перерисовываем строки таблицы
        tableView.reloadData()
    }

    
//    @objc private func openDays() {
//        let vc = ChangeDaysViewController()
//        vc.delegate = self
//        navigationController?.pushViewController(vc, animated: true)
//    }
    
    @objc func nextCity() {
        guard currentCityIndex < savedCities.count - 1 else { return }
        currentCityIndex += 1
        showCurrentCity()
    }
    
    @objc func previousCity() {
        guard currentCityIndex > 0 else { return }
        currentCityIndex -= 1
        showCurrentCity()
    }
    
    
    private func showCurrentCity() {
        guard currentCityIndex < savedCities.count else { return }
        let cachedCity = savedCities[currentCityIndex]
        
        pageControl.currentPage = currentCityIndex
        
        headerView.cityLabel.setTitle(cachedCity.name, for: .normal)
        
        WeatherService.shared.loadCurrentWeather(
            latitude: cachedCity.latitude,
            longitude: cachedCity.longitude
        ) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let weather):
                    
                    UIView.transition(with: self.weatherInfoView, duration: 0.25, options: .transitionCrossDissolve) {
                        self.weatherInfoView.configure(with: weather)
                    }
//                    UIView.transition(with: self.detailsView, duration: 0.25, options: .transitionCrossDissolve) {
//                        self.detailsView.configure(with: weather)
//                    }
                    
                    self.loadWeatherForecast(
                        latitude: cachedCity.latitude,
                        longitude: cachedCity.longitude,
                    )
                    
                    // 1. Ищем оригинальный объект CityWeather в Core Data по имени, чтобы удалить его
                    let allNSWeather = CoreDataManager.shared.fetchWeather()
                    if let dbObjectToDelete = allNSWeather.first(where: { $0.cityName == cachedCity.name }) {
                        CoreDataManager.shared.deleteCity(dbObjectToDelete)
                    }
                    
                    // 2. Сохраняем обновленные данные погоды в базу данных
                    let isSaved = CoreDataManager.shared.saveWeather(
                        from: weather,
                        latitude: cachedCity.latitude,
                        longitude: cachedCity.longitude
                    )

                    if !isSaved {
                        self.showError("Этот город уже добавлен в ваш список!")
                    }
//                    CoreDataManager.shared.saveWeather(
//                        from: weather,
//                        latitude: cachedCity.latitude,
//                        longitude: cachedCity.longitude
//                    )
                    
                    // 3. Исправляем присвоение: получаем свежие данные из БД и трансформируем их в [City]
                    let freshDBWeather = CoreDataManager.shared.fetchWeather()
                    self.savedCities = freshDBWeather.compactMap { item in
                        guard let name = item.cityName else { return nil }
                        return City(
                            name: name,
                            latitude: item.latitude,
                            longitude: item.longitude
                        )
                    }
                    
                case .failure(let error):
                    print("Не удалось обновить погоду с сервера: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func loadCity(_ cityName: String) {
        GeocoderService.shared.getCoordinates(city: cityName) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let coordinate):
                    
                    // Запрашиваем погоду для нового города, чтобы сохранить полный снимок в базу
                    WeatherService.shared.loadCurrentWeather(latitude: coordinate.latitude, longitude: coordinate.longitude) { weatherResult in
                        DispatchQueue.main.async {
                            switch weatherResult {
                            case .success(let weather):
                                // Сохраняем в Core Data через ваш менеджер
                                let isSaved = CoreDataManager.shared.saveWeather(
                                    from: weather,
                                    latitude: coordinate.latitude,
                                    longitude: coordinate.longitude
                                )

                                if !isSaved {
                                    self.showError("Этот город уже добавлен в ваш список!")
                                }
//                                CoreDataManager.shared.saveWeather(
//                                    from: weather,
//                                    latitude: coordinate.latitude,
//                                    longitude: coordinate.longitude
//                                )
                                
                                let updatedWeather = CoreDataManager.shared.fetchWeather()
                                self.savedCities = updatedWeather.compactMap { item in
                                    guard let name = item.cityName else { return nil }
                                    return City(
                                        name: name,
                                        latitude: item.latitude,
                                        longitude: item.longitude
                                    )
                                }
                                
                                // Переключаем UI на новый город
                                self.currentCityIndex = self.savedCities.count - 1
                                self.pageControl.numberOfPages = self.savedCities.count
                                self.showCurrentCity()
                                
                            case .failure(let error):
                                self.showError("Не удалось получить данные о погоде: \(error.localizedDescription)")
                            }
                        }
                    }
                    
                case .failure(let error):
                    self.showError("Город не найден: \(error.localizedDescription)")
                }
            }
        }
    }
    
   

    func loadWeatherForecast(
        latitude: Double,
        longitude: Double
    ) {

        WeatherService.shared.loadForecast(
            latitude: latitude,
            longitude: longitude
        ) { [weak self] result in

            DispatchQueue.main.async {

                switch result {

                case .success(let response):

                    self?.daylyForecast = self?.convertForecast(response) ?? []
                    
                    self?.hourlyForecast = self?.convertHourlyForecast(response) ?? []

                    self?.tableView.reloadData()

                case .failure(let error):

                    print(error.localizedDescription)

                }
            }
        }
    }
    
   

    func convertForecast(
        _ response: ForecastResponse
    ) -> [ForecastDay] {

        var result: [ForecastDay] = []

        var addedDays: Set<String> = []

        let formatter = DateFormatter()

        formatter.dateFormat = "yyyy-MM-dd"

        for item in response.list {

            let date = Date(timeIntervalSince1970: item.dt)

            let key = formatter.string(from: date)

            if addedDays.contains(key) {

                continue

            }

            addedDays.insert(key)

            result.append(

                ForecastDay(

                    date: date,

                    temperature: item.main.temp,
                    
                    //minTemp: item.main.minTemp,
                    
                    //maxTemp: item.main.maxTemp,

                    description: item.weather.first?.description ?? "",

                    icon: item.weather.first?.icon ?? "",
                    
                    humidity: item.main.humidity,
                    
                    uvIndex: item.uvi ?? 0.0,
                    
                    windSpeed: item.wind.speed,
                    
                    rainProbability: item.pop ?? 0.0,
                    
                    cloudiness: item.clouds?.all ?? 0.0,
                    
                    sunrise: item.sunrise ?? 0.0,
                    
                    sunset: item.sunset ?? 0.0,
                    
                    moonrise: item.moonrise ?? 0.0,
                    
                    moonset: item.moonset ?? 0.0,
                    
                    moonPhase: item.moon_phase ?? 0.0,
                    
                    timezoneOffset: item.timezoneOffset ?? 0,
                    
                    air_pollution: item.air_pollution ?? 0
            

                )

            )

        }

        let days = UserDefaults.standard.integer(forKey: "ForecastDays")
        if days == 25 {
            return Array(result.prefix(25))
        }
        return Array(result.prefix(7))
    }

    private func convertHourlyForecast(_ response: ForecastResponse) -> [HourlyForecast] {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        return response.list.prefix(8).map {item in
            HourlyForecast(
                
                time: formatter.string(from: Date(timeIntervalSince1970: item.dt)),
                
                temperature: item.main.temp,
                
                windSpeed: item.wind.speed,
                
                icon: item.weather.first?.icon ?? "",
                
                humidity: item.main.humidity,
                
                description: item.weather.first?.description ?? ""
            )
        }
            
        
    }



    func showError(_ message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default))
        present(alert, animated: true)
    }
    
    func loadCities() {
        
        let savedWeather = CoreDataManager.shared.fetchWeather()
        
        if savedWeather.isEmpty {
            
            savedCities = [
                City(
                    name: "Ташкент",
                    latitude: 41.3111,
                    longitude: 69.2797
                )
            ]
            
        } else {
            
            savedCities = savedWeather.compactMap {
                
                guard
                    let name = $0.cityName
                else {
                    return nil
                }
                
                return City(
                    name: name,
                    latitude: $0.latitude,
                    longitude: $0.longitude
                )
            }
        }
        
        pageControl.numberOfPages = savedCities.count
        pageControl.currentPage = 0
        
        showCurrentCity()
    }
        
        
}


extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Если активирован расширенный режим — показываем весь массив list (до 40 элементов),
        // иначе ограничиваем первыми 7 элементами
        return isExtendedForecast ? daylyForecast.count : min(7, daylyForecast.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ForecastDayCell.reuseID,
            for: indexPath
        ) as? ForecastDayCell else {
            return UITableViewCell()
        }
        
        let dayForecast = daylyForecast[indexPath.row]
        cell.configure(with: dayForecast)
        
        return cell
    }
    
    // Задаем высоту строки (карточка 50 поинтов + отступы)
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let currentCityName = headerView.cityLabel.currentTitle ?? "Выбранный город"
        
        
        let detailsVC = DailyDetailsViewController(
            forecastList: daylyForecast,
            startIndex: indexPath.row,
            cityName: currentCityName
        )
        
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}

//extension MainViewController: UITableViewDataSource {
//
//    func tableView(
//        _ tableView: UITableView,
//        numberOfRowsInSection section: Int
//    ) -> Int {
//
//        forecast.count
//    }
//
//    func tableView(
//        _ tableView: UITableView,
//        cellForRowAt indexPath: IndexPath
//    ) -> UITableViewCell {
//
//        guard let cell = tableView.dequeueReusableCell(
//            withIdentifier: ForecastDayCell.reuseID,
//            for: indexPath
//        ) as? ForecastDayCell else {
//
//            return UITableViewCell()
//        }
//
//        cell.configure(with: forecast[indexPath.row])
//
//        return cell
//    }
//
//    func tableView(
//        _ tableView: UITableView,
//        heightForRowAt indexPath: IndexPath
//    ) -> CGFloat {
//
//        60
//    }
//
//
//}
//
//extension MainViewController: UITableViewDelegate {
//
//}
//
//extension MainViewController: ChangeDaysViewControllerDelegate {
//
//    func changeDaysViewController(
//        _ controller: ChangeDaysViewController,
//        didChangeForecastDays days: Int
//    ) {
//
//        loadWeatherForecast(
//            latitude: savedCities[currentCityIndex].latitude,
//            longitude: savedCities[currentCityIndex].longitude
//        )
//    }
//}

extension MainViewController: SettingsViewControllerDelegate {

    func settingsViewController(
        _ controller: SettingsViewController,
        didChangeForecastDays days: Int
    ) {
        guard currentCityIndex < savedCities.count else { return }
                
        // Метод выполнит новый сетевой запрос, подтянет UserDefaults и обновит значки градусов
        showCurrentCity()

//        loadWeatherForecast(
//            latitude: savedCities[currentCityIndex].latitude,
//            longitude: savedCities[currentCityIndex].longitude
//        )
    }
}
extension MainViewController: CitiesViewControllerDelegate {
    
    func citiesViewController(
        _ controller: CitiesViewController,
        didSelect city: CityWeather
    ) {
        // 1. Ищем индекс выбранного города в вашем локальном массиве [City] по названию
        if let targetIndex = savedCities.firstIndex(where: { $0.name == city.cityName }) {
            
            // 2. Обновляем текущий индекс на главном экране
            self.currentCityIndex = targetIndex
            
            // 3. Вызываем метод, который обновит UIPageControl, имя хедера и сделает запрос в сеть
            self.showCurrentCity()
        }
    }
//extension MainViewController: CitiesViewControllerDelegate {
//    func citiesViewController(_ controller: CitiesViewController, didSelect city: CityWeather) {
//        
//        self.showCurrentCity()
//    }
    

  
//    func citiesViewController(
//        _ controller: CitiesViewController,
//        didSelect city: CityWeather
//    ) {
//
//        guard
//            let latitude = city.value(
//                forKey: "latitude"
//            ) as? Double,
//            let longitude = city.value(
//                forKey: "longitude"
//            ) as? Double
//        else {
//            return
//        }
//
//        let cityModel = City(
//            name: city.cityName ?? "",
//            latitude: latitude,
//            longitude: longitude
//        )
//
//        pageController.showCity(
//            cityModel
//        )
//
//        navigationController?.popViewController(
//            animated: true
//        )
//    }
}


//
//
//
//
//
//


