//
//  SceneDelegate.swift
//  Navigation
//
//  Created by Timur Zakirov on 28/01/26.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let scene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: scene)
        
        let feedViewController = FeedViewController()
        feedViewController.view.backgroundColor = .systemRed
        
//        let profileViewController = ProfileViewController()
//        profileViewController.view.backgroundColor = .white
        
        let loginViewController = LoginViewController()
        //loginViewController.loginDelegate = LoginInspector()
        let factory = MyLoginFactory()
        loginViewController.loginDelegate = factory.makeLoginInspector()
        loginViewController.view.backgroundColor = .white
        
        let tabBarController = UITabBarController()
        
        feedViewController.tabBarItem = UITabBarItem(title: "Лента", image: UIImage(systemName: "list.bullet"), tag: 0)
        loginViewController.tabBarItem = UITabBarItem(title: "Профиль", image: UIImage(systemName: "person.crop.circle"), tag: 1)
        
        let controllers = [feedViewController, loginViewController]
        tabBarController.viewControllers = controllers.map {
            UINavigationController(rootViewController: $0)
        }
        tabBarController.selectedIndex = 0
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible( )
        
        self.window = window
        
    }


    
}
