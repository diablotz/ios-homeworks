//
//  FeedViewController.swift
//  Navigation
//
//  Created by Timur Zakirov on 29/01/26.
//

import UIKit

struct Post {
    let title: String
    let content: String
}

class FeedViewController: UIViewController {
    
    let samplePost = Post(title: "Образец поста", content: "Начало текста поста. Какой-то набор букв для заполнения пространства вапвуцкцУпЦУ укцУПЦЙуЦ ФКУЦЦрпу4кпц КУПРУКЕ4ЦГШ65Ф4К5 5егфу35кф апрущшокщзфуцк4 6+9екруф укефуркррукер Такое ощущение, будто бы диплом пишу, вначале со смыслом, в конце со смыслом, внутри - муть. Конец текста поста.")

    private lazy var button1 : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Посмотреть пост", for: .normal)
        button.addTarget(self, action: #selector(showPost), for: .touchUpInside)
        button.backgroundColor = .blue
        button.tintColor = .white
        return button
    } ()
    
    private lazy var button2 : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Посмотреть пост", for: .normal)
        button.addTarget(self, action: #selector(showPost), for: .touchUpInside)
        button.backgroundColor = .brown
        button.tintColor = .white
        return button
    } ()
    
    private lazy var stackView : UIStackView = {
        [unowned self] in
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.clipsToBounds = true
        stackView.addArrangedSubview(self.button1)
        stackView.addArrangedSubview(self.button2)
        return stackView
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Лента"
        
        view.addSubview(stackView)
        setupContrainsts()
        // код из ДЗ №1
        /*
        let button = UIButton(type: .system)
        button.setTitle("Посмотреть пост", for: .normal)
        button.addTarget(self, action: #selector(showPost), for: .touchUpInside)
        button.backgroundColor = .green
        
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
       */
        
    }
    
    func setupContrainsts() {
        let selfArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: selfArea.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: selfArea.centerYAnchor),
            stackView.widthAnchor.constraint(equalToConstant: 300)
        ])
        
    }
    
    @objc func showPost() {
        let postViewController = PostViewController(post: samplePost)
        navigationController?.pushViewController(postViewController, animated: true)
    }
    

    

}
