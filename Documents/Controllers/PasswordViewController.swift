//
//  PasswordViewController.swift
//  Documents
//
//  Created by Timur Zakirov on 18/07/26.
//

import UIKit
import KeychainAccess

final class PasswordViewController: UIViewController {
    
    enum PasswordMode {
        case login
        case create
        case change
    }

    // MARK: - UI

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 26)
        return label
    }()

    private let passwordField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.borderStyle = .roundedRect
        field.placeholder = "Пароль"
        field.isSecureTextEntry = true
        return field
    }()

    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = .filled()
        return button
    }()

    private let mode: PasswordMode
    
    init(mode: PasswordMode) {
        self.mode = mode
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties

    private let keychain = Keychain(service: "DocumentsApp")

    private var firstPassword: String?

    private var hasPassword: Bool {
        //(try? keychain.get("password")) != nil
        mode == .login
    }

    // MARK: -

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        switch mode {
            
        case .login:
            if keychain["password"] == nil {
                titleLabel.text = "Создайте пароль"
                actionButton.setTitle("СОздать пароль", for: .normal)
            }
            else {
                titleLabel.text = "Введите пароль"
                actionButton.setTitle("Введите пароль", for: .normal)
            }
            
        case .create, .change:
            titleLabel.text = "Создайте пароль"
            actionButton.setTitle("СОздать пароль", for: .normal)
            
        }
        
        setupViews()
        updateState()

        actionButton.addTarget(
            self,
            action: #selector(buttonPressed),
            for: .touchUpInside
        )
    }

    private func setupViews() {

        view.addSubview(titleLabel)
        view.addSubview(passwordField)
        view.addSubview(actionButton)

        NSLayoutConstraint.activate([

            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            passwordField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            passwordField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            passwordField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),

            actionButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 30),
            actionButton.leadingAnchor.constraint(equalTo: passwordField.leadingAnchor),
            actionButton.trailingAnchor.constraint(equalTo: passwordField.trailingAnchor),
            actionButton.heightAnchor.constraint(equalToConstant: 50)

        ])
    }

    // MARK: -

    private func updateState() {

        if hasPassword {

            titleLabel.text = "Введите пароль"
            actionButton.setTitle("Введите пароль", for: .normal)

        } else {

            if firstPassword == nil {

                titleLabel.text = "Создайте пароль"
                actionButton.setTitle("Создать пароль", for: .normal)

            } else {

                titleLabel.text = "Повторите пароль"
                actionButton.setTitle("Повторите пароль", for: .normal)

            }

        }

        passwordField.text = ""
    }

    // MARK: -

    @objc
    private func buttonPressed() {

        guard let password = passwordField.text else { return }

        switch mode {

        case .login:

            if keychain["password"] == nil {

                createPassword(password)

            } else {

                checkPassword(password)

            }

        case .create:

            createPassword(password)

        case .change:

            changePassword(password)
        }

    }

    // MARK: - Create

    private func createPassword(_ password: String) {

        guard password.count >= 4 else {

            showAlert("Пароль должен содержать минимум 4 символа")
            return

        }

        if firstPassword == nil {

            firstPassword = password
            updateState()

        } else {

            if firstPassword == password {

                try? keychain.set(password, key: "password")
                openApplication()

            } else {

                firstPassword = nil

                showAlert("Пароли не совпадают")

                updateState()

            }

        }

    }

    // MARK: - Check

    private func checkPassword(_ password: String) {

        let saved = try? keychain.get("password")

        if saved == password {

            openApplication()

        } else {

            showAlert("Неверный пароль")

        }

    }
    
    // MARK: - Change
    
    private func changePassword(_ password: String) {

        guard password.count >= 4 else {

            showAlert("Минимум 4 символа")
            return
        }

        if firstPassword == nil {

            firstPassword = password

            titleLabel.text = "Повторите пароль"
            actionButton.setTitle(
                "Повторите пароль",
                for: .normal
            )

            passwordField.text = ""

        } else {

            if firstPassword == password {

                try? keychain.set(password, key: "password")

                dismiss(animated: true)

            } else {

                firstPassword = nil

                titleLabel.text = "Создайте пароль"
                actionButton.setTitle(
                    "Создать пароль",
                    for: .normal
                )

                passwordField.text = ""

                showAlert("Пароли не совпадают")
            }
        }
    }

    // MARK: -

    private func openApplication() {

        let files = UINavigationController(
            rootViewController: MainViewController()
        )

        files.tabBarItem = UITabBarItem(
            title: "Files",
            image: UIImage(systemName: "folder"),
            tag: 0
        )

        let settings = UINavigationController(
            rootViewController: SettingsViewController()
        )

        settings.tabBarItem = UITabBarItem(
            title: "Settings",
            image: UIImage(systemName: "gearshape"),
            tag: 1
        )

        let tabBar = UITabBarController()
        tabBar.viewControllers = [files, settings]

        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = scene.windows.first {

            window.rootViewController = tabBar

        }

    }

    // MARK: -

    private func showAlert(_ text: String) {

        let alert = UIAlertController(
            title: "Ошибка",
            message: text,
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "OK", style: .default))

        present(alert, animated: true)

    }

}
