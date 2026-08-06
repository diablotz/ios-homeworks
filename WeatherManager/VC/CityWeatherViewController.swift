//
//  CityWeatherViewController.swift
//  WeatherManager
//
//  Created by Timur Zakirov on 06/08/26.
//

import UIKit

final class CityWeatherViewController: UIViewController {

    let city: City

    private let weatherInfoView = WeatherInfoView()
    private let detailsView = WeatherDetailsView()

    private let hourlyButton: UIButton = {

        let button = UIButton(type: .system)

        button.setTitle("Подробнее на 24 часа", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)

        button.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        button.layer.cornerRadius = 16

        button.setTitleColor(.white, for: .normal)

        return button
    }()

    private let tableView = UITableView(frame: .zero, style: .plain)

    init(city: City) {
        self.city = city
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()

        loadWeather()
    }

    func setupUI() {

        view.backgroundColor = .clear

        [weatherInfoView,
         detailsView,
         hourlyButton,
         tableView].forEach {

            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none

        NSLayoutConstraint.activate([

            weatherInfoView.topAnchor.constraint(equalTo: view.topAnchor),

            weatherInfoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),

            weatherInfoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            detailsView.topAnchor.constraint(equalTo: weatherInfoView.bottomAnchor, constant: 30),

            detailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            detailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            hourlyButton.topAnchor.constraint(equalTo: detailsView.bottomAnchor, constant: 24),

            hourlyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            hourlyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            hourlyButton.heightAnchor.constraint(equalToConstant: 50),

            tableView.topAnchor.constraint(equalTo: hourlyButton.bottomAnchor, constant: 24),

            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),

            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)

        ])
    }
    
    

private func loadWeather() {

    WeatherService.shared.loadCurrentWeather(
        latitude: city.latitude,
        longitude: city.longitude
    ) { [weak self] result in

        DispatchQueue.main.async {

            switch result {

            case .success(let weather):

                self?.weatherInfoView.configure(with: weather)

                self?.detailsView.configure(with: weather)

            case .failure(let error):

                print(error.localizedDescription)
            }
        }
    }
}
}




