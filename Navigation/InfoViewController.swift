//
//  InfoViewController.swift
//  Navigation
//
//  Created by Timur Zakirov on 30/01/26.
//

import UIKit

class InfoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemPink
        title = "Информация"
                
        let buttonAlert = UIButton(type: .system)
        buttonAlert.setTitle("Внимание!", for: .normal)
        buttonAlert.addTarget(self, action: #selector(showAlert), for: .touchUpInside)
        
        buttonAlert.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonAlert)
        
        let buttonClose = UIButton(type: .system)
        buttonClose.setTitle("Вернуться к посту", for: .normal)
        buttonClose.addTarget(self, action: #selector(closeInfo), for: .touchUpInside)
        buttonClose.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonClose)
        
        NSLayoutConstraint.activate([
            buttonAlert.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonAlert.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            buttonAlert.widthAnchor.constraint(equalToConstant: 300),
            buttonAlert.heightAnchor.constraint(equalToConstant: 50),
            
            buttonClose.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            buttonClose.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
            
        ])

    
        
    }
    
    @objc func showAlert() {
        let alert = UIAlertController(title: "Внимание!", message: "Внимание! Это сообщение!", preferredStyle: .alert)
    
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            print("Нажат OK")
        }
        
        let canselAction = UIAlertAction(title: "Отмена", style: .cancel) { _ in
            print("Отменено!")
        }
        
        alert.addAction(okAction)
        alert.addAction(canselAction)
        
        present(alert, animated: true, completion: nil)
        //dismiss(animated: true)
    }
    
    @objc func closeInfo() {
        dismiss(animated: true)
    }
    
    
    


}
