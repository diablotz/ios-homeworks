//
//  MainViewController.swift
//  WeatherManager
//
//  Created by Timur Zakirov on 04/08/26.
//

//import UIKit
//import MapKit
//import CoreLocation
//
//final class MainViewController: UIViewController, CitiesPageViewControllerDelegate {
//
//    private let headerView = WeatherHeaderView()
//    
//    private let pageControl: UIPageControl = {
//        let control = UIPageControl()
//        control.currentPage = 0
//        control.currentPageIndicatorTintColor = .green
//        control.pageIndicatorTintColor = .green.withAlphaComponent(0.3)
//        control.hidesForSinglePage = true
//        return control
//    }()
//
//    private let pageController = CitiesPageViewController(
//        transitionStyle: .scroll,
//        navigationOrientation: .horizontal
//    )
//
//    private var cities: [City] = [
//        City(
//            name: "Ташкент",
//            latitude: 41.3111,
//            longitude: 69.2797
//        )
//    ]
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        setupUI()
//        setupActions()
//
//        pageController.configure(with: cities)
//        
//        pageControl.numberOfPages = cities.count
//        pageControl.currentPage = 0
//        
//        pageController.pageDelegate = self
//    }
//
//
//    func setupUI() {
//
//        view.backgroundColor = UIColor(named: "background") ?? .systemBackground
//
//        navigationController?.setNavigationBarHidden(true, animated: false)
//
//        view.addSubview(headerView)
//
//        headerView.translatesAutoresizingMaskIntoConstraints = false
//
//        addChild(pageController)
//
//        view.addSubview(pageController.view)
//
//        pageController.view.translatesAutoresizingMaskIntoConstraints = false
//
//        pageController.didMove(toParent: self)
//        
//        view.addSubview(pageControl)
//        pageControl.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//
//            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 8),
//
//            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
//
//            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20),
//
//            headerView.heightAnchor.constraint(equalToConstant: 44),
//            
//            pageControl.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 10),
//            
//            pageControl.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
//
//            pageController.view.topAnchor.constraint(equalTo: pageControl.bottomAnchor,constant: 20),
//
//            pageController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//
//            pageController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//
//            pageController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//
//        ])
//    }
//
//    func setupActions() {
//
//        headerView.addButton.addTarget(
//            self,
//            action: #selector(addCityTapped),
//            for: .touchUpInside
//        )
//    }
//
//    func addCity(_ city: City) {
//
//        cities.append(city)
//
//        pageController.addCity(city)
//        
//        pageControl.numberOfPages = cities.count
//        pageControl.currentPage = cities.count - 1
//    }
//
//    func showError(_ message: String) {
//
//        let alert = UIAlertController(
//            title: "Ошибка",
//            message: message,
//            preferredStyle: .alert
//        )
//
//        alert.addAction(UIAlertAction(title: "OK", style: .default))
//
//        present(alert, animated: true)
//    }
//    
//    func citiesPageViewController(
//        _ controller: CitiesPageViewController,
//        didChangePage index: Int
//    ) {
//        pageControl.currentPage = index
//    }
//
//@objc
//private func addCityTapped() {
//
//    let alert = UIAlertController(
//        title: "Добавить город",
//        message: nil,
//        preferredStyle: .alert
//    )
//
//    alert.addTextField {
//        $0.placeholder = "Введите название"
//    }
//
//    alert.addAction(
//        UIAlertAction(
//            title: "Отмена",
//            style: .cancel
//        )
//    )
//
//    alert.addAction(
//        UIAlertAction(
//            title: "Добавить",
//            style: .default
//        ) { [weak self] _ in
//
//            guard
//                let self,
//                let cityName = alert.textFields?.first?.text,
//                !cityName.isEmpty
//            else {
//                return
//            }
//
//            GeocoderService.shared.getCoordinates(city: cityName) { result in
//
//                DispatchQueue.main.async {
//
//                    switch result {
//
//                    case .success(let coordinate):
//
//                        let city = City(
//                            name: cityName,
//                            latitude: coordinate.latitude,
//                            longitude: coordinate.longitude
//                        )
//
//                        self.addCity(city)
//
//                    case .failure(let error):
//
//                        self.showError(error.localizedDescription)
//                    }
//                }
//            }
//        }
//    )
//
//    present(alert, animated: true)
//}
//}
//

//import UIKit
//import MapKit
//import CoreLocation
//
//final class MainViewController: UIViewController {
//
//    // MARK: - Views
//
//    private let headerView = WeatherHeaderView()
//
//    private let weatherInfoView = WeatherInfoView()
//
//    private let detailsView = WeatherDetailsView()
//
//    private let pageControl: UIPageControl = {
//
//        let control = UIPageControl()
//
//        control.currentPageIndicatorTintColor = .white
//        control.pageIndicatorTintColor = UIColor.white.withAlphaComponent(0.4)
//        control.hidesForSinglePage = true
//
//        return control
//    }()
//
//    private let hourlyButton: UIButton = {
//
//        let button = UIButton(type: .system)
//
//        button.setTitle("Подробнее на 24 часа", for: .normal)
//
//        button.setTitleColor(.white, for: .normal)
//
//        button.backgroundColor = UIColor.white.withAlphaComponent(0.18)
//
//        button.layer.cornerRadius = 18
//
//        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
//
//        return button
//    }()
//
//    private let tableView = UITableView(frame: .zero, style: .plain)
//
//    // MARK: - Data
//
//    private var cities: [City] = []
//
//    private var currentCityIndex = 0
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        setupUI()
//        setupTableView()
//        setupGestures()
//        
//        loadCities()
//        
//    }
//    
//    
//
//    func setupUI() {
//
//        navigationController?.setNavigationBarHidden(true, animated: false)
//
//        view.backgroundColor = UIColor(named: "background") ?? .systemBlue
//
//        [
//            headerView,
//            pageControl,
//            weatherInfoView,
//            detailsView,
//            hourlyButton,
//            tableView
//        ].forEach {
//
//            $0.translatesAutoresizingMaskIntoConstraints = false
//
//            view.addSubview($0)
//        }
//
//        NSLayoutConstraint.activate([
//
//            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 8),
//
//            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
//
//            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20),
//
//            headerView.heightAnchor.constraint(equalToConstant: 44),
//
//            pageControl.topAnchor.constraint(equalTo: headerView.bottomAnchor,constant: 10),
//
//            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//
//            weatherInfoView.topAnchor.constraint(equalTo: pageControl.bottomAnchor,constant: 12),
//
//            weatherInfoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//
//            weatherInfoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//
//            detailsView.topAnchor.constraint(equalTo: weatherInfoView.bottomAnchor,constant: 30),
//
//            detailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
//
//            detailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20),
//
//            hourlyButton.topAnchor.constraint(equalTo: detailsView.bottomAnchor,constant: 24),
//
//            hourlyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
//
//            hourlyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20),
//
//            hourlyButton.heightAnchor.constraint(equalToConstant: 50),
//
//            tableView.topAnchor.constraint(equalTo: hourlyButton.bottomAnchor,constant: 24),
//
//            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//
//            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//
//            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
//        ])
//        
//        headerView.addButton.addTarget(self, action: #selector(addCityTapped), for: .touchUpInside)
//    }
//
//
//    func setupTableView() {
//
//        tableView.backgroundColor = .clear
//
//        tableView.separatorStyle = .none
//
//        tableView.showsVerticalScrollIndicator = false
//
//        tableView.dataSource = self
//
//        tableView.delegate = self
//    }
//
//
//    func setupGestures() {
//
//        let left = UISwipeGestureRecognizer(
//            target: self,
//            action: #selector(nextCity)
//        )
//
//        left.direction = .left
//
//        view.addGestureRecognizer(left)
//
//        let right = UISwipeGestureRecognizer(
//            target: self,
//            action: #selector(previousCity)
//        )
//
//        right.direction = .right
//
//        view.addGestureRecognizer(right)
//    }
//    
//    @objc private func addCityTapped() {
//    
//        let alert = UIAlertController(
//            title: "Добавить город",
//            message: nil,
//            preferredStyle: .alert
//        )
//    
//        alert.addTextField {
//            $0.placeholder = "Введите название"
//        }
//    
//        alert.addAction(
//            UIAlertAction(
//                title: "Отмена",
//                style: .cancel
//            )
//        )
//    
//        alert.addAction(
//            UIAlertAction(
//                title: "Добавить",
//                style: .default
//            ) { [weak self] _ in
//    
//                guard
//                    let self,
//                    let cityName = alert.textFields?.first?.text,
//                    !cityName.isEmpty
//                else {
//                    return
//                }
//    
//                GeocoderService.shared.getCoordinates(city: cityName) { result in
//    
//                    DispatchQueue.main.async {
//    
//                        switch result {
//    
//                        case .success(let coordinate):
//    
//                            let city = City(
//                                name: cityName,
//                                latitude: coordinate.latitude,
//                                longitude: coordinate.longitude
//                            )
//    
//                            self.loadCity(city)
//    
//                        case .failure(let error):
//    
//                            self.showError(error.localizedDescription)
//                        }
//                    }
//                }
//            }
//        )
//    
//        present(alert, animated: true)
//    }
//
//    @objc func nextCity() {
//
//        guard currentCityIndex < cities.count - 1 else {
//            return
//        }
//
//        currentCityIndex += 1
//
//        UIView.transition(
//            with: weatherInfoView,
//            duration: 0.25,
//            options: .transitionCrossDissolve
//        ) {
//            self.weatherInfoView.configure(with: weather)
//        }
//
//        UIView.transition(
//            with: detailsView,
//            duration: 0.25,
//            options: .transitionCrossDissolve
//        ){
//            self.weatherInfoView.configure(with: weather)
//        }
//
//        showCurrentCity()
//    }
//
//    @objc func previousCity() {
//
//        guard currentCityIndex > 0 else {
//            return
//        }
//
//        currentCityIndex -= 1
//
//        UIView.transition(
//            with: weatherInfoView,
//            duration: 0.25,
//            options: .transitionCrossDissolve
//        ){
//            self.weatherInfoView.configure(with: weather)
//        }
//
//        UIView.transition(
//            with: detailsView,
//            duration: 0.25,
//            options: .transitionCrossDissolve
//        ){
//            self.weatherInfoView.configure(with: weather)
//        }
//
//        showCurrentCity()
//    }
//
//
//    private func loadCity(_ cityName: String) {
//
//        GeocoderService.shared.getCoordinates(city: cityName) { [weak self] result in
//
//            DispatchQueue.main.async {
//
//                switch result {
//
//                case .success(let coordinate):
//
//                    let city = City(
//                        name: cityName,
//                        latitude: coordinate.latitude,
//                        longitude: coordinate.longitude
//                    )
//
//                    self?.cities.append(city)
//
//                    self?.currentCityIndex = (self?.cities.count ?? 1) - 1
//
//                    self?.pageControl.numberOfPages = self?.cities.count ?? 0
//
//                    self?.showCurrentCity()
//
//                case .failure(let error):
//
//                    print(error.localizedDescription)
//                }
//            }
//        }
//    }

import UIKit
import MapKit
import CoreLocation
import _LocationEssentials

final class MainViewController: UIViewController {

    // MARK: - Views
    private let headerView = WeatherHeaderView()
    private let weatherInfoView = WeatherInfoView()
    private let detailsView = WeatherDetailsView()

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

    private let tableView = UITableView(frame: .zero, style: .plain)

    // MARK: - Data
    private var cities: [City] = []
    private var currentCityIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        setupGestures()
        
        // Загружаем начальный город по умолчанию, если массив пуст
        if cities.isEmpty {
            loadCity("Tashkent")
        }
    }
    
    func setupUI() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.backgroundColor = UIColor(named: "background") ?? .systemBlue

        [
            headerView, pageControl, weatherInfoView,
            detailsView, hourlyButton, tableView
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

            weatherInfoView.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 10),
            weatherInfoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            weatherInfoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            weatherInfoView.heightAnchor.constraint(equalToConstant: 100),

            detailsView.topAnchor.constraint(equalTo: weatherInfoView.bottomAnchor, constant: 30),
            detailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            detailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            detailsView.heightAnchor.constraint(equalToConstant: 200),

            hourlyButton.topAnchor.constraint(equalTo: detailsView.bottomAnchor, constant: 24),
            hourlyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            hourlyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            hourlyButton.heightAnchor.constraint(equalToConstant: 50),

            tableView.topAnchor.constraint(equalTo: hourlyButton.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        headerView.addButton.addTarget(self, action: #selector(addCityTapped), for: .touchUpInside)
    }

    func setupTableView() {
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
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

    @objc func nextCity() {
        guard currentCityIndex < cities.count - 1 else { return }
        currentCityIndex += 1
        showCurrentCity()
    }

    @objc func previousCity() {
        guard currentCityIndex > 0 else { return }
        currentCityIndex -= 1
        showCurrentCity()
    }

    // Основной метод для отображения данных выбранного города
    private func showCurrentCity() {
        guard currentCityIndex < cities.count else { return }
        let currentCity = cities[currentCityIndex]
        
        // Обновляем индикатор страниц
        pageControl.currentPage = currentCityIndex
        headerView.cityLabel.text = currentCity.name

        // Загружаем погоду из сети по координатам города
        WeatherService.shared.loadCurrentWeather(
            latitude: currentCity.latitude,
            longitude: currentCity.longitude
        ) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let weather):
                    // Плавно обновляем UI при переключении или загрузке погоды
                    if let infoView = self?.weatherInfoView, let detailsView = self?.detailsView {
                        UIView.transition(with: infoView, duration: 0.25, options: .transitionCrossDissolve) {
                            infoView.configure(with: weather)
                        }
                        UIView.transition(with: detailsView, duration: 0.25, options: .transitionCrossDissolve) {
                            detailsView.configure(with: weather)
                        }
                    }
                case .failure(let error):
                    self?.showError(error.localizedDescription)
                }
            }
        }
    }

    private func loadCity(_ cityName: String) {
        GeocoderService.shared.getCoordinates(city: cityName) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let coordinate):
                    let city = City(
                        name: cityName,
                        latitude: coordinate.latitude,
                        longitude: coordinate.longitude
                    )
                    
                    self?.cities.append(city)
                    self?.currentCityIndex = (self?.cities.count ?? 1) - 1
                    self?.pageControl.numberOfPages = self?.cities.count ?? 0
                    self?.showCurrentCity()
                    
                case .failure(let error):
                    self?.showError(error.localizedDescription)
                }
            }
        }
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default))
        present(alert, animated: true)
    }
    
    func loadCities() {

        let savedWeather = CoreDataManager.shared.fetchWeather()

        if savedWeather.isEmpty {

            cities = [
                City(
                    name: "Ташкент",
                    latitude: 41.3111,
                    longitude: 69.2797
                )
            ]

        } else {

            cities = savedWeather.compactMap {

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

        pageControl.numberOfPages = cities.count
        pageControl.currentPage = 0

        showCurrentCity()
    }


//    func showCurrentCity() {
//
//        guard cities.indices.contains(currentCityIndex) else {
//            return
//        }
//
//        let city = cities[currentCityIndex]
//
//        headerView.cityLabel.text = city.name
//
//        WeatherService.shared.loadCurrentWeather(
//            latitude: city.latitude,
//            longitude: city.longitude
//        ) { [weak self] result in
//
//            DispatchQueue.main.async {
//
//                switch result {
//
//                case .success(let weather):
//
//                    self?.weatherInfoView.configure(with: weather)
//
//                    self?.detailsView.configure(with: weather)
//
//                    self?.pageControl.currentPage = self?.currentCityIndex ?? 0
//
//                case .failure(let error):
//
//                    print(error.localizedDescription)
//                }
//            }
//        }
//    }
}




extension MainViewController: UITableViewDataSource {

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {

        0
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        UITableViewCell()
    }
}

extension MainViewController: UITableViewDelegate {

}


//// MARK: - UITableViewDataSource & UITableViewDelegate
//extension MainViewController: UITableViewDataSource, UITableViewDelegate {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 0 // Замените на ваше количество строк для почасового/дневного прогноза
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        return UITableViewCell() // Замените на вашу кастомную ячейку
//    }
//}

    






