//
//  FeedCoordinator.swift
//  NavigationSmpl
//
//  Created by Timur Zakirov on 26/05/26.
//

import UIKit
import StorageService

final class FeedCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let feedVC = FeedViewController()
        feedVC.coordinator = self
        
        feedVC.tabBarItem = UITabBarItem(
            title: "Лентааааа",
            image: UIImage(systemName: "list.bullet"),
            tag: 0
            
        )
        navigationController.viewControllers = [feedVC]
    }
    
    func openPost(_ post: Post) {
        let postVC = PostViewController()
        postVC.post = post
        navigationController.pushViewController(postVC, animated: true)
    }
}
