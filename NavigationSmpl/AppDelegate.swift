//
//  AppDelegate.swift
//  NavigationSmpl
//
//  Created by Timur Zakirov on 06/05/26.
//
import UIKit
import FirebaseCore


@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    // В iOS 26 переменная window здесь больше не нужна,
    // она переехала в SceneDelegate.swift

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // добавляем функцию уведомлений
        LocalNotificationService.shared.registerForLastUpdatesIfPossible()
        
        
        // Здесь можно инициализировать сторонние библиотеки (Firebase, SDK аналитики и т.д.)
        FirebaseApp.configure()
        return true
    }

    // MARK: UISceneSession Lifecycle
    // Эти методы сообщают приложению, что нужно использовать SceneDelegate

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Вызывается при создании новой "сцены" (окна)
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Вызывается, когда пользователь закрывает сцену (например, смахивает окно в многозадачности)
    }
}


/*
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    
    var window: UIWindow?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // create tab bar with feed and profile items
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
        
        // activate main window
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        return true
    }
}

*/
