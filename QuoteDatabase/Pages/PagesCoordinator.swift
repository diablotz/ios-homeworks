//
//  PagesCoordinator.swift
//  QuoteDatabase
//
//  Created by Timur Zakirov on 24/07/26.
//


import UIKit

final class PagesCoordinator {
    var window: UIWindow?
    
    private let tabBarController = UITabBarController()
    
    private let newQuoteCoordinator = NewQuoteCoordinator(
        navigationController: UINavigationController()
    )
    
    private let allQuotesCoordinator = AllQuotesCoordinator(
        navigationController: UINavigationController()
    )
    
    private let categoriesCoordinator = CategoriesCoordinator(
        navigationController: UINavigationController()
    )
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    func start() {
        newQuoteCoordinator.start()
        allQuotesCoordinator.start()
        categoriesCoordinator.start()
        
        tabBarController.viewControllers = [
            newQuoteCoordinator.navigationController,
            allQuotesCoordinator.navigationController,
            categoriesCoordinator.navigationController
        ]
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }
}
