//
//  HourlyWeatherViewController.swift
//  WeatherManager
//
//  Created by Timur Zakirov on 07/08/26.
//

import UIKit

final class HourlyWeatherViewController: UIViewController {

    

    private var forecast: [HourlyForecast]

    

    private let backButton: UIButton = {

        let button = UIButton(type: .system)

        button.setImage(
            UIImage(systemName: "chevron.left"),
            for: .normal
        )

        button.setTitle(" Назад", for: .normal)

        button.tintColor = .white

        button.setTitleColor(.white, for: .normal)

        button.titleLabel?.font = .systemFont(
            ofSize: 17,
            weight: .medium
        )

        return button
    }()

    private let titleLabel: UILabel = {

        let label = UILabel()

        label.text = "Подробнее на 24 часа"

        label.textColor = .white

        label.font = .systemFont(
            ofSize: 18,
            weight: .bold
        )

        label.textAlignment = .center

        return label
    }()

    private let tableView: UITableView = {

        let tableView = UITableView(
            frame: .zero,
            style: .plain
        )

        tableView.backgroundColor = .clear

        tableView.separatorStyle = .none

        tableView.showsVerticalScrollIndicator = false

        return tableView
    }()

   

    init(forecast: [HourlyForecast]) {

        self.forecast = forecast

        super.init(
            nibName: nil,
            bundle: nil
        )
    }

    required init?(coder: NSCoder) {

        fatalError(
            "init(coder:) has not been implemented"
        )
    }

    

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(
            named: "background"
        ) ?? .systemBlue

        setupUI()

        setupTableView()

        setupActions()
    }


    func setupUI() {

        [
            backButton,
            titleLabel,
            tableView
        ].forEach {

            $0.translatesAutoresizingMaskIntoConstraints = false

            view.addSubview($0)
        }

        NSLayoutConstraint.activate([

            // Кнопка назад

            backButton.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 10
            ),

            backButton.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 20
            ),

            backButton.heightAnchor.constraint(
                equalToConstant: 44
            ),

            // Заголовок

            titleLabel.centerYAnchor.constraint(
                equalTo: backButton.centerYAnchor
            ),

            titleLabel.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),

            // Таблица

            tableView.topAnchor.constraint(
                equalTo: backButton.bottomAnchor,
                constant: 15
            ),

            tableView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 16
            ),

            tableView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -16
            ),

            tableView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor
            )
        ])
    }

    func setupTableView() {

        tableView.dataSource = self

        tableView.delegate = self

        tableView.register(
            HourlyForecastCell.self,
            forCellReuseIdentifier: HourlyForecastCell.reuseID
        )
    }

    func setupActions() {

        backButton.addTarget(
            self,
            action: #selector(backButtonTapped),
            for: .touchUpInside
        )
    }

    @objc
    func backButtonTapped() {

        navigationController?.popViewController(
            animated: true
        )
    }
}

extension HourlyWeatherViewController: UITableViewDataSource {

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {

        return forecast.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: HourlyForecastCell.reuseID,
            for: indexPath
        ) as? HourlyForecastCell else {

            return UITableViewCell()
        }

        cell.configure(
            with: forecast[indexPath.row]
        )

        return cell
    }
}

extension HourlyWeatherViewController: UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {

        return 80
    }
}



