//
//  ChatViewController.swift
//  VKApp
//
//  Created by Timur Zakirov on 02/10/26.
//

import UIKit

final class ChatViewController: UIViewController {

    private let viewModel: ChatViewModel

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = AppColors.background
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 70
        tableView.keyboardDismissMode = .interactive
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private let inputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.background
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Сообщение"
        textField.backgroundColor =
            AppColors.secondaryBackground
        textField.layer.cornerRadius = 18
        textField.setLeftPadding(12)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(
            UIImage(systemName: "arrow.up.circle.fill"),
            for: .normal
        )
        button.tintColor = AppColors.vkBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(
            self,
            action: #selector(sendTapped),
            for: .touchUpInside
        )
        return button
    }()

    init(viewModel: ChatViewModel) {
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
        navigationItem.title = viewModel.title

        tableView.dataSource = self
        tableView.register(
            MessageTableViewCell.self,
            forCellReuseIdentifier:
                MessageTableViewCell.reuseIdentifier
        )

        view.addSubview(tableView)
        view.addSubview(inputContainerView)
        inputContainerView.addSubview(textField)
        inputContainerView.addSubview(sendButton)

        NSLayoutConstraint.activate([
            inputContainerView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),
            inputContainerView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),
            inputContainerView.bottomAnchor.constraint(
                equalTo: view.keyboardLayoutGuide.topAnchor
            ),

            textField.topAnchor.constraint(
                equalTo: inputContainerView.topAnchor,
                constant: 8
            ),
            textField.leadingAnchor.constraint(
                equalTo: inputContainerView.leadingAnchor,
                constant: 12
            ),
            textField.bottomAnchor.constraint(
                equalTo: inputContainerView.bottomAnchor,
                constant: -8
            ),
            textField.heightAnchor.constraint(
                greaterThanOrEqualToConstant: 40
            ),

            sendButton.leadingAnchor.constraint(
                equalTo: textField.trailingAnchor,
                constant: 8
            ),
            sendButton.trailingAnchor.constraint(
                equalTo: inputContainerView.trailingAnchor,
                constant: -12
            ),
            sendButton.centerYAnchor.constraint(
                equalTo: textField.centerYAnchor
            ),
            sendButton.widthAnchor.constraint(
                equalToConstant: 42
            ),
            sendButton.heightAnchor.constraint(
                equalToConstant: 42
            ),

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
                equalTo: inputContainerView.topAnchor
            )
        ])

        viewModel.onDataChanged = { [weak self] in
            self?.tableView.reloadData()
            self?.scrollToBottom()
        }

        viewModel.onError = { [weak self] message in
            self?.showError(message)
        }

        viewModel.loadMessages()
    }

    @objc private func sendTapped() {
        let text = textField.text ?? ""

        if viewModel.send(text: text) {
            textField.text = nil
        }
    }

    private func scrollToBottom() {
        guard !viewModel.messages.isEmpty else {
            return
        }

        tableView.scrollToRow(
            at: IndexPath(
                row: viewModel.messages.count - 1,
                section: 0
            ),
            at: .bottom,
            animated: true
        )
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

extension ChatViewController: UITableViewDataSource {

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        viewModel.messages.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier:
                MessageTableViewCell.reuseIdentifier,
            for: indexPath
        ) as! MessageTableViewCell

        cell.configure(
            with: viewModel.messages[indexPath.row]
        )

        return cell
    }
}
