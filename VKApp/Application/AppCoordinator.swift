//
//  AppCoordinator.swift
//  VKApp
//
//  Created by Timur Zakirov on 14/09/26.
//

import UIKit

final class AppCoordinator {

    private let window: UIWindow
    private let container: DependencyContainer

    private let navigationController: UINavigationController

    init(
        window: UIWindow,
        container: DependencyContainer
    ) {
        self.window = window
        self.container = container
        self.navigationController = UINavigationController()
    }

    func start() {
        container.seedDataService.seedIfNeeded()

        window.makeKeyAndVisible()

        do {
            if let user = try container
                .authenticationRepository
                .currentUser() {
                showMainInterface(for: user)
            } else {
                showAuthentication()
            }
        } catch {
            container.authenticationRepository.logout()
            showAuthentication()
        }
    }
    
    private func showAuthentication() {
        navigationController.setViewControllers(
            [],
            animated: false
        )

        window.rootViewController = navigationController
        showWelcome()
    }



    private func showWelcome() {
        let viewController = WelcomeViewController()

        viewController.onRegistration = { [weak self] in
            self?.showLogin(mode: .registration)
        }

        viewController.onLogin = { [weak self] in
            self?.showLogin(mode: .login)
        }
        
        navigationController.setNavigationBarHidden(
            true,
            animated: false
        )

        navigationController.setViewControllers(
            [viewController],
            animated: false
        )
    }

    private func showLogin(mode: LoginMode) {
        navigationController.setNavigationBarHidden(
            false,
            animated: true
        )

        let viewModel = LoginViewModel(
            mode: mode,
            repository: container.authenticationRepository
        )

        let viewController = LoginViewController(
            viewModel: viewModel
        )

        viewController.onAuthenticationSuccess = {
            [weak self] user in
            self?.showMainInterface(for: user)
        }

        navigationController.pushViewController(
            viewController,
            animated: true
        )
    }


//    private func showLogin(mode: LoginMode) {
//        let viewModel = LoginViewModel(
//            mode: mode,
//            repository: container.authenticationRepository
//        )
//
//        let viewController = LoginViewController(
//            viewModel: viewModel
//        )
//
//        viewController.onAuthenticationSuccess = {
//            [weak self] user in
//            self?.showMainInterface(for: user)
//        }
//
//        navigationController.pushViewController(
//            viewController,
//            animated: true
//        )
//    }

    
    private func showMainInterface(for user: AppUser) {
        let mainTabBarController = MainTabBarController(
            currentUser: user,
            feedRepository: container.feedRepository,
            userRepository: container.userRepository,
            photoRepository: container.photoRepository,
            notificationRepository: container.notificationRepository,
            messengerRepository: container.messengerRepository,
            reelRepository: container.reelRepository
        )
        
        mainTabBarController.onLogout = {
            [weak self] in
            self?.performLogout()
        }

        UIView.transition(
            with: window,
            duration: 0.3,
            options: .transitionCrossDissolve,
            animations: {
                self.window.rootViewController =
                    mainTabBarController
            }
        )
    }
    
    private func performLogout() {
        container.authenticationRepository.logout()

        navigationController.setViewControllers(
            [],
            animated: false
        )

        UIView.transition(
            with: window,
            duration: 0.3,
            options: .transitionCrossDissolve,
            animations: {
                self.window.rootViewController =
                    self.navigationController
            },
            completion: { [weak self] _ in
                self?.showWelcome()
            }
        )
    }



//    private func showMainInterface(for user: AppUser) {
//        let viewController = UIViewController()
//        viewController.view.backgroundColor = AppColors.background
//        viewController.title = "Главная"
//
//        let label = UILabel()
//        label.text = "Добро пожаловать,\n\(user.displayName)"
//        label.font = AppFonts.title
//        label.textColor = AppColors.primaryText
//        label.textAlignment = .center
//        label.numberOfLines = 0
//        label.adjustsFontForContentSizeCategory = true
//        label.translatesAutoresizingMaskIntoConstraints = false
//
//        viewController.view.addSubview(label)
//
//        NSLayoutConstraint.activate([
//            label.centerXAnchor.constraint(
//                equalTo: viewController.view.centerXAnchor
//            ),
//            label.centerYAnchor.constraint(
//                equalTo: viewController.view.centerYAnchor
//            ),
//            label.leadingAnchor.constraint(
//                greaterThanOrEqualTo:
//                    viewController.view.leadingAnchor,
//                constant: AppLayout.horizontalInset
//            ),
//            label.trailingAnchor.constraint(
//                lessThanOrEqualTo:
//                    viewController.view.trailingAnchor,
//                constant: -AppLayout.horizontalInset
//            )
//        ])
//
//        navigationController.setViewControllers(
//            [viewController],
//            animated: true
//        )
//    }

    
//    private func showLogin(mode: LoginMode) {
//        let viewController = LoginViewController(mode: mode)
//
//        navigationController.pushViewController(
//            viewController,
//            animated: true
//        )
//    }
}

