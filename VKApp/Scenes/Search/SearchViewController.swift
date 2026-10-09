//
//  SearchViewController.swift
//  VKApp
//
//  Created by Timur Zakirov on 24/09/26.
//

import UIKit

final class SearchViewController: UIViewController {

    private enum Section: Int, CaseIterable {
        case users
        case photos
        case posts
    }

    var onShowProfile: ((UUID) -> Void)?

    private let viewModel: SearchViewModel

    private let searchController = UISearchController(
        searchResultsController: nil
    )

    private let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(
            items: ["Для вас", "Новости"]
        )
        control.selectedSegmentIndex = 0
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: makeLayout()
        )

        collectionView.backgroundColor =
            AppColors.secondaryBackground
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.keyboardDismissMode = .onDrag
        collectionView.alwaysBounceVertical = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        collectionView.register(
            SearchUserCollectionViewCell.self,
            forCellWithReuseIdentifier:
                SearchUserCollectionViewCell.reuseIdentifier
        )

        collectionView.register(
            PhotoCollectionViewCell.self,
            forCellWithReuseIdentifier:
                PhotoCollectionViewCell.reuseIdentifier
        )

        collectionView.register(
            PostCollectionViewCell.self,
            forCellWithReuseIdentifier:
                PostCollectionViewCell.reuseIdentifier
        )

        return collectionView
    }()

    init(viewModel: SearchViewModel) {
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
        setupSearchController()
        setupLayout()
        bindViewModel()

        viewModel.loadData()
    }

    private func setupView() {
        view.backgroundColor =
            AppColors.secondaryBackground
        navigationItem.title = "Поиск"

        segmentedControl.addTarget(
            self,
            action: #selector(modeChanged),
            for: .valueChanged
        )

        view.addSubview(segmentedControl)
        view.addSubview(collectionView)
    }

    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder =
            "Люди, сообщества и другое"

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false

        definesPresentationContext = true
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 8
            ),
            segmentedControl.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            segmentedControl.widthAnchor.constraint(
                lessThanOrEqualToConstant: 420
            ),
            segmentedControl.leadingAnchor.constraint(
                greaterThanOrEqualTo: view.leadingAnchor,
                constant: 20
            ),
            segmentedControl.trailingAnchor.constraint(
                lessThanOrEqualTo: view.trailingAnchor,
                constant: -20
            ),

            collectionView.topAnchor.constraint(
                equalTo: segmentedControl.bottomAnchor,
                constant: 8
            ),
            collectionView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),
            collectionView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),
            collectionView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor
            )
        ])
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
            sectionIndex, environment in

            guard
                let section = Section(rawValue: sectionIndex)
            else {
                return nil
            }

            switch section {
            case .users:
                return self.makeListSection(
                    estimatedHeight: 74
                )

            case .posts:
                return self.makeListSection(
                    estimatedHeight: 520
                )

            case .photos:
                let width = environment.container
                    .effectiveContentSize.width

                //let columns: Int
                let availableWidth =
                    environment.container
                        .effectiveContentSize.width
                var columns =
                    AdaptiveLayout.numberOfGridColumns(
                        availableWidth: availableWidth,
                        minimumItemWidth: 110
                    )



                switch width {
                case ..<500:
                    columns = 3
                case ..<800:
                    columns = 4
                default:
                    columns = 6
                }

                let item = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(
                            1 / CGFloat(columns)
                        ),
                        heightDimension: .fractionalWidth(
                            1 / CGFloat(columns)
                        )
                    )
                )

                item.contentInsets =
                    NSDirectionalEdgeInsets(
                        top: 1,
                        leading: 1,
                        bottom: 1,
                        trailing: 1
                    )

                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .fractionalWidth(
                            1 / CGFloat(columns)
                        )
                    ),
                    repeatingSubitem: item,
                    count: columns
                )

                return NSCollectionLayoutSection(group: group)
            }
        }
    }

    private func makeListSection(
        estimatedHeight: CGFloat
    ) -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(
                    estimatedHeight
                )
            )
        )

        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(
                    estimatedHeight
                )
            ),
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(
            group: group
        )
        section.interGroupSpacing = 8

        return section
    }

    @objc private func modeChanged() {
        viewModel.setMode(
            index: segmentedControl.selectedSegmentIndex
        )
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
}


extension SearchViewController:
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
        switch Section(rawValue: section) {
        case .users:
            return viewModel.users.count

        case .photos:
            return viewModel.photos.count

        case .posts:
            return viewModel.posts.count

        case nil:
            return 0
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        switch Section(rawValue: indexPath.section) {
        case .users:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier:
                    SearchUserCollectionViewCell.reuseIdentifier,
                for: indexPath
            ) as! SearchUserCollectionViewCell

            cell.configure(
                with: viewModel.users[indexPath.item]
            )

            return cell

        case .photos:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier:
                    PhotoCollectionViewCell.reuseIdentifier,
                for: indexPath
            ) as! PhotoCollectionViewCell

            cell.configure(
                with: viewModel.photos[indexPath.item]
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

            cell.onLike = { [weak self] in
                self?.viewModel.toggleLike(
                    at: indexPath.item
                )
            }

            cell.onAuthor = { [weak self] in
                self?.onShowProfile?(post.authorID)
            }

            return cell

        case nil:
            return UICollectionViewCell()
        }
    }
}

extension SearchViewController:
    UICollectionViewDelegate {

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        switch Section(rawValue: indexPath.section) {
        case .users:
            onShowProfile?(
                viewModel.users[indexPath.item].id
            )

        case .photos:
            let photo = viewModel.photos[indexPath.item]

            let controller = PhotoDetailViewController(
                photo: photo
            )

            navigationController?.pushViewController(
                controller,
                animated: true
            )

        case .posts, nil:
            break
        }
    }
}

extension SearchViewController:
    UISearchResultsUpdating {

    func updateSearchResults(
        for searchController: UISearchController
    ) {
        viewModel.search(
            text: searchController.searchBar.text ?? ""
        )
    }
}
