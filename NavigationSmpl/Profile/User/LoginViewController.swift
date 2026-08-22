//
//  LoginViewController.swift
//  Navigation
//

import UIKit
import FirebaseAuth

final class LoginViewController: UIViewController {
    
    weak var coordinator: ProfileCoordinator?
    
    private let viewModel = LoginViewModel()
    
    let bruteForceService = BruteForce()
    
    // MARK: Visual content
    
    var loginDelegate: LoginViewControllerDelegate?
    
    var loginScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var vkLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "vkLogo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var loginStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.layer.borderColor = UIColor.lightGray.cgColor
        stack.layer.borderWidth = 0.5
        stack.layer.cornerRadius = LayoutConstants.cornerRadius
        stack.distribution = .fillProportionally
        stack.backgroundColor = .systemGray6
        stack.clipsToBounds = true
        return stack
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        if let pixel = UIImage(named: "blue_pixel") {
            button.setBackgroundImage(pixel.image(alpha: 1), for: .normal)
            button.setBackgroundImage(pixel.image(alpha: 0.8), for: .selected)
            button.setBackgroundImage(pixel.image(alpha: 0.6), for: .highlighted)
            button.setBackgroundImage(pixel.image(alpha: 0.4), for: .disabled)
        }

        button.setTitle("login_key".localized, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(touchLoginButton), for: .touchUpInside)
        button.layer.cornerRadius = LayoutConstants.cornerRadius
        button.clipsToBounds = true
        return button
    }()
    
    var loginField: UITextField = {
        let login = UITextField()
        login.translatesAutoresizingMaskIntoConstraints = false
        login.placeholder = "login_key".localized
        login.layer.borderColor = UIColor.lightGray.cgColor
        login.layer.borderWidth = 0.25
        login.leftViewMode = .always
        login.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: login.frame.height))
        login.keyboardType = .emailAddress
        login.textColor = .black
        login.font = UIFont.systemFont(ofSize: 16)
        login.autocapitalizationType = .none
        login.returnKeyType = .done
        
        return login
    }()
    
    var passwordField: UITextField = {
        let password = UITextField()
        password.translatesAutoresizingMaskIntoConstraints = false
        password.leftViewMode = .always
        password.placeholder = "password_key".localized
        password.layer.borderColor = UIColor.lightGray.cgColor
        password.layer.borderWidth = 0.25
        password.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: password.frame.height))
        password.isSecureTextEntry = true
        password.textColor = .black
        password.font = UIFont.systemFont(ofSize: 16)
        password.autocapitalizationType = .none
        password.returnKeyType = .done
        
        return password
    }()
 
    
    
    lazy var bruteForceButton = CustomButton(
        title: "bruteforce_password_key".localized,
        titleColor: .white,
        action: {
            [weak self] in
            self?.startBruteForce()
        },
        backgroundColor: .red,
        cornerRadius: LayoutConstants.cornerRadius
    )
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .systemBlue
        indicator.translatesAutoresizingMaskIntoConstraints = false
        
        indicator.hidesWhenStopped = true
        return indicator
    }()
   
    
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.isHidden = true
        
        setupViews()
        loginField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        passwordField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
    }
    
    private func setupViews() {
        view.addSubview(loginScrollView)
        loginScrollView.addSubview(contentView)
        
        contentView.addSubviews(vkLogo, loginStackView, loginButton, bruteForceButton, activityIndicator)
        
        loginStackView.addArrangedSubview(loginField)
        loginStackView.addArrangedSubview(passwordField)
        
        loginField.delegate = self
        passwordField.delegate = self
        
        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([

            loginScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            loginScrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            loginScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            loginScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: loginScrollView.topAnchor),
            contentView.trailingAnchor.constraint(equalTo: loginScrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: loginScrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: loginScrollView.leadingAnchor),
            contentView.centerXAnchor.constraint(equalTo: loginScrollView.centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: loginScrollView.centerYAnchor),

            vkLogo.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 120),
            vkLogo.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            vkLogo.heightAnchor.constraint(equalToConstant: 100),
            vkLogo.widthAnchor.constraint(equalToConstant: 100),

            loginStackView.topAnchor.constraint(equalTo: vkLogo.bottomAnchor, constant: 120),
            loginStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: LayoutConstants.leadingMargin),
            loginStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: LayoutConstants.trailingMargin),
            loginStackView.heightAnchor.constraint(equalToConstant: 100),

            loginButton.topAnchor.constraint(equalTo: loginStackView.bottomAnchor, constant: LayoutConstants.indent),
            loginButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: LayoutConstants.leadingMargin),
            loginButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: LayoutConstants.trailingMargin),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            
            bruteForceButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: LayoutConstants.indent),
            bruteForceButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: LayoutConstants.leadingMargin),
            bruteForceButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: LayoutConstants.trailingMargin),
            bruteForceButton.heightAnchor.constraint(equalToConstant: 50),
            
            activityIndicator.topAnchor.constraint(equalTo: bruteForceButton.bottomAnchor, constant: LayoutConstants.indent),
            activityIndicator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: LayoutConstants.leadingMargin),
            activityIndicator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: LayoutConstants.trailingMargin),
            activityIndicator.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(keyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        nc.addObserver(self, selector: #selector(keyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)

    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        let nc = NotificationCenter.default
        nc.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        nc.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    
    private func showLoginError(message: String) {
        let alert = UIAlertController(title: "error_key".localized, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
   
    
    private func openUserProfile() {
        guard let fireBaseUser = Auth.auth().currentUser else { return }
        
        let user = User(
            login: fireBaseUser.email ?? "",
            fullName: fireBaseUser.email ?? "",
            avatar: UIImage(named: "johnsmith"),
            status: "online_key".localized
        )

       
            coordinator?.openProfile(user: user)
        
    }
    
//    @objc private func touchLoginButton() {
//
//        guard
//            let email = loginField.text,
//            let password = passwordField.text
//        else { return }
//
//        guard !email.isEmpty, !password.isEmpty else {
//            showLoginError(message: "fill_fields_key".localized)
//            return
//        }
//
//        loginDelegate?.checkCredentials(email: email, password: password) { [weak self] result in
//
//            DispatchQueue.main.async {
//
//                switch result {
//
//                case .success:
//                    guard let self else { return }
//                    self.openUserProfile()
//                   
//
//                case .failure:
//
//                    self?.loginDelegate?.signUp(email: email, password: password) { result in
//
//                        DispatchQueue.main.async {
//
//                            switch result {
//
//                            case .success:
//                                guard let self else { return }
//                                self.openUserProfile()
//                                
//
//                            case .failure(let error):
//
//                                let nsError = error as NSError
//
//                                if nsError.code == AuthErrorCode.emailAlreadyInUse.rawValue {
//
//                                    self?.showLoginError(message: "password_wrong_key".localized)
//
//                                } else {
//
//                                    self?.showLoginError(message: error.localizedDescription)
//
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }

    @objc private func touchLoginButton() {
        guard
            let email = loginField.text,
            let password = passwordField.text
        else {
            return
        }

        guard viewModel.isValid(
            email: email,
            password: password
        ) else {
            showLoginError(message: "fill_fields_key".localized)
            return
        }


        loginDelegate?.checkCredentials(email: email, password: password) { [weak self] result in
        
            DispatchQueue.main.async {

                switch result {

                case .success:
                    guard let self else { return }
                    self.openUserProfile()


                case .failure:

                    self?.loginDelegate?.signUp(email: email, password: password) { result in

                        DispatchQueue.main.async {

                            switch result {

                            case .success:
                                guard let self else { return }
                                self.openUserProfile()


                            case .failure(let error):

                                let nsError = error as NSError

                                if nsError.code == AuthErrorCode.emailAlreadyInUse.rawValue {

                                    self?.showLoginError(message: "password_wrong_key".localized)

                                } else {

                                    self?.showLoginError(message: error.localizedDescription)

                                }
                            }
                        }
                    }
                }
            }
        }
    }



    @objc private func keyboardShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            loginScrollView.contentOffset.y = keyboardSize.height - (loginScrollView.frame.height - loginButton.frame.minY)
            loginScrollView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }

    @objc private func keyboardHide(notification: NSNotification) {
        loginScrollView.contentOffset = CGPoint(x: 0, y: 0)
    }
    
    
    private func startBruteForce() {
        
        let generatePassword = bruteForceService.generatePassword(length: 5)
        let startTime = CFAbsoluteTimeGetCurrent()
        activityIndicator.startAnimating()
        
        passwordField.isSecureTextEntry = true
        
        
        // старт подбюора не в Main thread
        DispatchQueue.global(qos: .userInitiated).async {
            [weak self] in
            guard let self else { return }
            
            let password = bruteForceService.bruteForce(password: generatePassword)
            let time = CFAbsoluteTimeGetCurrent() - startTime
            print("wasted_time_key".localized + " \(time)" + "seconds_key".localized)
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.passwordField.isEnabled = true
                self.passwordField.isSecureTextEntry = false
                self.passwordField.text = password
            }
        }
        
        
        
        
    }
    
    private func register(
        email: String,
        password: String
    ) {
        loginDelegate?.signUp(
            email: email,
            password: password)
        {
            [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.openUserProfile()
                
                case .failure(let error):
                    print(error)
                    print((error as NSError).code)
                    print((error as NSError).userInfo)
                    self?.showLoginError(message: error.localizedDescription)
                }
            }
        }
    }
    
    private func updateLoginButton() {
        let enabled =
        !(loginField.text ?? "").isEmpty && !(passwordField.text ?? "").isEmpty
        
        loginButton.isEnabled = enabled
    }
    
    @objc private func textChanged() {
        updateLoginButton()
    }
    
    
}

// MARK: - Extension

extension LoginViewController: UITextFieldDelegate {
    
    // tap 'done' on the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
