//
//  PostViewController.swift
//  Navigation
//
//  Created by Timur Zakirov on 30/01/26.
//

import UIKit

class PostViewController: UIViewController {
    
    let post: Post
    
    init(post: Post) {
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = post.title
        view.backgroundColor = .systemFill
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Подробнее",
            style: .plain,
            target: self,
            action: #selector(openInfo)
            
        )
        
        let textView = UITextView()
        textView.text = post.content
        textView.isEditable = false
        textView.backgroundColor = .systemYellow
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.cornerRadius = 20
        textView.layer.borderWidth = 1
        view.addSubview(textView)
        
        NSLayoutConstraint.activate([
            textView.widthAnchor.constraint(equalToConstant: 300),
            textView.heightAnchor.constraint(equalToConstant: 300),
            textView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            textView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    @objc private func openInfo() {
        let invoViewController = InfoViewController()
        present(invoViewController, animated: true)
    }

    
    

}

