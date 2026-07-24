//
//  AllQuotesCoordinator.swift
//  QuoteDatabase
//
//  Created by Timur Zakirov on 24/07/26.
//

import UIKit


final class AllQuotesCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let allQuotesVC = AllQuotesViewController()
        allQuotesVC.coordinator = self
        
        allQuotesVC.tabBarItem = UITabBarItem(
            title: "All Quotes",
            image: UIImage(systemName: "list.bullet"),
            tag: 0
            
        )
        navigationController.viewControllers = [allQuotesVC]
    }
    
    
}

