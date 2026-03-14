//
//  LogInViewController.swift
//  Navigation
//
//  Created by Timur Zakirov on 11/03/26.
//

import UIKit

class LogInViewController: UIViewController {

    // interface
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        //scrollView.backgroundColor = .red
        //scrollView.layer.borderWidth = 5
        //scrollView.layer.borderColor = UIColor.blue.cgColor
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        //view.backgroundColor = .green
        //view.layer.borderWidth = 5
        //view.layer.borderColor = UIColor.blue.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var vkLogoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .vk)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
        
    }()
    
    private lazy var loginFormStackView: UIStackView = {
            let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0.5
        stackView.layer.cornerRadius = 10
        stackView.layer.backgroundColor = UIColor.systemGray6.cgColor
        stackView.layer.borderColor = UIColor.lightGray.cgColor
        stackView.layer.borderWidth = 0.5
        stackView.clipsToBounds = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    } ()
    
    
    private lazy var loginTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email of phone"
        textField.textColor = .black
        textField.font = .systemFont(ofSize: 16, weight: .regular)
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.keyboardType = .default
        textField.returnKeyType = .done
        textField.tintColor = UIColor(named: "loginColor")
        
        return textField
        
    }()
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.textColor = .black
        textField.font = .systemFont(ofSize: 16, weight: .regular)
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.keyboardType = .default
        textField.returnKeyType = .done
        textField.isSecureTextEntry = true
        textField.tintColor = UIColor(named: "loginColor")
        
        return textField
    } ()
    
    private lazy var loginButton: UIButton = {
        let loginBtn = UIButton(type: .system)
        loginBtn.setTitle("Log In", for: .normal)
        loginBtn.setTitleColor(.white, for: .normal)
        let backImage = UIImage(resource: .bluePixel)
        loginBtn.setBackgroundImage(backImage, for: .normal)
        loginBtn.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        loginBtn.clipsToBounds = true
        loginBtn.translatesAutoresizingMaskIntoConstraints = false
        loginBtn.layer.cornerRadius = 10
        loginBtn.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        //loginBtn.alpha = 1.0
        return loginBtn
    } ()
    
    
    
    
    // lifecicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        //navigationController?.navigationBar.isHidden = true
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //navigationController?.navigationBar.isHidden = true
        //print(navigationController)
        navigationController?.setNavigationBarHidden(true, animated: true)
        setupKeyboardObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardObservers()
    }
    
    // setup layout

    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(vkLogoImage)
        contentView.addSubview(loginFormStackView)
        contentView.addSubview(loginButton)
//        scrollView.addSubview(vkLogoImage)
//        scrollView.addSubview(loginFormStackView)
//        scrollView.addSubview(loginButton)
        
        loginFormStackView.addArrangedSubview(loginTextField)
        loginFormStackView.addArrangedSubview(separatorView)
        loginFormStackView.addArrangedSubview(passwordTextField)
        
//        vkLogoImage.translatesAutoresizingMaskIntoConstraints = false
//        loginFormStackView.translatesAutoresizingMaskIntoConstraints = false
//        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            //scrollView
            scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            //scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            scrollView.widthAnchor.constraint(equalTo: safeArea.widthAnchor),
            // content
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            
            // Logo
            vkLogoImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 120),
            vkLogoImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            vkLogoImage.widthAnchor.constraint(equalToConstant: 100),
            vkLogoImage.heightAnchor.constraint(equalToConstant: 100),
            
            // container
            loginFormStackView.topAnchor.constraint(equalTo: vkLogoImage.bottomAnchor, constant: 120),
            loginFormStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            //
            loginFormStackView.heightAnchor.constraint(equalToConstant: 100),
            loginFormStackView.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -32),
            //loginFormStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            
            // parts of container
//            loginTextField.topAnchor.constraint(equalTo: loginFormStackView.topAnchor),
              loginTextField.heightAnchor.constraint(equalToConstant: 50),
              loginTextField.leadingAnchor.constraint(equalTo: loginFormStackView.leadingAnchor, constant: 10),
//            loginTextField.trailingAnchor.constraint(equalTo: loginFormStackView.trailingAnchor, constant: -10),
//            
//            separatorView.topAnchor.constraint(equalTo: loginTextField.bottomAnchor),
//            separatorView.heightAnchor.constraint(equalToConstant: 0.5),
              separatorView.leadingAnchor.constraint(equalTo: loginFormStackView.leadingAnchor),
//            separatorView.trailingAnchor.constraint(equalTo: loginFormStackView.trailingAnchor),
//            
//            passwordTextField.topAnchor.constraint(equalTo: separatorView.bottomAnchor),
              passwordTextField.heightAnchor.constraint(equalToConstant: 49.5),
              passwordTextField.leadingAnchor.constraint(equalTo: loginFormStackView.leadingAnchor, constant: 10),
//            passwordTextField.trailingAnchor.constraint(equalTo: loginFormStackView.trailingAnchor, constant: -10),
            
            // button
            loginButton.topAnchor.constraint(equalTo: loginFormStackView.bottomAnchor, constant: 16),
            loginButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            loginButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -32),
            loginButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    // actions
    @objc private func loginButtonTapped() {
        //print("Hello!!!")
        let profileVC = ProfileViewController()
        navigationController?.pushViewController(profileVC, animated: true)
    }
    @objc func willShowKeyboard(_ notification: NSNotification) {
        let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height
        scrollView.contentInset.bottom += keyboardHeight ?? 0.0
    }
    
    @objc func willHideKeyboard(_ notification: NSNotification) {
        scrollView.contentInset.bottom = 0.0
    }
    
    // keyboard
    private func setupKeyboardObservers() {
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(
            self,
            selector: #selector(self.willShowKeyboard(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        notificationCenter.addObserver(
            self,
            selector: #selector(self.willHideKeyboard(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func removeKeyboardObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self)
    }
     
 

}

extension LogInViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(
        _ textField: UITextField
    ) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}
