//
//  CategoryQuotesViewController.swift
//  QuoteDatabase
//
//  Created by Timur Zakirov on 24/07/26.
//

import UIKit
import RealmSwift

final class CategoryQuotesViewController: UIViewController {

    var category: Category!

    private let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = category.name
        view.backgroundColor = .systemBackground

        setupTableView()
    }

    private func setupTableView() {

        view.addSubview(tableView)

        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        tableView.register(QuoteTableViewCell.self,
                           forCellReuseIdentifier: QuoteTableViewCell.identifier)

        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
    }
}

extension CategoryQuotesViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {

        category.quotes.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: QuoteTableViewCell.identifier,
            for: indexPath
        ) as? QuoteTableViewCell else {

            return UITableViewCell()
        }

        let joke = category.quotes[indexPath.row]

        cell.configure(with: joke)

        return cell
    }
}
