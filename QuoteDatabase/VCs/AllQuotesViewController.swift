//
//  AllQuotesViewController.swift
//  QuoteDatabase
//
//  Created by Timur Zakirov on 24/07/26.
//

import UIKit
import RealmSwift

class AllQuotesViewController: UIViewController {

    weak var coordinator: AllQuotesCoordinator?
    
    private let tableView = UITableView()

    private var quotes: Results<Quote>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Все цитаты"
        
        
        setupTableView()

        quotes = RealmManager.shared.getAllQuotes()
    }
    

    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            tableView.reloadData()
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

            tableView.register(QuoteTableViewCell.self, forCellReuseIdentifier: QuoteTableViewCell.identifier)

            tableView.dataSource = self
            tableView.delegate = self

            tableView.rowHeight = UITableView.automaticDimension
            tableView.estimatedRowHeight = 120
        }
    }

    extension AllQuotesViewController: UITableViewDataSource {

        func tableView(_ tableView: UITableView,
                       numberOfRowsInSection section: Int) -> Int {

            quotes.count
        }

        func tableView(_ tableView: UITableView,
                       cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: QuoteTableViewCell.identifier,
                for: indexPath
            ) as? QuoteTableViewCell else {
                return UITableViewCell()
            }

            let joke = quotes[indexPath.row]

            cell.configure(with: joke)

            return cell
        }
    }

    extension AllQuotesViewController: UITableViewDelegate {

    }
