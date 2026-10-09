//
//  MessengerViewController.swift
//  VKApp
//
//  Created by Timur Zakirov on 24/09/26.
//

import UIKit

final class MessengerViewController: UIViewController {

    var onSelectConversation: ((ConversationItem) -> Void)?

    private let viewModel: MessengerViewModel

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 84
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    init(viewModel: MessengerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is unavailable")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = AppColors.background
        navigationItem.title = "Мессенджер"

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(
            ConversationTableViewCell.self,
            forCellReuseIdentifier:
                ConversationTableViewCell.reuseIdentifier
        )

        view.addSubview(tableView)

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
            )
        ])

        viewModel.onDataChanged = { [weak self] in
            self?.tableView.reloadData()
        }

        viewModel.onError = { [weak self] message in
            self?.showError(message)
        }

        viewModel.loadConversations()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadConversations()
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

extension MessengerViewController:
    UITableViewDataSource,
    UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        viewModel.conversations.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier:
                ConversationTableViewCell.reuseIdentifier,
            for: indexPath
        ) as! ConversationTableViewCell

        cell.configure(
            with: viewModel.conversations[indexPath.row]
        )

        return cell
    }

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(
            at: indexPath,
            animated: true
        )

        guard let conversation =
            viewModel.conversation(at: indexPath.row)
        else {
            return
        }

        onSelectConversation?(conversation)
    }
}

