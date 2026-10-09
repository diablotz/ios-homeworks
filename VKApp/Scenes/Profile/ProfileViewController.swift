//
//  ProfileViewController.swift
//  VKApp
//
//  Created by Timur Zakirov on 01/10/26.
//

import UIKit

final class ProfileViewController: UIViewController {

    private enum Section: Int, CaseIterable {
        case profile
        case posts
    }

    private let viewModel: ProfileViewModel
    
    var onLogout: (() -> Void)?

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: makeLayout()
        )

        collectionView.backgroundColor =
            AppColors.secondaryBackground
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        collectionView.register(
            ProfileHeaderCollectionViewCell.self,
            forCellWithReuseIdentifier:
                ProfileHeaderCollectionViewCell.reuseIdentifier
        )

        collectionView.register(
            PostCollectionViewCell.self,
            forCellWithReuseIdentifier:
                PostCollectionViewCell.reuseIdentifier
        )

        return collectionView
    }()

    init(viewModel: ProfileViewModel) {
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
        configureLogoutButtonIfNeeded()
        setupLayout()
        bindViewModel()

        viewModel.loadData()
    }

    private func setupView() {
        view.backgroundColor =
            AppColors.secondaryBackground

        navigationItem.title = "Профиль"
        navigationItem.largeTitleDisplayMode = .never

        view.addSubview(collectionView)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            collectionView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor
            ),
            collectionView.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            collectionView.widthAnchor.constraint(
                lessThanOrEqualToConstant:
                    AppLayout.feedMaximumWidth
            ),
            collectionView.leadingAnchor.constraint(
                greaterThanOrEqualTo: view.leadingAnchor
            ),
            collectionView.trailingAnchor.constraint(
                lessThanOrEqualTo: view.trailingAnchor
            )
        ])
    }

    private func bindViewModel() {
        viewModel.onDataChanged = { [weak self] in
            guard let self else {
                return
            }

            navigationItem.title =
                viewModel.user?.displayName

            collectionView.reloadData()
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
            case .profile:
                let item = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .estimated(270)
                    )
                )

                let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .estimated(270)
                    ),
                    subitems: [item]
                )

                return NSCollectionLayoutSection(group: group)

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
                        top: 10,
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
    
    private func configureLogoutButtonIfNeeded() {
        guard onLogout != nil else {
            return
        }

        navigationItem.rightBarButtonItem =
            UIBarButtonItem(
                image: UIImage(
                    systemName:
                        "rectangle.portrait.and.arrow.right"
                ),
                style: .plain,
                target: self,
                action: #selector(logoutTapped)
            )

        navigationItem.rightBarButtonItem?
            .accessibilityLabel = "Выйти"
    }

    @objc private func logoutTapped() {
        let alert = UIAlertController(
            title: "Выйти из аккаунта?",
            message:
                "Для следующего входа потребуется номер телефона.",
            preferredStyle: .alert
        )

        alert.addAction(
            UIAlertAction(
                title: "Отмена",
                style: .cancel
            )
        )

        alert.addAction(
            UIAlertAction(
                title: "Выйти",
                style: .destructive
            ) { [weak self] _ in
                self?.onLogout?()
            }
        )

        present(alert, animated: true)
    }

}

// MARK: - UICollectionViewDataSource

extension ProfileViewController:
    UICollectionViewDataSource {

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
        case .profile:
            return viewModel.user == nil ? 0 : 1

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
        case .profile:
            guard
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier:
                        ProfileHeaderCollectionViewCell.reuseIdentifier,
                    for: indexPath
                ) as? ProfileHeaderCollectionViewCell,
                let user = viewModel.user
            else {
                return UICollectionViewCell()
            }

            cell.configure(with: user)

            cell.onMessage = {
                print("Открыть диалог с пользователем")
            }

            return cell

        case .posts:
            guard
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier:
                        PostCollectionViewCell.reuseIdentifier,
                    for: indexPath
                ) as? PostCollectionViewCell
            else {
                return UICollectionViewCell()
            }

            let post = viewModel.posts[indexPath.item]
            cell.configure(with: post)

            cell.onLike = { [weak self] in
                self?.viewModel.toggleLike(
                    at: indexPath.item
                )
            }

            return cell
        }
    }
}
