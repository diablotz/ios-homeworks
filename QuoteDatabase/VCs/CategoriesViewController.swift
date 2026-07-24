//
//  CategoriesViewController.swift
//  QuoteDatabase
//
//  Created by Timur Zakirov on 24/07/26.
//

import UIKit
import RealmSwift

class CategoriesViewController: UIViewController {

    weak var coordinator: CategoriesCoordinator?
    
    private let tableView = UITableView()
    
    private var categories: Results<Category>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Категории"
        
        setupTableView()
        
        categories = RealmManager.shared.getCategories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)

            categories = RealmManager.shared.getCategories()
            tableView.reloadData()
        }

        private func setupTableView() {

            view.addSubview(tableView)

            tableView.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])

            tableView.register(UITableViewCell.self,
                               forCellReuseIdentifier: "CategoryCell")

            tableView.dataSource = self
            tableView.delegate = self
        }
    }

    extension CategoriesViewController: UITableViewDataSource {

        func tableView(_ tableView: UITableView,
                       numberOfRowsInSection section: Int) -> Int {

            categories.count
        }

        func tableView(_ tableView: UITableView,
                       cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            let cell = tableView.dequeueReusableCell(
                withIdentifier: "CategoryCell",
                for: indexPath
            )

            let category = categories[indexPath.row]

            var content = cell.defaultContentConfiguration()
            content.text = category.name
            content.secondaryText = "\(category.quotes.count) цитат"

            cell.contentConfiguration = content
            cell.accessoryType = .disclosureIndicator

            return cell
        }
    }

    extension CategoriesViewController: UITableViewDelegate {

        func tableView(_ tableView: UITableView,
                       didSelectRowAt indexPath: IndexPath) {

            tableView.deselectRow(at: indexPath, animated: true)

            let vc = CategoryQuotesViewController()

            vc.category = categories[indexPath.row]

            navigationController?.pushViewController(vc, animated: true)
        }
    }
