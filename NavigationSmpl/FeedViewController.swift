//
//  FeedViewController.swift
//  Navigation
//

import UIKit
//import StorageService

final class FeedViewController: UIViewController {
    
    weak var coordinator: FeedCoordinator?
    
    //let safeArea = self.view.safeAreaLayoutGuide
    private lazy var passwordTextField: UITextField = {
        let passwordText = UITextField()
        passwordText.textColor = .systemBlue
        passwordText.backgroundColor = .white
        passwordText.translatesAutoresizingMaskIntoConstraints = false
        passwordText.placeholder = "enter_password_key".localized
        passwordText.autocapitalizationType = .none
        passwordText.autocorrectionType = .no
        //NSLayoutConstraint.activate([
         //   passwordText.topAnchor.constraint(equalTo: <#T##NSLayoutAnchor<NSLayoutYAxisAnchor>#>, constant: <#T##CGFloat#>)
        //])
        
        return passwordText
    }()
    private lazy var checkGuessButton = CustomButton(title: "password_check_key".localized, titleColor: .white, action: {
        [weak self] in
        //guard let self else {return}
        self?.checkPassword()
        }, backgroundColor: .systemBlue, cornerRadius: LayoutConstants.cornerRadius)
    
    private lazy var checkPasswordStatusLabel: UILabel = {
        let checkLabel = UILabel()
        checkLabel.text = ""
        checkLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        return checkLabel
    }()
    
    
    //var feedModel = FeedModel()
    var viewModel = FeedViewModel(model: FeedModel())

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemTeal
        view.addSubview(passwordTextField)
        view.addSubview(checkGuessButton)
        view.addSubview(checkPasswordStatusLabel)
        setupConstraints()
        createSubView()
        
    }
    
    private func checkPassword() {
        guard let passw = passwordTextField.text, !passw.isEmpty else {
            checkPasswordStatusLabel.text = "enter_password_key".localized
            checkPasswordStatusLabel.textColor = .systemRed
            return
        }
        //let isCorrect = feedModel.check(word: passw)
        let result = viewModel.check(passw: passwordTextField.text)
        checkPasswordStatusLabel.text = result.text
        checkPasswordStatusLabel.textColor = result.color
    }
    
    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            passwordTextField.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 16),
            passwordTextField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            passwordTextField.heightAnchor.constraint(equalToConstant: 30),
            passwordTextField.widthAnchor.constraint(equalTo: safeArea.widthAnchor, constant: -32),
            
            checkGuessButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            checkGuessButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            checkGuessButton.widthAnchor.constraint(equalTo: safeArea.widthAnchor, constant: -32),
            checkGuessButton.heightAnchor.constraint(equalToConstant: 30),
            
            checkPasswordStatusLabel.topAnchor.constraint(equalTo: checkGuessButton.bottomAnchor, constant: 20),
            //checkPasswordStatusLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            checkPasswordStatusLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            //checkPasswordStatusLabel.widthAnchor.constraint(equalTo: safeArea.widthAnchor, constant: -32)
            
        ])
    }
    
    private func createSubView() {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 200),
            stackView.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, constant: -32)
        ])
        //addPostButton(title: "Post number One", color: .systemPurple, to: stackView, selector: #selector(tapPostButton))
        //addPostButton(title: "Post number Two", color: .systemIndigo, to: stackView, selector: #selector(tapPostButton))
        addPostButton(title: "post_number_one_key".localized, color: .systemPurple, to: stackView)
        addPostButton(title: "post_number_two_key".localized, color: .systemIndigo, to: stackView)
    }
    
    //private func addPostButton(title: String, color: UIColor, to view: UIStackView, selector: Selector) {
    private func addPostButton(title: String, color: UIColor, to view: UIStackView) {
        //let button = UIButton()
        //button.translatesAutoresizingMaskIntoConstraints = false
        //button.setTitle(title, for: .normal)
        //button.backgroundColor = color
        //button.setTitleColor(.white, for: .normal)
        //button.layer.cornerRadius = LayoutConstants.cornerRadius
        //button.addTarget(self, action: selector, for: .touchUpInside)
        let button = CustomButton(title: title, titleColor: .white, action: {
            [weak self] in
            guard let self else {return}
            //self.statusLabel.text = self.statusText
            //let post = postExamples[0]
            
            let post = viewModel.post(at: 0)
            
            let postVC = PostViewController()
            postVC.post = post
            //navigationController?.pushViewController(postVC, animated: true)
            
            coordinator?.openPost(post)
            
        }, backgroundColor: color, cornerRadius: LayoutConstants.cornerRadius)
        view.addArrangedSubview(button)
    }
    /*
    @objc func tapPostButton() {
        let post = postExamples[0]
        
        let postVC = PostViewController()
        postVC.post = post
        navigationController?.pushViewController(postVC, animated: true)
    }
     */
}
