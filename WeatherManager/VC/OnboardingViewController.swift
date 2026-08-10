//
//  OnboardingViewController.swift
//  WeatherManager
//
//  Created by Timur Zakirov on 04/08/26.
//

import UIKit
import CoreLocation

final class OnboardingViewController: UIViewController {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Добро пожаловать"
        label.font = .boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Разрешите доступ к геолокации, чтобы получить вашу текущую погоду"
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let allowButton: UIButton = {
        let button = UIButton()
        button.setTitle("Разрешить", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        return button
        
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Отмена", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = "Доступ к местоположению"
        
        setupViews()
        setupActions()
    }
    
    private func setupViews() {
        [
            titleLabel,
            descriptionLabel,
            allowButton,
            cancelButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            allowButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            allowButton.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -30),
            
            cancelButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50)
        ])
    }
    
    
    private func setupActions() {
        allowButton.addTarget(self, action: #selector(allowTapped), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        
        LocationManager.shared.onAuthorizationChanged = { [weak self] status in
            if status == .authorizedAlways || status == .authorizedWhenInUse {
                DispatchQueue.main.async {
                    self?.openMain()
                }
            }
        }
 
        
    }
    
    @objc private func allowTapped() {
        LocationManager.shared.requestPermission()
    }
    
    @objc private func cancelTapped() {
        openMain()
    }
    
    
    private func openMain() {
        let main = MainViewController()
        main.modalPresentationStyle = .fullScreen
        //present(main, animated: true)
        navigationController?.setViewControllers([main], animated: true)
    }
    

    

}
