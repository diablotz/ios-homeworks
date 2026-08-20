//
//  ProfileCoordinator.swift
//  NavigationSmpl
//
//  Created by Timur Zakirov on 26/05/26.
//

import Foundation

import UIKit
import StorageService

final class ProfileCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let loginVC = LoginViewController()
        let factory = MyLoginFactory()
        loginVC.loginDelegate = factory.makeLoginInspector()
        loginVC.coordinator = self
        
        loginVC.tabBarItem = UITabBarItem(
            title: "profile_key".localized,
            image: UIImage(systemName: "person.crop.circle"),
            tag: 1
            
        )
        navigationController.viewControllers = [loginVC]
    }
    
    func openProfile(user: User) {
        
        let viewModel = ProfileViewModel(user: user)
        let profileVC = ProfileViewController(viewModel: viewModel)
        profileVC.coordinator = self
         /*
        let loginVC = LoginViewController()
        //let factory = MyLoginFactory()
        //loginVC.loginDelegate = factory.makeLoginInspector()
        loginVC.coordinator = self
        */
        navigationController.pushViewController(profileVC, animated: true)
        //navigationController.pushViewController(loginVC, animated: true)
    }
    
    func openPhotos() {
        
        let photosVC = PhotosViewController()
        //photosVC.coordinator = self
        
        navigationController.pushViewController(photosVC, animated: true)
    }
}
