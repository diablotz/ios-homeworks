//
//  LoginViewController.swift
//  VKApp
//
//  Created by Timur Zakirov on 17/09/26.
//


import UIKit

final class LoginViewController: UIViewController {

    var onAuthenticationSuccess: ((AppUser) -> Void)?

    private let viewModel: LoginViewModel

   
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.keyboardDismissMode = .interactive
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.title
        label.textColor = AppColors.registrationAccent
        label.textAlignment = .center
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.body
        label.textColor = AppColors.secondaryText
        label.textAlignment = .left
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let phoneTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "+998 90 123 45 67"
        textField.font = AppFonts.body
        textField.textColor = AppColors.primaryText
        textField.textAlignment = .center
        textField.keyboardType = .phonePad
        textField.textContentType = .telephoneNumber
        textField.returnKeyType = .done
        textField.clearButtonMode = .whileEditing
        textField.layer.borderWidth = 1
        textField.layer.borderColor =
            AppColors.secondaryText.cgColor
        textField.layer.cornerRadius = AppLayout.cornerRadius
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let errorLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.caption
        label.textColor = AppColors.destructive
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = true
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var submitButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = AppColors.welcomeButton
        configuration.baseForegroundColor = .white
        configuration.cornerStyle = .medium

        let button = UIButton(configuration: configuration)
        button.titleLabel?.font = AppFonts.body
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.translatesAutoresizingMaskIntoConstraints = false

        button.addTarget(
            self,
            action: #selector(submitButtonTapped),
            for: .touchUpInside
        )

        return button
    }()

    private lazy var formStackView: UIStackView = {
        let stack = UIStackView(
            arrangedSubviews: [
                titleLabel,
                subtitleLabel,
                phoneTextField,
                errorLabel,
                submitButton
            ]
        )

        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = AppLayout.standardSpacing
        stack.setCustomSpacing(
            AppLayout.largeSpacing,
            after: subtitleLabel
        )
        stack.setCustomSpacing(
            AppLayout.extraLargeSpacing,
            after: errorLabel
        )
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    

    init(viewModel: LoginViewModel) {
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
        configureContent()
        bindViewModel()
        observeKeyboard()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    

    private func setupView() {
        view.backgroundColor = AppColors.background

        navigationController?.setNavigationBarHidden(
            false,
            animated: false
        )
        navigationItem.backButtonDisplayMode = .minimal

        phoneTextField.delegate = self

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(formStackView)

        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(backgroundTapped)
        )
        view.addGestureRecognizer(tapGesture)
    }

    private func configureContent() {
        titleLabel.text = viewModel.content.title
        subtitleLabel.text = viewModel.content.subtitle

        submitButton.configuration?.title =
            viewModel.content.buttonTitle
    }

    private func setupLayout() {
        let centerY = formStackView.centerYAnchor.constraint(
            equalTo: contentView.centerYAnchor,
            constant: -40
        )
        centerY.priority = .defaultHigh

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
                equalTo: view.bottomAnchor
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
                greaterThanOrEqualTo:
                    scrollView.frameLayoutGuide.heightAnchor
            ),

            formStackView.centerXAnchor.constraint(
                equalTo: contentView.centerXAnchor
            ),
            centerY,

            formStackView.topAnchor.constraint(
                greaterThanOrEqualTo: contentView.topAnchor,
                constant: AppLayout.largeSpacing
            ),
            formStackView.bottomAnchor.constraint(
                lessThanOrEqualTo: contentView.bottomAnchor,
                constant: -AppLayout.largeSpacing
            ),
            formStackView.leadingAnchor.constraint(
                greaterThanOrEqualTo: contentView.leadingAnchor,
                constant: AppLayout.horizontalInset
            ),
            formStackView.trailingAnchor.constraint(
                lessThanOrEqualTo: contentView.trailingAnchor,
                constant: -AppLayout.horizontalInset
            ),
            formStackView.widthAnchor.constraint(
                lessThanOrEqualToConstant:
                    AppLayout.compactContentMaximumWidth
            ),

            phoneTextField.heightAnchor.constraint(
                greaterThanOrEqualToConstant: 52
            ),
            submitButton.heightAnchor.constraint(
                greaterThanOrEqualToConstant:
                    AppLayout.buttonHeight
            )
        ])
    }

    private func bindViewModel() {
        viewModel.onError = { [weak self] message in
            self?.showError(message)
        }

        viewModel.onSuccess = { [weak self] user in
            self?.errorLabel.isHidden = true
            self?.onAuthenticationSuccess?(user)
        }
    }

    

    private func observeKeyboard() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillChangeFrame),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    @objc private func keyboardWillChangeFrame(
        _ notification: Notification
    ) {
        guard
            let frame = notification.userInfo?[
                UIResponder.keyboardFrameEndUserInfoKey
            ] as? CGRect
        else {
            return
        }

        let convertedFrame = view.convert(frame, from: nil)
        let overlap = max(
            0,
            view.bounds.maxY - convertedFrame.minY
        )

        scrollView.contentInset.bottom = overlap
        scrollView.verticalScrollIndicatorInsets.bottom = overlap
    }

    @objc private func keyboardWillHide() {
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets.bottom = 0
    }

    

    @objc private func submitButtonTapped() {
        view.endEditing(true)
        errorLabel.isHidden = true

        viewModel.submit(
            phone: phoneTextField.text ?? ""
        )
    }

    @objc private func backgroundTapped() {
        view.endEditing(true)
    }

    private func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
    }
}



extension LoginViewController: UITextFieldDelegate {

    func textFieldShouldReturn(
        _ textField: UITextField
    ) -> Bool {
        textField.resignFirstResponder()
        submitButtonTapped()
        return true
    }
}


//import UIKit
//
//
//
//final class LoginViewController: UIViewController {
//
//    private let mode: LoginMode
//
//    private let titleLabel: UILabel = {
//        let label = UILabel()
//        label.font = AppFonts.title
//        label.textColor = AppColors.registrationAccent
//        label.textAlignment = .center
//        label.numberOfLines = 0
//        label.adjustsFontForContentSizeCategory = true
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//
//    init(mode: LoginMode) {
//        self.mode = mode
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    @available(*, unavailable)
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) is unavailable")
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        view.backgroundColor = AppColors.background
//
//        titleLabel.text = switch mode {
//        case .login:
//            "С возвращением"
//        case .registration:
//            "Регистрация"
//        }
//
//        view.addSubview(titleLabel)
//
//        NSLayoutConstraint.activate([
//            titleLabel.centerXAnchor.constraint(
//                equalTo: view.centerXAnchor
//            ),
//            titleLabel.centerYAnchor.constraint(
//                equalTo: view.centerYAnchor
//            ),
//            titleLabel.leadingAnchor.constraint(
//                greaterThanOrEqualTo: view.leadingAnchor,
//                constant: AppLayout.horizontalInset
//            ),
//            titleLabel.trailingAnchor.constraint(
//                lessThanOrEqualTo: view.trailingAnchor,
//                constant: -AppLayout.horizontalInset
//            )
//        ])
//    }
//}
//
