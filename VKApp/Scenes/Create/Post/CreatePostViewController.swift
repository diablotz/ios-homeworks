//
//  CreatePostViewController.swift
//  VKApp
//
//  Created by Timur Zakirov on 02/10/26.
//

import UIKit

final class CreatePostViewController: UIViewController {

    private let viewModel: CreatePostViewModel

    private let textView: UITextView = {
        let textView = UITextView()
        textView.font = AppFonts.body
        textView.textColor = AppColors.primaryText
        textView.backgroundColor = AppColors.background
        textView.adjustsFontForContentSizeCategory = true
        textView.isScrollEnabled = true
        textView.textContainerInset = UIEdgeInsets(
            top: 16,
            left: 16,
            bottom: 16,
            right: 16
        )
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.string("create.whats_new")
        label.font = AppFonts.body
        label.textColor = AppColors.secondaryText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    init(viewModel: CreatePostViewModel) {
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
        setupLayout()
        bindViewModel()

        textView.becomeFirstResponder()
    }

    private func setupView() {
        view.backgroundColor = AppColors.background
        navigationItem.title = L10n.string("create.new_post")

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: L10n.string("common.publish"),
            style: .done,
            target: self,
            action: #selector(publishTapped)
        )

        textView.delegate = self

        view.addSubview(textView)
        textView.addSubview(placeholderLabel)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            textView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),
            textView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),
            textView.bottomAnchor.constraint(
                equalTo: view.keyboardLayoutGuide.topAnchor
            ),

            placeholderLabel.topAnchor.constraint(
                equalTo: textView.topAnchor,
                constant: 24
            ),
            placeholderLabel.leadingAnchor.constraint(
                equalTo: textView.leadingAnchor,
                constant: 21
            ),
            placeholderLabel.trailingAnchor.constraint(
                lessThanOrEqualTo: textView.trailingAnchor,
                constant: -21
            )
        ])
    }

    private func bindViewModel() {
        viewModel.onPostCreated = { [weak self] in
            self?.navigationController?
                .popViewController(animated: true)
        }

        viewModel.onError = { [weak self] message in
            self?.showError(message)
        }
    }

    private func showError(_ message: String) {
        let alert = UIAlertController(
            title: L10n.string("common.error"),
            message: message,
            preferredStyle: .alert
        )

        alert.addAction(
            UIAlertAction(title: L10n.string("common.ok"), style: .default)
        )

        present(alert, animated: true)
    }

    @objc private func publishTapped() {
        viewModel.createPost(
            text: textView.text
        )
    }
}

extension CreatePostViewController:
    UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden =
            !textView.text.isEmpty
    }
}
