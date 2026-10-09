//
//  SearchUserCollectionViewCell.swift
//  VKApp
//
//  Created by Timur Zakirov on 02/10/26.
//

import UIKit

final class SearchUserCollectionViewCell:
    UICollectionViewCell {

    static let reuseIdentifier =
        "SearchUserCollectionViewCell"

    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 25
        imageView.backgroundColor =
            AppColors.secondaryBackground
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.headline
        label.textColor = AppColors.primaryText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let statusLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.subheadline
        label.textColor = AppColors.secondaryText
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let onlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGreen
        view.layer.cornerRadius = 6
        view.layer.borderWidth = 2
        view.layer.borderColor = AppColors.background.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.backgroundColor = AppColors.background
        contentView.addSubview(avatarImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(statusLabel)
        contentView.addSubview(onlineView)

        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 16
            ),
            avatarImageView.centerYAnchor.constraint(
                equalTo: contentView.centerYAnchor
            ),
            avatarImageView.widthAnchor.constraint(
                equalToConstant: 50
            ),
            avatarImageView.heightAnchor.constraint(
                equalTo: avatarImageView.widthAnchor
            ),

            onlineView.trailingAnchor.constraint(
                equalTo: avatarImageView.trailingAnchor
            ),
            onlineView.bottomAnchor.constraint(
                equalTo: avatarImageView.bottomAnchor
            ),
            onlineView.widthAnchor.constraint(
                equalToConstant: 12
            ),
            onlineView.heightAnchor.constraint(
                equalToConstant: 12
            ),

            nameLabel.leadingAnchor.constraint(
                equalTo: avatarImageView.trailingAnchor,
                constant: 12
            ),
            nameLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -16
            ),
            nameLabel.bottomAnchor.constraint(
                equalTo: contentView.centerYAnchor,
                constant: -2
            ),

            statusLabel.topAnchor.constraint(
                equalTo: contentView.centerYAnchor,
                constant: 2
            ),
            statusLabel.leadingAnchor.constraint(
                equalTo: nameLabel.leadingAnchor
            ),
            statusLabel.trailingAnchor.constraint(
                equalTo: nameLabel.trailingAnchor
            )
        ])
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is unavailable")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        avatarImageView.image = nil
        nameLabel.text = nil
        statusLabel.text = nil
    }

    func configure(with user: FriendListItem) {
        nameLabel.text = user.fullName
        statusLabel.text = user.statusText
        onlineView.isHidden = !user.isOnline

        if let avatarName = user.avatarName {
            avatarImageView.image = UIImage(
                named: avatarName
            )
        }

        if avatarImageView.image == nil {
            avatarImageView.image = UIImage(
                systemName: "person.crop.circle.fill"
            )
            avatarImageView.tintColor =
                AppColors.secondaryText
        }
    }
}
