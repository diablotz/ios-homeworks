//
//  WelcomeViewController.swift
//  VKApp
//
//  Created by Timur Zakirov on 17/09/26.
//

import UIKit

final class WelcomeViewController: UIViewController {

    var onRegistration: (() -> Void)?
    var onLogin: (() -> Void)?

    // MARK: - UI

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = false
        scrollView.keyboardDismissMode = .interactive
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let illustrationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "welcomeIllustration")
        imageView.contentMode = .scaleAspectFit
        imageView.accessibilityLabel = "Иллюстрация приветствия"
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var registrationButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.title = "ЗАРЕГИСТРИРОВАТЬСЯ"
        configuration.baseBackgroundColor = AppColors.welcomeButton
        configuration.baseForegroundColor = .white
        configuration.cornerStyle = .medium

        let button = UIButton(configuration: configuration)
        button.titleLabel?.font = AppFonts.body
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.accessibilityHint = "Открывает регистрацию"
        button.translatesAutoresizingMaskIntoConstraints = false

        button.addTarget(
            self,
            action: #selector(registrationButtonTapped),
            for: .touchUpInside
        )

        return button
    }()

    private lazy var loginButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.title = "Уже есть аккаунт"
        configuration.baseForegroundColor = AppColors.primaryText

        let button = UIButton(configuration: configuration)
        button.titleLabel?.font = AppFonts.subheadline
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.accessibilityHint = "Открывает страницу входа"
        button.translatesAutoresizingMaskIntoConstraints = false

        button.addTarget(
            self,
            action: #selector(loginButtonTapped),
            for: .touchUpInside
        )

        return button
    }()

    private lazy var stackView: UIStackView = {
        let stack = UIStackView(
            arrangedSubviews: [
                illustrationImageView,
                registrationButton,
                loginButton
            ]
        )

        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = AppLayout.standardSpacing
        stack.setCustomSpacing(
            AppLayout.extraLargeSpacing,
            after: illustrationImageView
        )
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupLayout()
    }

    // MARK: - Setup

    private func setupView() {
        view.backgroundColor = AppColors.background

        navigationItem.backButtonDisplayMode = .minimal

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
    }

    private func setupLayout() {
        let centerYConstraint = stackView.centerYAnchor.constraint(
            equalTo: contentView.centerYAnchor
        )

        centerYConstraint.priority = .defaultHigh

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            scrollView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),
            scrollView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),
            scrollView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor
            ),

            contentView.topAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.topAnchor
            ),
            contentView.leadingAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.leadingAnchor
            ),
            contentView.trailingAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.trailingAnchor
            ),
            contentView.bottomAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.bottomAnchor
            ),

            contentView.widthAnchor.constraint(
                equalTo: scrollView.frameLayoutGuide.widthAnchor
            ),
            contentView.heightAnchor.constraint(
                greaterThanOrEqualTo: scrollView.frameLayoutGuide.heightAnchor
            ),

            stackView.topAnchor.constraint(
                greaterThanOrEqualTo: contentView.topAnchor,
                constant: AppLayout.largeSpacing
            ),
            stackView.bottomAnchor.constraint(
                lessThanOrEqualTo: contentView.bottomAnchor,
                constant: -AppLayout.largeSpacing
            ),
            stackView.centerXAnchor.constraint(
                equalTo: contentView.centerXAnchor
            ),
            centerYConstraint,

            stackView.leadingAnchor.constraint(
                greaterThanOrEqualTo: contentView.leadingAnchor,
                constant: AppLayout.horizontalInset
            ),
            stackView.trailingAnchor.constraint(
                lessThanOrEqualTo: contentView.trailingAnchor,
                constant: -AppLayout.horizontalInset
            ),
            stackView.widthAnchor.constraint(
                lessThanOrEqualToConstant:
                    AppLayout.compactContentMaximumWidth
            ),

            illustrationImageView.heightAnchor.constraint(
                equalTo: illustrationImageView.widthAnchor,
                multiplier: 0.78
            ),

            registrationButton.heightAnchor.constraint(
                greaterThanOrEqualToConstant: AppLayout.buttonHeight
            ),
            loginButton.heightAnchor.constraint(
                greaterThanOrEqualToConstant:
                    AppLayout.minimumTouchSize
            )
        ])
    }

    // MARK: - Actions

    @objc private func registrationButtonTapped() {
        onRegistration?()
    }

    @objc private func loginButtonTapped() {
        onLogin?()
    }
}

