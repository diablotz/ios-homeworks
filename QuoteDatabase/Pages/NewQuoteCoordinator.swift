//
//  NewQuoteCoordinator.swift
//  QuoteDatabase
//
//  Created by Timur Zakirov on 24/07/26.
//

import UIKit


final class NewQuoteCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let newQuoteVC = NewQuoteViewController()
        newQuoteVC.coordinator = self
        
        newQuoteVC.tabBarItem = UITabBarItem(
            title: "Add Quote",
            image: UIImage(systemName: "square.and.arrow.down.fill"),
            tag: 0
            
        )
        navigationController.viewControllers = [newQuoteVC]
    }
    
    
}
