//
//  NotificationTableViewCell.swift
//  VKApp
//
//  Created by Timur Zakirov on 02/10/26.
//

import UIKit

final class NotificationTableViewCell:
    UITableViewCell {

    static let reuseIdentifier =
        "NotificationTableViewCell"

    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor =
            AppColors.secondaryBackground
        imageView.layer.cornerRadius = 25
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .white
        imageView.contentMode = .center
        imageView.backgroundColor = AppColors.vkBlue
        imageView.layer.cornerRadius = 10
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.body
        label.textColor = AppColors.primaryText
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.caption
        label.textColor = AppColors.secondaryText
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var labelsStackView: UIStackView = {
        let stack = UIStackView(
            arrangedSubviews: [
                messageLabel,
                dateLabel
            ]
        )

        stack.axis = .vertical
        stack.spacing = 5
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
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
        messageLabel.text = nil
        dateLabel.text = nil
    }

    func configure(with notification: AppNotification) {
        messageLabel.text = notification.message

        dateLabel.text = notification.createdAt.formatted(
            date: .abbreviated,
            time: .shortened
        )

        if let avatarName = notification.senderAvatarName {
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

        iconImageView.image = UIImage(
            systemName: iconName(
                for: notification.kind
            )
        )

        contentView.backgroundColor = notification.isRead
            ? AppColors.background
            : AppColors.vkBlue.withAlphaComponent(0.08)

        accessibilityLabel = notification.message
        accessibilityValue = notification.isRead
            ? "Прочитано"
            : "Не прочитано"
    }

    private func iconName(
        for kind: NotificationKind
    ) -> String {
        switch kind {
        case .like:
            return "heart.fill"

        case .comment:
            return "bubble.left.fill"

        case .friendRequest:
            return "person.badge.plus"

        case .newMessage:
            return "message.fill"

        case .system:
            return "bell.fill"
        }
    }

    private func setupView() {
        backgroundColor = AppColors.background

        contentView.addSubview(avatarImageView)
        contentView.addSubview(iconImageView)
        contentView.addSubview(labelsStackView)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: AppLayout.horizontalInset
            ),
            avatarImageView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 14
            ),
            avatarImageView.widthAnchor.constraint(
                equalToConstant: 50
            ),
            avatarImageView.heightAnchor.constraint(
                equalTo: avatarImageView.widthAnchor
            ),

            iconImageView.trailingAnchor.constraint(
                equalTo: avatarImageView.trailingAnchor,
                constant: 2
            ),
            iconImageView.bottomAnchor.constraint(
                equalTo: avatarImageView.bottomAnchor,
                constant: 2
            ),
            iconImageView.widthAnchor.constraint(
                equalToConstant: 20
            ),
            iconImageView.heightAnchor.constraint(
                equalToConstant: 20
            ),

            labelsStackView.leadingAnchor.constraint(
                equalTo: avatarImageView.trailingAnchor,
                constant: 14
            ),
            labelsStackView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -AppLayout.horizontalInset
            ),
            labelsStackView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 14
            ),
            labelsStackView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -14
            ),

            contentView.heightAnchor.constraint(
                greaterThanOrEqualToConstant: 78
            )
        ])
    }
}
