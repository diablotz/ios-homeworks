//
//  MainTabBarController.swift
//  VKApp
//
//  Created by Timur Zakirov on 24/09/26.
//

import UIKit

final class MainTabBarController: UITabBarController {

    private let currentUser: AppUser
    private let feedRepository: FeedRepository
    private let userRepository: UserRepository
    private let photoRepository: PhotoRepository
    private let notificationRepository: NotificationRepository
    private let messengerRepository: MessengerRepository
    private let reelRepository: ReelRepository
    
    var onLogout: (() -> Void)?

    init(
        currentUser: AppUser,
        feedRepository: FeedRepository,
        userRepository: UserRepository,
        photoRepository: PhotoRepository,
        notificationRepository: NotificationRepository,
        messengerRepository: MessengerRepository,
        reelRepository: ReelRepository

    ) {
        self.currentUser = currentUser
        self.feedRepository = feedRepository
        self.userRepository = userRepository
        self.photoRepository = photoRepository
        self.notificationRepository = notificationRepository
        self.messengerRepository = messengerRepository
        self.reelRepository = reelRepository
        
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is unavailable")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureAppearance()
        configureTabs()
    }

    private func configureTabs() {
        
        let feedViewModel = FeedViewModel(
            repository: feedRepository
        )

        let feedViewController = FeedViewController(
            currentUser: currentUser,
            viewModel: feedViewModel
        )
        
        feedViewController.onShowFriends = { [weak self, weak feedViewController, userRepository] in

            let viewModel = FriendsViewModel(
                repository: userRepository
            )

            let friendsViewController = FriendsViewController(
                viewModel: viewModel
            )

            friendsViewController.onSelectFriend = { [weak self, weak friendsViewController] friendID in 
                self?.showProfile(
                    userID: friendID,
                    navigationController:
                        friendsViewController?.navigationController
                )
            }

            feedViewController?.navigationController?
                .pushViewController(
                    friendsViewController,
                    animated: true
                )
        }

        
        feedViewController.onShowProfile = {
            [weak self, weak feedViewController] userID in

            self?.showProfile(
                userID: userID,
                navigationController:
                    feedViewController?.navigationController
            )
        }
        
        feedViewController.onShowPhotos = {
            [weak self, weak feedViewController] in

            guard let self else {
                return
            }

            let viewModel = PhotosViewModel(
                repository: photoRepository
            )

            let photosViewController = PhotosViewController(
                viewModel: viewModel
            )

            feedViewController?.navigationController?
                .pushViewController(
                    photosViewController,
                    animated: true
                )
        }
        
        feedViewController.onShowNotifications = {
            [weak self, weak feedViewController] in

            guard let self else {
                return
            }

            let viewModel = NotificationsViewModel(
                repository: notificationRepository
            )

            let notificationsViewController =
                NotificationsViewController(
                    viewModel: viewModel
                )

            feedViewController?.navigationController?
                .pushViewController(
                    notificationsViewController,
                    animated: true
                )
        }

        
        feedViewController.onShowCreate = {
            [weak feedViewController, currentUser, feedRepository] in

            let menuViewController =
                CreateContentMenuViewController()

            menuViewController.modalPresentationStyle = .pageSheet

            if let sheet =
                menuViewController.sheetPresentationController {
                sheet.detents = [.medium()]
                sheet.prefersGrabberVisible = true
                sheet.preferredCornerRadius = 24
            }

            menuViewController.onSelect = {
                [weak menuViewController, weak feedViewController]
                type in

                switch type {
                case .post:
                    menuViewController?.dismiss(
                        animated: true
                    ) {
                        let viewModel = CreatePostViewModel(
                            currentUserID: currentUser.id,
                            repository: feedRepository
                        )

                        let createPostViewController =
                            CreatePostViewController(
                                viewModel: viewModel
                            )

                        feedViewController?.navigationController?
                            .pushViewController(
                                createPostViewController,
                                animated: true
                            )
                    }

                case .story:
                    menuViewController?.dismiss(
                        animated: true
                    ) {
                        let viewModel = CreateStoryViewModel(
                            currentUserID: currentUser.id,
                            repository: feedRepository
                        )

                        let controller = CreateStoryViewController(
                            viewModel: viewModel
                        )

                        feedViewController?.navigationController?
                            .pushViewController(
                                controller,
                                animated: true
                            )
                    }
                    
                    
                

                case .clip:
                        menuViewController?.dismiss(
                            animated: true
                        ) {
                            let viewModel = CreateClipViewModel(
                                currentUserID: currentUser.id,
                                repository: self.reelRepository
                            )

                            let controller =
                                CreateClipViewController(
                                    viewModel: viewModel
                                )

                            feedViewController?.navigationController?
                                .pushViewController(
                                    controller,
                                    animated: true
                                )
                        }

                case .video:
                    let viewModel = CreateVideoViewModel(
                        currentUserID: currentUser.id,
                        repository: self.feedRepository
                    )

                    let viewController = CreateVideoViewController(
                        viewModel: viewModel
                    )

                    guard let navigationController =
                            self.selectedViewController as? UINavigationController
                    else {
                        return
                    }

                    navigationController.pushViewController(
                        viewController,
                        animated: true
                    )







                }
            }

            feedViewController?.present(
                menuViewController,
                animated: true
            )
        }
        
        
        feedViewController.onShowStories = {
            [weak feedViewController, feedRepository]
            stories, index in

            guard !stories.isEmpty else {
                return
            }

            let viewModel = StoryViewerViewModel(
                stories: stories,
                initialIndex: index,
                repository: feedRepository
            )

            let viewer = StoryViewerViewController(
                viewModel: viewModel
            )

            feedViewController?.present(
                viewer,
                animated: true
            )
        }



        
        let messengerViewModel = MessengerViewModel(
            repository: messengerRepository
        )

        let messengerViewController = MessengerViewController(
            viewModel: messengerViewModel
        )

        messengerViewController.onSelectConversation = {
            [weak messengerViewController, currentUser, messengerRepository]
            conversation in

            let viewModel = ChatViewModel(
                conversation: conversation,
                currentUserID: currentUser.id,
                repository: messengerRepository
            )

            let chatViewController = ChatViewController(
                viewModel: viewModel
            )

            messengerViewController?.navigationController?
                .pushViewController(
                    chatViewController,
                    animated: true
                )
        }
        
        let searchViewModel = SearchViewModel(
            userRepository: userRepository,
            feedRepository: feedRepository,
            photoRepository: photoRepository
        )

        let searchViewController = SearchViewController(
            viewModel: searchViewModel
        )

        searchViewController.onShowProfile = {
            [weak self, weak searchViewController] userID in

            self?.showProfile(
                userID: userID,
                navigationController:
                    searchViewController?.navigationController
            )
        }

        let reelsViewModel = ReelsViewModel(
            repository: reelRepository
        )

        let reelsViewController = ReelsViewController(
            viewModel: reelsViewModel
        )



        let feedNavigationController = makeNavigationController(
            rootViewController: feedViewController,
            title: "Главная",
            imageName: "house",
            selectedImageName: "house.fill"
        )

        let searchNavigationController = makeNavigationController(
            rootViewController: searchViewController,
            title: "Поиск",
            imageName: "magnifyingglass",
            selectedImageName: "magnifyingglass"
        )

        let messengerNavigationController = makeNavigationController(
            rootViewController: messengerViewController,
            title: "Мессенджер",
            imageName: "bubble.left.and.bubble.right",
            selectedImageName:
                "bubble.left.and.bubble.right.fill"
        )

        let reelsNavigationController = makeNavigationController(
            rootViewController: reelsViewController,
            title: "Reels",
            imageName: "play.rectangle",
            selectedImageName: "play.rectangle.fill"
        )

        viewControllers = [
            feedNavigationController,
            searchNavigationController,
            messengerNavigationController,
            reelsNavigationController
        ]

        selectedIndex = 0
    }

    private func makeNavigationController(
        rootViewController: UIViewController,
        title: String,
        imageName: String,
        selectedImageName: String
    ) -> UINavigationController {
        let navigationController = UINavigationController(
            rootViewController: rootViewController
        )

        navigationController.tabBarItem = UITabBarItem(
            title: title,
            image: UIImage(systemName: imageName),
            selectedImage: UIImage(
                systemName: selectedImageName
            )
        )

        navigationController.navigationBar.tintColor =
        AppColors.vkBlue

        return navigationController
    }

    private func configureAppearance() {
        delegate = self

        tabBar.tintColor = AppColors.vkBlue
        tabBar.unselectedItemTintColor = AppColors.secondaryText

        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = AppColors.background
        appearance.shadowColor = AppColors.separator

        configureItemAppearance(appearance.stackedLayoutAppearance)
        configureItemAppearance(appearance.inlineLayoutAppearance)
        configureItemAppearance(
            appearance.compactInlineLayoutAppearance
        )

        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }

    private func configureItemAppearance(
        _ itemAppearance: UITabBarItemAppearance
    ) {
        itemAppearance.normal.iconColor = AppColors.secondaryText
        itemAppearance.normal.titleTextAttributes = [
            .foregroundColor: AppColors.secondaryText
        ]

        itemAppearance.selected.iconColor = AppColors.vkBlue
        itemAppearance.selected.titleTextAttributes = [
            .foregroundColor: AppColors.vkBlue
        ]
    }
    
    private func showProfile(
        userID: UUID,
        navigationController: UINavigationController?
    ) {
        let viewModel = ProfileViewModel(
            userID: userID,
            userRepository: userRepository,
            feedRepository: feedRepository
        )

        let profileViewController = ProfileViewController(
            viewModel: viewModel
        )

        if userID == currentUser.id {
            profileViewController.onLogout = {
                [weak self] in

                self?.onLogout?()
            }
        }

        navigationController?.pushViewController(
            profileViewController,
            animated: true
        )

    }

    
}



extension MainTabBarController: UITabBarControllerDelegate {

    func tabBarController(
        _ tabBarController: UITabBarController,
        shouldSelect viewController: UIViewController
    ) -> Bool {
        guard
            let current = selectedViewController,
            current === viewController,
            let navigationController =
                viewController as? UINavigationController
        else {
            return true
        }

        if navigationController.viewControllers.count > 1 {
            navigationController.popToRootViewController(
                animated: true
            )
        } else {
            let rootViewController =
                navigationController.viewControllers.first

            if let scrollView = findScrollView(
                in: rootViewController?.view
            ) {
                scrollView.setContentOffset(
                    CGPoint(
                        x: 0,
                        y: -scrollView.adjustedContentInset.top
                    ),
                    animated: true
                )
            }
        }

        return false
    }

    private func findScrollView(
        in view: UIView?
    ) -> UIScrollView? {
        guard let view else {
            return nil
        }

        if let scrollView = view as? UIScrollView {
            return scrollView
        }

        for subview in view.subviews {
            if let scrollView = findScrollView(in: subview) {
                return scrollView
            }
        }

        return nil
    }
}
