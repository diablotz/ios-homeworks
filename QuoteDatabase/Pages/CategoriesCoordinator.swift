//
//  CategoriesCoordinator.swift
//  QuoteDatabase
//
//  Created by Timur Zakirov on 24/07/26.
//

import UIKit


final class CategoriesCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let categoriesVC = CategoriesViewController()
        categoriesVC.coordinator = self
        
        categoriesVC.tabBarItem = UITabBarItem(
            title: "Categories",
            image: UIImage(systemName: "binoculars"),
            tag: 0
            
        )
        navigationController.viewControllers = [categoriesVC]
    }
    
    
}
