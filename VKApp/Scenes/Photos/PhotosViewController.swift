//
//  PhotosViewController.swift
//  VKApp
//
//  Created by Timur Zakirov on 01/10/26.
//

import UIKit

final class PhotosViewController: UIViewController {

    private let viewModel: PhotosViewModel

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: makeLayout()
        )

        collectionView.backgroundColor = AppColors.background
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        collectionView.register(
            PhotoCollectionViewCell.self,
            forCellWithReuseIdentifier:
                PhotoCollectionViewCell.reuseIdentifier
        )

        return collectionView
    }()

    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "Фотографий пока нет"
        label.font = AppFonts.body
        label.textColor = AppColors.secondaryText
        label.textAlignment = .center
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    init(viewModel: PhotosViewModel) {
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
        bindViewModel()

        viewModel.loadPhotos()
    }

    private func setupView() {
        view.backgroundColor = AppColors.background
        navigationItem.title = "Фото"
        navigationItem.largeTitleDisplayMode = .never

        view.addSubview(collectionView)
        view.addSubview(emptyLabel)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            collectionView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),
            collectionView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),
            collectionView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor
            ),

            emptyLabel.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            emptyLabel.centerYAnchor.constraint(
                equalTo: view.centerYAnchor
            )
        ])
    }

    private func bindViewModel() {
        viewModel.onDataChanged = { [weak self] in
            guard let self else {
                return
            }

            collectionView.reloadData()
            emptyLabel.isHidden = !viewModel.photos.isEmpty
        }

        viewModel.onError = { [weak self] message in
            self?.showError(message)
        }
    }
    private func makeLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout {
            sectionIndex,
            environment in

            let availableWidth =
                environment.container
                    .effectiveContentSize.width

            let columns =
                AdaptiveLayout.numberOfGridColumns(
                    availableWidth: availableWidth,
                    minimumItemWidth: 130
                )

            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(
                    1.0 / CGFloat(columns)
                ),
                heightDimension: .fractionalWidth(
                    1.0 / CGFloat(columns)
                )
            )

            let item = NSCollectionLayoutItem(
                layoutSize: itemSize
            )

            item.contentInsets = NSDirectionalEdgeInsets(
                top: 2,
                leading: 2,
                bottom: 2,
                trailing: 2
            )

            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalWidth(
                    1.0 / CGFloat(columns)
                )
            )

            let group =
                NSCollectionLayoutGroup.horizontal(
                    layoutSize: groupSize,
                    subitems: [item]
                )

            return NSCollectionLayoutSection(
                group: group
            )
        }
    }



//    private func makeLayout() -> UICollectionViewLayout {
//        UICollectionViewCompositionalLayout {
//            _, environment in
//
//            let width =
//                environment.container.effectiveContentSize.width
//
//            let columns: Int
//
//            switch width {
//            case ..<500:
//                columns = 3
//
//            case ..<800:
//                columns = 4
//
//            default:
//                columns = 6
//            }
//
//            let itemSize = NSCollectionLayoutSize(
//                widthDimension: .fractionalWidth(
//                    1.0 / CGFloat(columns)
//                ),
//                heightDimension: .fractionalWidth(
//                    1.0 / CGFloat(columns)
//                )
//            )
//
//            let item = NSCollectionLayoutItem(
//                layoutSize: itemSize
//            )
//
//            item.contentInsets = NSDirectionalEdgeInsets(
//                top: 1,
//                leading: 1,
//                bottom: 1,
//                trailing: 1
//            )
//
//            let groupSize = NSCollectionLayoutSize(
//                widthDimension: .fractionalWidth(1),
//                heightDimension: .fractionalWidth(
//                    1.0 / CGFloat(columns)
//                )
//            )
//
//            let group = NSCollectionLayoutGroup.horizontal(
//                layoutSize: groupSize,
//                repeatingSubitem: item,
//                count: columns
//            )
//
//            return NSCollectionLayoutSection(group: group)
//        }
//    }

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



extension PhotosViewController:
    UICollectionViewDataSource {

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        viewModel.photos.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier:
                    PhotoCollectionViewCell.reuseIdentifier,
                for: indexPath
            ) as? PhotoCollectionViewCell
        else {
            return UICollectionViewCell()
        }

        cell.configure(
            with: viewModel.photos[indexPath.item]
        )

        return cell
    }
}



extension PhotosViewController:
    UICollectionViewDelegate {

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        guard let photo = viewModel.photo(
            at: indexPath.item
        ) else {
            return
        }

        let viewController = PhotoDetailViewController(
            photo: photo
        )

        viewController.onLike = { [weak self] photoID in
            self?.viewModel.toggleLike(photoID: photoID)
        }

        navigationController?.pushViewController(
            viewController,
            animated: true
        )
    }
}
