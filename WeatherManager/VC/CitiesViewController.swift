//
//  CitiesViewController.swift
//  WeatherManager
//
//  Created by Timur Zakirov on 08/08/26.
//

import UIKit

protocol CitiesViewControllerDelegate: AnyObject {

    func citiesViewController(
        _ controller: CitiesViewController,
        didSelect city: CityWeather
    )
}

final class CitiesViewController: UIViewController {

    

    weak var delegate: CitiesViewControllerDelegate?

    private var cities: [CityWeather] = []



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

    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Мои города"

        view.backgroundColor =
            UIColor(named: "background") ?? .systemBlue

        setupTableView()

        loadCities()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
        
        
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = .white 
        
        loadCities()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    func loadCities() {

        cities = CoreDataManager.shared.fetchWeather()

        tableView.reloadData()
    }

    func setupTableView() {

        view.addSubview(tableView)

        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([

            tableView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
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
                equalTo: view.bottomAnchor
            )
        ])

        tableView.dataSource = self

        tableView.delegate = self

        tableView.register(
            CityTableViewCell.self,
            forCellReuseIdentifier: CityTableViewCell.reuseID
        )
    }
}

extension CitiesViewController: UITableViewDataSource, UITableViewDelegate {
    
    // 1. Метод количества строк
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
        func tableView(
            _ tableView: UITableView,
            cellForRowAt indexPath: IndexPath
        ) -> UITableViewCell {
    
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CityTableViewCell.reuseID,
                for: indexPath
            ) as? CityTableViewCell else {
    
                return UITableViewCell()
            }
    
            cell.configure(
                with: cities[indexPath.row]
            )
    
            return cell
        }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Достаем выбранный город
        let selectedCity = cities[indexPath.row]
        
        // Отправляем его через делегат на MainViewController
        delegate?.citiesViewController(self, didSelect: selectedCity)
        
        // ЖЕСТКО ПРИКАЗЫВАЕМ ЭКРАНУ ЗАКРЫТЬСЯ
        if let navigationController = self.navigationController {
            navigationController.popViewController(animated: true)
        } else {
            // Резервный вариант, если стек навигации почему-то потерялся
            dismiss(animated: true, completion: nil)
        }
    }
    
    func tableView(
            _ tableView: UITableView,
            trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
        ) -> UISwipeActionsConfiguration? {
    
            let deleteAction = UIContextualAction(
                style: .destructive,
                title: "Удалить"
            ) { [weak self] _, _, completion in
    
                guard let self else {
                    completion(false)
                    return
                }
    
                let city = self.cities[indexPath.row]
    
                CoreDataManager.shared.deleteCity(city)
    
                self.cities.remove(at: indexPath.row)
    
                tableView.deleteRows(
                    at: [indexPath],
                    with: .automatic
                )
    
                completion(true)
            }
    
            deleteAction.image = UIImage(
                systemName: "trash"
            )
    
            return UISwipeActionsConfiguration(
                actions: [deleteAction]
            )
        }
}



//extension CitiesViewController: UITableViewDataSource {
//
//    func tableView(
//        _ tableView: UITableView,
//        numberOfRowsInSection section: Int
//    ) -> Int {
//
//        cities.count
//    }
//
//    func tableView(
//        _ tableView: UITableView,
//        cellForRowAt indexPath: IndexPath
//    ) -> UITableViewCell {
//
//        guard let cell = tableView.dequeueReusableCell(
//            withIdentifier: CityTableViewCell.reuseID,
//            for: indexPath
//        ) as? CityTableViewCell else {
//
//            return UITableViewCell()
//        }
//
//        cell.configure(
//            with: cities[indexPath.row]
//        )
//
//        return cell
//    }
//}
//
//
//extension CitiesViewController: UITableViewDelegate {
//
//    func tableView(
//        _ tableView: UITableView,
//        didSelectRowAt indexPath: IndexPath
//    ) {
//
//        let city = cities[indexPath.row]
//
//        tableView.deselectRow(
//            at: indexPath,
//            animated: true
//        )
//
//        delegate?.citiesViewController(
//            self,
//            didSelect: city
//        )
//    }
//
//
//
//}


