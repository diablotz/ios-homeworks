//
//  PhotoCollectionViewCell.swift
//  VKApp
//
//  Created by Timur Zakirov on 01/10/26.
//

import UIKit

final class PhotoCollectionViewCell:
    UICollectionViewCell {

    static let reuseIdentifier =
        "PhotoCollectionViewCell"

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor =
            AppColors.secondaryBackground
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(
                equalTo: contentView.topAnchor
            ),
            imageView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor
            ),
            imageView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor
            ),
            imageView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor
            )
        ])
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is unavailable")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }

    func configure(with photo: PhotoItem) {
        imageView.image = UIImage(named: photo.imageName)

        if imageView.image == nil {
            imageView.image = UIImage(
                systemName: "photo"
            )
            imageView.tintColor = AppColors.secondaryText
            imageView.contentMode = .scaleAspectFit
        } else {
            imageView.contentMode = .scaleAspectFill
        }

        accessibilityLabel =
            "Фотография пользователя \(photo.authorName)"
    }
}
