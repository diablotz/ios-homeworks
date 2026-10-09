//
//  ProfileHeaderCollectionViewCell.swift
//  VKApp
//
//  Created by Timur Zakirov on 01/10/26.
//

import UIKit

final class ProfileHeaderCollectionViewCell:
    UICollectionViewCell {

    static let reuseIdentifier =
        "ProfileHeaderCollectionViewCell"

    var onMessage: (() -> Void)?

    private let coverView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.vkBlue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(
            systemName: "sparkles"
        )
        imageView.tintColor = UIColor.white.withAlphaComponent(0.35)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor =
            AppColors.secondaryBackground
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 44
        imageView.layer.borderWidth = 4
        imageView.layer.borderColor =
            AppColors.background.cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.title
        label.textColor = AppColors.primaryText
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let statusLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.body
        label.textColor = AppColors.secondaryText
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var messageButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Сообщение"
        configuration.image = UIImage(
            systemName: "message.fill"
        )
        configuration.imagePadding = 7
        configuration.baseBackgroundColor = AppColors.vkBlue
        configuration.baseForegroundColor = .white
        configuration.cornerStyle = .medium

        let button = UIButton(configuration: configuration)
        button.translatesAutoresizingMaskIntoConstraints = false

        button.addTarget(
            self,
            action: #selector(messageButtonTapped),
            for: .touchUpInside
        )

        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
        setupLayout()
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
        onMessage = nil
    }

    func configure(with user: AppUser) {
        nameLabel.text = user.displayName
        statusLabel.text = user.statusText

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

    private func setupView() {
        contentView.backgroundColor = AppColors.background

        contentView.addSubview(coverView)
        coverView.addSubview(coverImageView)
        contentView.addSubview(avatarImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(statusLabel)
        contentView.addSubview(messageButton)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            coverView.topAnchor.constraint(
                equalTo: contentView.topAnchor
            ),
            coverView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor
            ),
            coverView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor
            ),
            coverView.heightAnchor.constraint(
                equalToConstant: 120
            ),

            coverImageView.centerXAnchor.constraint(
                equalTo: coverView.centerXAnchor
            ),
            coverImageView.centerYAnchor.constraint(
                equalTo: coverView.centerYAnchor
            ),
            coverImageView.widthAnchor.constraint(
                equalToConstant: 100
            ),
            coverImageView.heightAnchor.constraint(
                equalToConstant: 70
            ),

            avatarImageView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: AppLayout.horizontalInset
            ),
            avatarImageView.centerYAnchor.constraint(
                equalTo: coverView.bottomAnchor
            ),
            avatarImageView.widthAnchor.constraint(
                equalToConstant: 88
            ),
            avatarImageView.heightAnchor.constraint(
                equalTo: avatarImageView.widthAnchor
            ),

            messageButton.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -AppLayout.horizontalInset
            ),
            messageButton.centerYAnchor.constraint(
                equalTo: avatarImageView.centerYAnchor,
                constant: 18
            ),
            messageButton.heightAnchor.constraint(
                greaterThanOrEqualToConstant:
                    AppLayout.minimumTouchSize
            ),

            nameLabel.topAnchor.constraint(
                equalTo: avatarImageView.bottomAnchor,
                constant: 12
            ),
            nameLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: AppLayout.horizontalInset
            ),
            nameLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -AppLayout.horizontalInset
            ),

            statusLabel.topAnchor.constraint(
                equalTo: nameLabel.bottomAnchor,
                constant: 6
            ),
            statusLabel.leadingAnchor.constraint(
                equalTo: nameLabel.leadingAnchor
            ),
            statusLabel.trailingAnchor.constraint(
                equalTo: nameLabel.trailingAnchor
            ),
            statusLabel.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -20
            )
        ])
    }

    @objc private func messageButtonTapped() {
        onMessage?()
    }
}
