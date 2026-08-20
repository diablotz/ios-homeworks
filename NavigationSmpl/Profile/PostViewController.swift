//
//  PostViewController.swift
//  Navigation
//

import UIKit
import StorageService

final class PostViewController: UIViewController {
    
    var post: Post?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = post?.author ?? "-"
        view.backgroundColor = .systemYellow
        
        // add a button in the navigtion bar
        let barButton = UIBarButtonItem(title: "info_key".localized, style: .prominent, target: self, action: #selector(tapInfoButton))
        navigationItem.rightBarButtonItem = barButton
    }
    
    @objc func tapInfoButton() {
        let infoVC = InfoViewController()
        present(infoVC, animated: true, completion: nil)
    }
}
