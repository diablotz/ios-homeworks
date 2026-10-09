//
//  PhotoDetailViewController.swift
//  VKApp
//
//  Created by Timur Zakirov on 01/10/26.
//

import UIKit

final class PhotoDetailViewController: UIViewController {

    var onLike: ((UUID) -> Void)?

    private let photo: PhotoItem

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 4
        scrollView.backgroundColor = .black
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    init(photo: PhotoItem) {
        self.photo = photo
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
        configurePhoto()
    }

    private func setupView() {
        view.backgroundColor = .black
        navigationItem.title = photo.authorName

        scrollView.delegate = self

        view.addSubview(scrollView)
        scrollView.addSubview(imageView)

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(
                systemName: photo.isLiked
                    ? "heart.fill"
                    : "heart"
            ),
            style: .plain,
            target: self,
            action: #selector(likeTapped)
        )

        navigationItem.rightBarButtonItem?.tintColor =
            photo.isLiked ? .systemRed : .white
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            scrollView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),
            scrollView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),
            scrollView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor
            ),

            imageView.topAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.topAnchor
            ),
            imageView.leadingAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.leadingAnchor
            ),
            imageView.trailingAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.trailingAnchor
            ),
            imageView.bottomAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.bottomAnchor
            ),
            imageView.widthAnchor.constraint(
                equalTo: scrollView.frameLayoutGuide.widthAnchor
            ),
            imageView.heightAnchor.constraint(
                equalTo: scrollView.frameLayoutGuide.heightAnchor
            )
        ])
    }

    private func configurePhoto() {
        imageView.image = UIImage(named: photo.imageName)

        if imageView.image == nil {
            imageView.image = UIImage(systemName: "photo")
            imageView.tintColor = .white
        }
    }

    @objc private func likeTapped() {
        onLike?(photo.id)
        navigationController?.popViewController(
            animated: true
        )
    }
}

extension PhotoDetailViewController:
    UIScrollViewDelegate {

    func viewForZooming(
        in scrollView: UIScrollView
    ) -> UIView? {
        imageView
    }
}
