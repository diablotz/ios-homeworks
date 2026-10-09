//
//  FriendTableViewCell.swift
//  VKApp
//
//  Created by Timur Zakirov on 01/10/26.
//

import UIKit

final class FriendTableViewCell: UITableViewCell {

    static let reuseIdentifier = "FriendTableViewCell"

    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = AppColors.secondaryBackground
        imageView.layer.cornerRadius = 28
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let onlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGreen
        view.layer.borderWidth = 2
        view.layer.borderColor = AppColors.background.cgColor
        view.layer.cornerRadius = 7
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.headline
        label.textColor = AppColors.primaryText
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let statusLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.subheadline
        label.textColor = AppColors.secondaryText
        label.numberOfLines = 1
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var labelsStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [
                nameLabel,
                statusLabel
            ]
        )

        stackView.axis = .vertical
        stackView.spacing = 3
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )

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
        onlineView.isHidden = true
    }

    func configure(with friend: FriendListItem) {
        nameLabel.text = friend.fullName
        statusLabel.text = friend.statusText
        onlineView.isHidden = !friend.isOnline

        if let avatarName = friend.avatarName {
            avatarImageView.image = UIImage(named: avatarName)
        }

        if avatarImageView.image == nil {
            avatarImageView.image = UIImage(
                systemName: "person.crop.circle.fill"
            )
            avatarImageView.tintColor = AppColors.secondaryText
        }

        accessibilityLabel = [
            friend.fullName,
            friend.statusText,
            friend.isOnline ? "В сети" : nil
        ]
        .compactMap { $0 }
        .joined(separator: ", ")
    }

    private func setupView() {
        accessoryType = .disclosureIndicator
        selectionStyle = .default
        backgroundColor = AppColors.background

        contentView.addSubview(avatarImageView)
        contentView.addSubview(onlineView)
        contentView.addSubview(labelsStackView)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: AppLayout.horizontalInset
            ),
            avatarImageView.centerYAnchor.constraint(
                equalTo: contentView.centerYAnchor
            ),
            avatarImageView.widthAnchor.constraint(
                equalToConstant: 56
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
            onlineView.widthAnchor.constraint(equalToConstant: 14),
            onlineView.heightAnchor.constraint(equalToConstant: 14),

            labelsStackView.leadingAnchor.constraint(
                equalTo: avatarImageView.trailingAnchor,
                constant: 14
            ),
            labelsStackView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -12
            ),
            labelsStackView.topAnchor.constraint(
                greaterThanOrEqualTo: contentView.topAnchor,
                constant: 12
            ),
            labelsStackView.bottomAnchor.constraint(
                lessThanOrEqualTo: contentView.bottomAnchor,
                constant: -12
            ),
            labelsStackView.centerYAnchor.constraint(
                equalTo: contentView.centerYAnchor
            ),

            contentView.heightAnchor.constraint(
                greaterThanOrEqualToConstant: 80
            )
        ])
    }
}
