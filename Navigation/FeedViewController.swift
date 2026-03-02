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

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Лента"
        
        let button = UIButton(type: .system)
        button.setTitle("Посмотреть пост", for: .normal)
        button.addTarget(self, action: #selector(showPost), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
       
        
    }
    
    @objc func showPost() {
        let postViewController = PostViewController(post: samplePost)
        navigationController?.pushViewController(postViewController, animated: true)
    }
    

    

}
