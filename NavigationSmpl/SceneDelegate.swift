//
//  SceneDelegate.swift
//  NavigationSmpl
//
//  Created by Timur Zakirov on 06/05/26.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // 1. Проверяем, что сцена — это UIWindowScene
        guard let windowScene = (scene as? UIWindowScene) else { return }

        // 2. Создаем контроллеры
        let loginVC = LoginViewController()
        let profileNC = UINavigationController(rootViewController: loginVC)
        profileNC.tabBarItem = UITabBarItem(title: "Profile",
                                            image: UIImage(systemName: "person.crop.circle"),
                                            selectedImage: UIImage(systemName: "person.crop.circle.fill"))
        
        let feedVC = FeedViewController()
        let feedNC = UINavigationController(rootViewController: feedVC)
        feedNC.tabBarItem = UITabBarItem(title: "Feed",
                                         image: UIImage(systemName: "text.bubble"),
                                         selectedImage: UIImage(systemName: "text.bubble.fill"))

        let tabBarController = UITabBarController()
        tabBarController.tabBar.backgroundColor = .white
        tabBarController.viewControllers = [profileNC, feedNC]
        
        // 3. Инициализируем window через windowScene (исправляет Deprecated warning)
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = tabBarController
        
        // 4. Сохраняем ссылку и показываем
        self.window = window
        window.makeKeyAndVisible()
    }
}
