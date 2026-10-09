//
//  FriendViewController.swift
//  VKApp
//
//  Created by Timur Zakirov on 01/10/26.
//

import UIKit

final class FriendsViewController: UIViewController {

    var onSelectFriend: ((UUID) -> Void)?

    private let viewModel: FriendsViewModel

    private let searchController = UISearchController(
        searchResultsController: nil
    )

    private let tableView: UITableView = {
        let tableView = UITableView(
            frame: .zero,
            style: .plain
        )

        tableView.backgroundColor = AppColors.background
        tableView.separatorInset = UIEdgeInsets(
            top: 0,
            left: 90,
            bottom: 0,
            right: 0
        )
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        tableView.keyboardDismissMode = .onDrag
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "Друзья не найдены"
        label.font = AppFonts.body
        label.textColor = AppColors.secondaryText
        label.textAlignment = .center
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    init(viewModel: FriendsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is unavailable")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupTableView()
        setupSearchController()
        setupLayout()
        bindViewModel()

        viewModel.loadFriends()
    }

    private func setupView() {
        view.backgroundColor = AppColors.background
        navigationItem.title = "Друзья"

        view.addSubview(tableView)
        view.addSubview(emptyLabel)
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self

        tableView.register(
            FriendTableViewCell.self,
            forCellReuseIdentifier:
                FriendTableViewCell.reuseIdentifier
        )
    }

    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск друзей"

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false

        definesPresentationContext = true
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            tableView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),
            tableView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),
            tableView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor
            ),

            emptyLabel.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            emptyLabel.centerYAnchor.constraint(
                equalTo: view.centerYAnchor
            )
        ])
    }

    private func bindViewModel() {
        viewModel.onDataChanged = { [weak self] in
            guard let self else {
                return
            }

            tableView.reloadData()
            emptyLabel.isHidden = !viewModel.friends.isEmpty
        }

        viewModel.onError = { [weak self] message in
            self?.showError(message)
        }
    }

    private func showError(_ message: String) {
        let alert = UIAlertController(
            title: "Ошибка",
            message: message,
            preferredStyle: .alert
        )

        alert.addAction(
            UIAlertAction(title: "ОК", style: .default)
        )

        present(alert, animated: true)
    }
}



extension FriendsViewController: UITableViewDataSource {

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        viewModel.friends.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier:
                    FriendTableViewCell.reuseIdentifier,
                for: indexPath
            ) as? FriendTableViewCell
        else {
            return UITableViewCell()
        }

        cell.configure(
            with: viewModel.friends[indexPath.row]
        )

        return cell
    }
}



extension FriendsViewController: UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(
            at: indexPath,
            animated: true
        )

        guard let friend = viewModel.friend(
            at: indexPath.row
        ) else {
            return
        }

        onSelectFriend?(friend.id)
    }
}



extension FriendsViewController: UISearchResultsUpdating {

    func updateSearchResults(
        for searchController: UISearchController
    ) {
        viewModel.search(
            text: searchController.searchBar.text ?? ""
        )
    }
}
