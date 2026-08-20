//
//  InfoViewController.swift
//  Navigation
//

import UIKit

final class InfoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemGray6
        view.addSubview(titleLabel)
        view.addSubview(orbitalPeriodLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            //titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor - 50),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            orbitalPeriodLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            orbitalPeriodLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            orbitalPeriodLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            orbitalPeriodLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        loadTodo()
        loadPlanet()
        createAlertButton()
    }
 
    // ДЗ №2.1 - работа с данными
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .bold)
        //label.text = "Hello, World!"
        label.textColor = .red
        return label
    } ()
    
    // ДЗ №2.2 - работа с данными
    private let orbitalPeriodLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .bold)
        //label.text = "Hello, World!"
        label.textColor = .blue
        return label
    } ()
    
    private func createAlertButton() {
        //let button = UIButton()
        let button = CustomButton(title: "alert_key".localized, titleColor: .white, backgroundColor: .systemBlue, cornerRadius: LayoutConstants.cornerRadius)
        //button.translatesAutoresizingMaskIntoConstraints = false
        //button.setTitle("Alert", for: .normal)
        //button.backgroundColor = .systemPink
        //button.setTitleColor(.white, for: .normal)
        //button.layer.cornerRadius = LayoutConstants.cornerRadius
        button.addTarget(self, action: #selector(tapAlertButton), for: .touchUpInside)
                
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            button.heightAnchor.constraint(equalToConstant: 50),
            button.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    

    private func loadTodo() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/todos/2") else {
            return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            
            if let error = error {
                print(error)
                return
            }
            
            guard let data = data else { return }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data)
                
                if let dictionary = json as? [String: Any],
                   let title = dictionary["title"] as? String {
                    
                    DispatchQueue.main.async {
                        self?.titleLabel.text = title
                    }
                }
                
            } catch {
                print("Ошибка JSON:", error)
            }
            
        }.resume()
        
    }
    
    private func loadPlanet() {
        guard let url = URL(string: "https://swapi.dev/api/planets/1") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            
            if let error = error {
                print(error)
                return
            }
            
            guard let data = data else { return }
            
            do {
                let planet = try JSONDecoder().decode(Planet.self, from: data)
                print(planet)
                
                
                    
                    DispatchQueue.main.async {
                        self?.orbitalPeriodLabel.text = "rotation_period_key".localized + " \(planet.name): \(planet.orbitalPeriod)"
                    }
                
                
            } catch {
                print("Ошибка декодироввания JSON:", error)
            }
            
        }.resume()
        
    }
    
    @objc func tapAlertButton() {
        let alert = UIAlertController(title: "alert_key".localized,
                                      message: "how_feeling_key".localized,
                                      preferredStyle: .alert)
        // add two buttons
        let fine = UIAlertAction(title: "fine_key".localized, style: .default) { _ in
            print("fine_key".localized)
        }
        alert.addAction(fine)
        
        let so = UIAlertAction(title: "soso_key".localized, style: .destructive) { _ in
            print("soso_key".localized)
        }
        alert.addAction(so)

        self.present(alert, animated: true, completion: nil)
    }
}
