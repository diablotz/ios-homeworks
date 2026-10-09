//
//  MessageTableViewCell.swift
//  VKApp
//
//  Created by Timur Zakirov on 02/10/26.
//

import UIKit

final class MessageTableViewCell: UITableViewCell {

    static let reuseIdentifier = "MessageTableViewCell"

    private let bubbleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.body
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.caption
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var leadingConstraint: NSLayoutConstraint?
    private var trailingConstraint: NSLayoutConstraint?

    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )

        selectionStyle = .none
        backgroundColor = .clear

        contentView.addSubview(bubbleView)
        bubbleView.addSubview(messageLabel)
        bubbleView.addSubview(timeLabel)

        leadingConstraint = bubbleView.leadingAnchor.constraint(
            equalTo: contentView.leadingAnchor,
            constant: 16
        )

        trailingConstraint = bubbleView.trailingAnchor.constraint(
            equalTo: contentView.trailingAnchor,
            constant: -16
        )

        NSLayoutConstraint.activate([
            bubbleView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 5
            ),
            bubbleView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -5
            ),
            bubbleView.widthAnchor.constraint(
                lessThanOrEqualTo: contentView.widthAnchor,
                multiplier: 0.78
            ),

            messageLabel.topAnchor.constraint(
                equalTo: bubbleView.topAnchor,
                constant: 10
            ),
            messageLabel.leadingAnchor.constraint(
                equalTo: bubbleView.leadingAnchor,
                constant: 12
            ),
            messageLabel.trailingAnchor.constraint(
                equalTo: bubbleView.trailingAnchor,
                constant: -12
            ),

            timeLabel.topAnchor.constraint(
                equalTo: messageLabel.bottomAnchor,
                constant: 4
            ),
            timeLabel.trailingAnchor.constraint(
                equalTo: messageLabel.trailingAnchor
            ),
            timeLabel.bottomAnchor.constraint(
                equalTo: bubbleView.bottomAnchor,
                constant: -7
            )
        ])
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is unavailable")
    }

    func configure(with message: ChatMessage) {
        messageLabel.text = message.text
        timeLabel.text = message.sentAt.formatted(
            date: .omitted,
            time: .shortened
        )

        if message.isOutgoing {
            leadingConstraint?.isActive = false
            trailingConstraint?.isActive = true

            bubbleView.backgroundColor = AppColors.vkBlue
            messageLabel.textColor = .white
            timeLabel.textColor =
                UIColor.white.withAlphaComponent(0.75)
        } else {
            trailingConstraint?.isActive = false
            leadingConstraint?.isActive = true

            bubbleView.backgroundColor =
                AppColors.secondaryBackground
            messageLabel.textColor = AppColors.primaryText
            timeLabel.textColor = AppColors.secondaryText
        }
    }
}
