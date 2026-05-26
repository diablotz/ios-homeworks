//
//  AppCoordinator.swift
//  NavigationSmpl
//
//  Created by Timur Zakirov on 26/05/26.
//

import UIKit

final class AppCoordinator {
    var window: UIWindow?
    
    private let tabBarController = UITabBarController()
    
    private let feedCoordinator = FeedCoordinator(
        navigationController: UINavigationController()
    )
    
    private let profileCoordinator = ProfileCoordinator(
        navigationController: UINavigationController()
    )
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    func start() {
        feedCoordinator.start()
        profileCoordinator.start()
        
        tabBarController.viewControllers = [
            feedCoordinator.navigationController,
            profileCoordinator.navigationController,
        ]
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }
}
