//
//  FeedViewController.swift
//  VKApp
//
//  Created by Timur Zakirov on 24/09/26.
//



import UIKit
import AVKit
import AVFoundation

private enum Section: Int, CaseIterable {
    case stories = 0
    case posts = 1
}

final class FeedViewController: UIViewController {

    
    
    var onShowFriends: (() -> Void)?
    var onShowProfile: ((UUID) -> Void)?
    var onShowPhotos: (() -> Void)?
    var onShowNotifications: (() -> Void)?
    var onShowCreate: (() -> Void)?
    var onShowStories: (([FeedStory], Int) -> Void)?

    private let currentUser: AppUser
    private let viewModel: FeedViewModel

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: makeLayout()
        )

        collectionView.backgroundColor =
            AppColors.secondaryBackground

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        collectionView.register(
            StoryCollectionViewCell.self,
            forCellWithReuseIdentifier:
                StoryCollectionViewCell.reuseIdentifier
        )

        collectionView.register(
            PostCollectionViewCell.self,
            forCellWithReuseIdentifier:
                PostCollectionViewCell.reuseIdentifier
        )

        return collectionView
    }()

    init(
        currentUser: AppUser,
        viewModel: FeedViewModel
    ) {
        self.currentUser = currentUser
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is unavailable")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupLayout()
        setupProfileButton()
        configureNavigationBar()
        bindViewModel()
        

        viewModel.loadData()
        
        viewModel.onDataChanged = {
            [weak self] in
            self?.collectionView.reloadData()
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadData()
        
    }

    private func setupView() {
        view.backgroundColor = AppColors.secondaryBackground
        view.addSubview(collectionView)
    }
    

    private func setupLayout() {
        view.addSubview(collectionView)

        let safeArea = view.safeAreaLayoutGuide
        let inset = AdaptiveLayout.horizontalInset(
            for: traitCollection
        )

        let preferredWidth =
            collectionView.widthAnchor.constraint(
                equalTo: safeArea.widthAnchor,
                constant: -(inset * 2)
            )

        preferredWidth.priority = .defaultHigh

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(
                equalTo: safeArea.topAnchor
            ),
            collectionView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor
            ),

            collectionView.centerXAnchor.constraint(
                equalTo: safeArea.centerXAnchor
            ),

            collectionView.leadingAnchor.constraint(
                greaterThanOrEqualTo: safeArea.leadingAnchor,
                constant: inset
            ),

            collectionView.trailingAnchor.constraint(
                lessThanOrEqualTo: safeArea.trailingAnchor,
                constant: -inset
            ),

            collectionView.widthAnchor.constraint(
                lessThanOrEqualToConstant:
                    AdaptiveLayout.feedMaximumWidth
            ),

            preferredWidth
        ])
    }




    private lazy var profileButton: UIButton = {
        let button = UIButton(type: .custom)

        button.frame = CGRect(
            x: 0,
            y: 0,
            width: 40,
            height: 40
        )

        button.backgroundColor =
            AppColors.secondaryBackground

        button.imageView?.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        button.layer.cornerRadius = 20

        button.addTarget(
            self,
            action: #selector(profileTapped),
            for: .touchUpInside
        )

        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(
                equalToConstant: 40
            ),
            button.heightAnchor.constraint(
                equalToConstant: 40
            )
        ])

        return button
    }()

    private func setupProfileButton() {
        let avatarImage =
            UIImage(
                named: currentUser.avatarName ?? ""
            )
            ?? UIImage(
                systemName: "person.crop.circle.fill"
            )

        profileButton.setImage(
            avatarImage,
            for: .normal
        )

        profileButton.imageView?.contentMode =
            .scaleAspectFill

        profileButton.layer.cornerRadius = 20
        profileButton.clipsToBounds = true

        navigationItem.leftBarButtonItem =
            UIBarButtonItem(
                customView: profileButton
            )
    }




    private func configureNavigationBar() {
//        navigationItem.leftBarButtonItem = UIBarButtonItem(
//            image: UIImage(systemName: "person.crop.circle.fill"),
//            style: .plain,
//            target: self,
//            action: #selector(profileTapped)
//        )

        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(
                image: UIImage(systemName: "bell"),
                style: .plain,
                target: self,
                action: #selector(notificationsTapped)
            ),
            UIBarButtonItem(
                image: UIImage(systemName: "plus.circle"),
                style: .plain,
                target: self,
                action: #selector(addTapped)
            )
        ]

        let titleButton = UIButton(type: .system)
        titleButton.setTitle("Главная⌄", for: .normal)
        titleButton.setTitleColor(
            AppColors.primaryText,
            for: .normal
        )
        titleButton.titleLabel?.font = AppFonts.title
        titleButton.showsMenuAsPrimaryAction = true

        titleButton.menu = UIMenu(children: [
            UIAction(
                title: "Главная",
                image: UIImage(systemName: "house.fill"),
                state: .on
            ) { _ in },

            UIAction(
                title: "Друзья",
                image: UIImage(systemName: "person.2")
            ) { [weak self] _ in
                self?.onShowFriends?()
            },

            UIAction(
                title: "Фото",
                image: UIImage(systemName: "photo")
            ) { [weak self] _ in
                self?.onShowPhotos?()
            }
        ])

        navigationItem.titleView = titleButton
    }

    private func bindViewModel() {
        viewModel.onDataChanged = { [weak self] in
            self?.collectionView.reloadData()
        }

        viewModel.onError = { [weak self] message in
            self?.showError(message)
        }
    }

    private func makeLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout {
            sectionIndex, _ in

            guard
                let section = Section(rawValue: sectionIndex)
            else {
                return nil
            }

            switch section {
            case .stories:
                let item = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .absolute(84),
                        heightDimension: .absolute(108)
                    )
                )

                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .absolute(84),
                        heightDimension: .absolute(108)
                    ),
                    subitems: [item]
                )

                let layoutSection = NSCollectionLayoutSection(
                    group: group
                )
                layoutSection.orthogonalScrollingBehavior =
                    .continuous
                layoutSection.interGroupSpacing = 8
                layoutSection.contentInsets =
                    NSDirectionalEdgeInsets(
                        top: 12,
                        leading: 12,
                        bottom: 12,
                        trailing: 12
                    )

                return layoutSection

            case .posts:
                let item = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .estimated(520)
                    )
                )

                let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .estimated(520)
                    ),
                    subitems: [item]
                )

                let layoutSection = NSCollectionLayoutSection(
                    group: group
                )
                layoutSection.interGroupSpacing = 10
                layoutSection.contentInsets =
                    NSDirectionalEdgeInsets(
                        top: 0,
                        leading: 0,
                        bottom: 12,
                        trailing: 0
                    )

                return layoutSection
            }
        }
    }


    private func showError(_ message: String) {
        let alert = UIAlertController(
            title: "Ошибка",
            message: message,
            preferredStyle: .alert
        )

        alert.addAction(
            UIAlertAction(title: "ОК", style: .default)
        )

        present(alert, animated: true)
    }

    @objc private func profileTapped() {
        onShowProfile?(currentUser.id)
    }

    @objc private func addTapped() {
        onShowCreate?()
    }

    @objc private func notificationsTapped() {
        onShowNotifications?()
    }
}



extension FeedViewController: UICollectionViewDataSource {

    func numberOfSections(
        in collectionView: UICollectionView
    ) -> Int {
        Section.allCases.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        guard let section = Section(rawValue: section) else {
            return 0
        }

        switch section {
        case .stories:
            return viewModel.stories.count

        case .posts:
            return viewModel.posts.count
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard
            let section = Section(rawValue: indexPath.section)
        else {
            return UICollectionViewCell()
        }

        switch section {
        case .stories:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier:
                    StoryCollectionViewCell.reuseIdentifier,
                for: indexPath
            ) as! StoryCollectionViewCell

            cell.configure(
                with: viewModel.stories[indexPath.item]
            )

            return cell

        case .posts:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier:
                    PostCollectionViewCell.reuseIdentifier,
                for: indexPath
            ) as! PostCollectionViewCell

            let post = viewModel.posts[indexPath.item]
            cell.configure(with: post)
            
//            cell.onVideoTapped = {
//                [weak self] videoName in
//                self?.showVideo(fileName: videoName)
//            }

            cell.onLike = { [weak self] in
                self?.viewModel.toggleLike(
                    at: indexPath.item
                )
            }

            cell.onReadMore = { [weak self] in
                self?.showPost(post)
            }

            cell.onAuthor = { [weak self] in
                self?.onShowProfile?(post.authorID )
                
            }

            return cell
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didEndDisplaying cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        guard let postCell =
            cell as? PostCollectionViewCell
        else {
            return
        }

        postCell.stopVideo()
    }


    


    private func showVideoError() {
        let alert = UIAlertController(
            title: "Ошибка",
            message: "Файл видео не найден.",
            preferredStyle: .alert
        )

        alert.addAction(
            UIAlertAction(
                title: "ОК",
                style: .default
            )
        )

        present(alert, animated: true)
    }


}



extension FeedViewController: UICollectionViewDelegate {

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        guard indexPath.section == Section.stories.rawValue else {
            return
        }

        onShowStories?(
            viewModel.stories,
            indexPath.item
        )
    }


}



private extension FeedViewController {

    func showPost(_ post: FeedPost) {
        
        if post.mediaType == .video,
               let videoName = post.videoName,
               let url = LocalVideoStore.shared.url(
                   for: videoName
               ) {
                let playerViewController =
                    AVPlayerViewController()

                playerViewController.player =
                    AVPlayer(url: url)

                navigationController?.pushViewController(
                    playerViewController,
                    animated: true
                )

                playerViewController.player?.play()
                return
            }



        let viewController = UIViewController()
        viewController.view.backgroundColor = AppColors.background
        viewController.title = post.authorName

        let textView = UITextView()
        textView.text = post.text
        textView.font = AppFonts.body
        textView.textColor = AppColors.primaryText
        textView.backgroundColor = AppColors.background
        textView.isEditable = false
        textView.isScrollEnabled = true
        textView.adjustsFontForContentSizeCategory = true
        textView.textContainerInset = UIEdgeInsets(
            top: 20,
            left: 16,
            bottom: 20,
            right: 16
        )
        textView.translatesAutoresizingMaskIntoConstraints = false

        viewController.view.addSubview(textView)

        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(
                equalTo: viewController.view.safeAreaLayoutGuide.topAnchor
            ),
            textView.leadingAnchor.constraint(
                equalTo: viewController.view.leadingAnchor
            ),
            textView.trailingAnchor.constraint(
                equalTo: viewController.view.trailingAnchor
            ),
            textView.bottomAnchor.constraint(
                equalTo: viewController.view.bottomAnchor
            )
        ])

        navigationController?.pushViewController(
            viewController,
            animated: true
        )
    }
}


//import UIKit
//
//final class FeedViewController: UIViewController {
//
//    private let currentUser: AppUser
//
//    init(currentUser: AppUser) {
//        self.currentUser = currentUser
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    @available(*, unavailable)
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) is unavailable")
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        view.backgroundColor = AppColors.background
//        navigationItem.title = "Главная"
//
//        configureNavigationBar()
//        showTemporaryContent()
//    }
//
//    private func configureNavigationBar() {
//        let profileButton = UIBarButtonItem(
//            image: UIImage(systemName: "person.crop.circle.fill"),
//            style: .plain,
//            target: self,
//            action: #selector(profileButtonTapped)
//        )
//
//        profileButton.accessibilityLabel = "Профиль"
//
//        let addButton = UIBarButtonItem(
//            image: UIImage(systemName: "plus.circle"),
//            style: .plain,
//            target: self,
//            action: #selector(addButtonTapped)
//        )
//
//        addButton.accessibilityLabel = "Создать"
//
//        let notificationButton = UIBarButtonItem(
//            image: UIImage(systemName: "bell"),
//            style: .plain,
//            target: self,
//            action: #selector(notificationButtonTapped)
//        )
//
//        notificationButton.accessibilityLabel = "Уведомления"
//
//        navigationItem.leftBarButtonItem = profileButton
//        navigationItem.rightBarButtonItems = [
//            notificationButton,
//            addButton
//        ]
//    }
//
//    private func showTemporaryContent() {
//        let label = UILabel()
//        label.text = "Здравствуйте,\n\(currentUser.displayName)"
//        label.font = AppFonts.title
//        label.textColor = AppColors.primaryText
//        label.textAlignment = .center
//        label.numberOfLines = 0
//        label.adjustsFontForContentSizeCategory = true
//        label.translatesAutoresizingMaskIntoConstraints = false
//
//        view.addSubview(label)
//
//        NSLayoutConstraint.activate([
//            label.centerXAnchor.constraint(
//                equalTo: view.centerXAnchor
//            ),
//            label.centerYAnchor.constraint(
//                equalTo: view.centerYAnchor
//            ),
//            label.leadingAnchor.constraint(
//                greaterThanOrEqualTo: view.leadingAnchor,
//                constant: AppLayout.horizontalInset
//            ),
//            label.trailingAnchor.constraint(
//                lessThanOrEqualTo: view.trailingAnchor,
//                constant: -AppLayout.horizontalInset
//            )
//        ])
//    }
//
//    @objc private func profileButtonTapped() {
//        print("Открыть профиль")
//    }
//
//    @objc private func addButtonTapped() {
//        print("Открыть страницу создания")
//    }
//
//    @objc private func notificationButtonTapped() {
//        print("Открыть уведомления")
//    }
//}
