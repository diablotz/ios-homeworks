//
//  FavoriteCoordinator.swift
//  NavigationSmpl
//
//  Created by Timur Zakirov on 28/07/26.
//

import UIKit
import StorageService

final class FavoriteCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let favoriteVC = FavoriteViewController()
        favoriteVC.coordinator = self
        
        favoriteVC.tabBarItem = UITabBarItem(
            title: "favorite_key".localized,
            image: UIImage(systemName: "heart.fill"),
            tag: 2
            
        )
        navigationController.viewControllers = [favoriteVC]
    }
    
    func openPost(_ post: Post) {
        let postVC = PostViewController()
        postVC.post = post
        navigationController.pushViewController(postVC, animated: true)
    }
}
