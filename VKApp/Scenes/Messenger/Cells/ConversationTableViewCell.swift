//
//  ConversationTableViewCell.swift
//  VKApp
//
//  Created by Timur Zakirov on 02/10/26.
//

import UIKit

final class ConversationTableViewCell:
    UITableViewCell {

    static let reuseIdentifier =
        "ConversationTableViewCell"

    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 30
        imageView.backgroundColor =
            AppColors.secondaryBackground
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.headline
        label.textColor = AppColors.primaryText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.subheadline
        label.textColor = AppColors.secondaryText
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.caption
        label.textColor = AppColors.secondaryText
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let badgeLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.caption
        label.textColor = .white
        label.backgroundColor = AppColors.vkBlue
        label.textAlignment = .center
        label.layer.cornerRadius = 12
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        titleLabel.text = nil
        messageLabel.text = nil
        dateLabel.text = nil
        badgeLabel.text = nil
    }

    func configure(with item: ConversationItem) {
        titleLabel.text = item.title
        messageLabel.text = item.lastMessage

        dateLabel.text = item.updatedAt.formatted(
            date: .omitted,
            time: .shortened
        )

        if let avatarName = item.avatarName {
            avatarImageView.image = UIImage(named: avatarName)
        }

        if avatarImageView.image == nil {
            avatarImageView.image = UIImage(
                systemName: "person.crop.circle.fill"
            )
            avatarImageView.tintColor =
                AppColors.secondaryText
        }

        badgeLabel.text = "\(item.unreadCount)"
        badgeLabel.isHidden = item.unreadCount == 0
    }

    private func setupView() {
        accessoryType = .disclosureIndicator

        [
            avatarImageView,
            titleLabel,
            messageLabel,
            dateLabel,
            badgeLabel
        ].forEach(contentView.addSubview)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 16
            ),
            avatarImageView.centerYAnchor.constraint(
                equalTo: contentView.centerYAnchor
            ),
            avatarImageView.widthAnchor.constraint(
                equalToConstant: 60
            ),
            avatarImageView.heightAnchor.constraint(
                equalTo: avatarImageView.widthAnchor
            ),

            titleLabel.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 15
            ),
            titleLabel.leadingAnchor.constraint(
                equalTo: avatarImageView.trailingAnchor,
                constant: 12
            ),
            titleLabel.trailingAnchor.constraint(
                lessThanOrEqualTo: dateLabel.leadingAnchor,
                constant: -8
            ),

            dateLabel.topAnchor.constraint(
                equalTo: titleLabel.topAnchor
            ),
            dateLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -12
            ),

            messageLabel.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: 7
            ),
            messageLabel.leadingAnchor.constraint(
                equalTo: titleLabel.leadingAnchor
            ),
            messageLabel.trailingAnchor.constraint(
                lessThanOrEqualTo: badgeLabel.leadingAnchor,
                constant: -8
            ),

            badgeLabel.centerYAnchor.constraint(
                equalTo: messageLabel.centerYAnchor
            ),
            badgeLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -12
            ),
            badgeLabel.widthAnchor.constraint(
                greaterThanOrEqualToConstant: 24
            ),
            badgeLabel.heightAnchor.constraint(
                equalToConstant: 24
            ),

            contentView.heightAnchor.constraint(
                greaterThanOrEqualToConstant: 84
            )
        ])
    }
}
