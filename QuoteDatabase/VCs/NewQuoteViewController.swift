//
//  NewQuoteViewController.swift
//  QuoteDatabase
//
//  Created by Timur Zakirov on 24/07/26.
//

import UIKit
import RealmSwift

class NewQuoteViewController: UIViewController {
    
    weak var coordinator: NewQuoteCoordinator?

    lazy var loadQuoteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Загрузить новую цитату", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = .filled()
        button.addTarget(self, action: #selector(loadQuote), for: .touchUpInside)
        button.clipsToBounds = true
        return button
    }()
    
    lazy var newQuoteText: UITextView = {
        let textField = UITextView()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textAlignment = .center
        textField.font = .systemFont(ofSize: 16)
        textField.textColor = .black
        textField.isScrollEnabled = true
        
        textField.layer.borderWidth = 1
        return textField
    }()
    
    lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Загрузить цитату"
        
        setupViews()

        // Do any additional setup after loading the view.
    }
    

    private func setupViews(){
        view.addSubview(loadQuoteButton)
        view.addSubview(newQuoteText)
        view.addSubview(categoryLabel)
        
        NSLayoutConstraint.activate([
            loadQuoteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadQuoteButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            
            newQuoteText.topAnchor.constraint(equalTo: loadQuoteButton.bottomAnchor, constant: 50),
            newQuoteText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            newQuoteText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            newQuoteText.heightAnchor.constraint(equalToConstant: 200),
            
            categoryLabel.topAnchor.constraint(equalTo: newQuoteText.bottomAnchor, constant: 50),
            categoryLabel.leadingAnchor.constraint(equalTo: newQuoteText.leadingAnchor, constant: 0),
            categoryLabel.trailingAnchor.constraint(equalTo: newQuoteText.trailingAnchor, constant: 0)
            
            
        ])
        
    }
    @objc func loadQuote() {

        APIService.shared.loadRandomQuote { [weak self] result in

            guard let self = self else { return }

            switch result {

            case .success(let response):

                DispatchQueue.main.async {
                    self.newQuoteText.text = response.value
                    if response.categories.isEmpty {
                        self.categoryLabel.text = "Без категории"
                    } else {
                        self.categoryLabel.text = response.categories.joined(separator: ", ")
                    }
                }

                RealmManager.shared.save(receivedQuote: response)

            case .failure(let error):

                print(error)
            }
        }
    }
//
//    @objc func loadQuote() {
//
//        APIService.shared.loadRandomQuote { result in
//
//            switch result {
//
//            case .success(let response):
//
//                self.newQuoteText.text = response.value
//
//                RealmManager.shared.save(receivedQuote: response)
//
//            case .failure(let error):
//
//                print(error)
//
//            }
//
//        }
//
//    }
//   

}
