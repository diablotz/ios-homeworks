//
//  CreateContentMenuViewController.swift
//  VKApp
//
//  Created by Timur Zakirov on 02/10/26.
//

import UIKit

final class CreateContentMenuViewController:
    UIViewController {

    var onSelect: ((CreateContentType) -> Void)?

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Создать"
        label.font = AppFonts.title
        label.textColor = AppColors.primaryText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.separator
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var stackView: UIStackView = {
        let buttons = CreateContentType.allCases.map {
            makeButton(for: $0)
        }

        let stackView = UIStackView(
            arrangedSubviews: buttons
        )
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = AppColors.background

        view.addSubview(titleLabel)
        view.addSubview(separatorView)
        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 12
            ),
            titleLabel.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: AppLayout.horizontalInset
            ),
            titleLabel.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -AppLayout.horizontalInset
            ),

            separatorView.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: 16
            ),
            separatorView.leadingAnchor.constraint(
                equalTo: titleLabel.leadingAnchor
            ),
            separatorView.trailingAnchor.constraint(
                equalTo: titleLabel.trailingAnchor
            ),
            separatorView.heightAnchor.constraint(
                equalToConstant: 1
            ),

            stackView.topAnchor.constraint(
                equalTo: separatorView.bottomAnchor,
                constant: 12
            ),
            stackView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: AppLayout.horizontalInset
            ),
            stackView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -AppLayout.horizontalInset
            ),
            stackView.bottomAnchor.constraint(
                lessThanOrEqualTo:
                    view.safeAreaLayoutGuide.bottomAnchor,
                constant: -12
            )
        ])
    }

    private func makeButton(
        for type: CreateContentType
    ) -> UIButton {
        var configuration = UIButton.Configuration.plain()
        configuration.title = type.title
        configuration.image = type.image
        configuration.imagePadding = 16
        configuration.baseForegroundColor =
            AppColors.primaryText
        configuration.contentInsets =
            NSDirectionalEdgeInsets(
                top: 13,
                leading: 4,
                bottom: 13,
                trailing: 4
            )

        let button = UIButton(configuration: configuration)
        button.contentHorizontalAlignment = .leading
        button.tag = CreateContentType.allCases.firstIndex(
            of: type
        ) ?? 0

        button.addTarget(
            self,
            action: #selector(contentButtonTapped),
            for: .touchUpInside
        )

        return button
    }

    @objc private func contentButtonTapped(
        _ sender: UIButton
    ) {
        let types = CreateContentType.allCases

        guard types.indices.contains(sender.tag) else {
            return
        }

        onSelect?(types[sender.tag])
    }
}
