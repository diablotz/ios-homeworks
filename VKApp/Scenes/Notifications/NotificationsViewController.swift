//
//  NotificationsViewController.swift
//  VKApp
//
//  Created by Timur Zakirov on 02/10/26.
//

import UIKit

final class NotificationsViewController:
    UIViewController {

    private let viewModel: NotificationsViewModel

    private let tableView: UITableView = {
        let tableView = UITableView(
            frame: .zero,
            style: .plain
        )

        tableView.backgroundColor = AppColors.background
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        tableView.separatorInset = UIEdgeInsets(
            top: 0,
            left: 84,
            bottom: 0,
            right: 0
        )
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "Уведомлений пока нет"
        label.font = AppFonts.body
        label.textColor = AppColors.secondaryText
        label.textAlignment = .center
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    init(viewModel: NotificationsViewModel) {
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
        setupLayout()
        bindViewModel()

        viewModel.loadNotifications()
    }

    private func setupView() {
        view.backgroundColor = AppColors.background
        navigationItem.title = "Уведомления"

        view.addSubview(tableView)
        view.addSubview(emptyLabel)
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self

        tableView.register(
            NotificationTableViewCell.self,
            forCellReuseIdentifier:
                NotificationTableViewCell.reuseIdentifier
        )
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
            emptyLabel.isHidden =
                !viewModel.notifications.isEmpty
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



extension NotificationsViewController:
    UITableViewDataSource {

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        viewModel.notifications.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier:
                    NotificationTableViewCell.reuseIdentifier,
                for: indexPath
            ) as? NotificationTableViewCell
        else {
            return UITableViewCell()
        }

        cell.configure(
            with: viewModel.notifications[indexPath.row]
        )

        return cell
    }

    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt
        indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: "Удалить"
        ) { [weak self] _, _, completion in
            self?.viewModel.delete(at: indexPath.row)
            completion(true)
        }

        deleteAction.image = UIImage(
            systemName: "trash"
        )

        let configuration = UISwipeActionsConfiguration(
            actions: [deleteAction]
        )
        configuration.performsFirstActionWithFullSwipe = true

        return configuration
    }
}



extension NotificationsViewController:
    UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(
            at: indexPath,
            animated: true
        )

        viewModel.markAsRead(at: indexPath.row)
    }
}
