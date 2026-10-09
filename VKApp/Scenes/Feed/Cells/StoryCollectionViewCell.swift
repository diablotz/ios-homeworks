//
//  StoryCollectionViewCell.swift
//  VKApp
//
//  Created by Timur Zakirov on 01/10/26.
//

import UIKit

final class StoryCollectionViewCell: UICollectionViewCell {

    static let reuseIdentifier = "StoryCollectionViewCell"

//    private let avatarImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.contentMode = .scaleAspectFill
//        imageView.clipsToBounds = true
//        imageView.backgroundColor = AppColors.secondaryBackground
//        imageView.layer.borderWidth = 3
//        imageView.layer.cornerRadius = 20
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        return imageView
//    }()

    private let avatarImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.backgroundColor = AppColors.secondaryBackground
            imageView.layer.borderWidth = 3
            imageView.layer.borderColor =
                AppColors.vkBlue.cgColor
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.caption
        label.textColor = AppColors.primaryText
        label.textAlignment = .center
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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

    override func layoutSubviews() {
        super.layoutSubviews()

        avatarImageView.layer.cornerRadius =
            avatarImageView.bounds.width / 2
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        avatarImageView.image = nil
        nameLabel.text = nil
    }

//    func configure(with story: FeedStory) {
//        nameLabel.text = story.authorName
//
//        if let avatarName = story.avatarName {
//            avatarImageView.image = LocalImageStore.shared.image(named: avatarName)
//        }
//
//        avatarImageView.layer.borderColor = (
//            story.isViewed
//            ? AppColors.separator
//            : AppColors.vkBlue
//        ).cgColor
//    }
    
    func configure(with story: FeedStory) {
        nameLabel.text = story.authorName

        if let avatarName = story.avatarName {
            avatarImageView.image =
                LocalImageStore.shared.image(
                    fileName: avatarName
                )
        }

        avatarImageView.layer.borderColor = (
            story.isViewed
                ? AppColors.separator
                : AppColors.vkBlue
        ).cgColor

        setNeedsLayout()
        layoutIfNeeded()
    }



    private func setupView() {
        contentView.addSubview(avatarImageView)
        contentView.addSubview(nameLabel)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 4
            ),
            avatarImageView.centerXAnchor.constraint(
                equalTo: contentView.centerXAnchor
            ),
            avatarImageView.widthAnchor.constraint(
                equalToConstant: 72
            ),
            avatarImageView.heightAnchor.constraint(
                equalTo: avatarImageView.widthAnchor
            ),

            nameLabel.topAnchor.constraint(
                equalTo: avatarImageView.bottomAnchor,
                constant: 6
            ),
            nameLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor
            ),
            nameLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor
            ),
            nameLabel.bottomAnchor.constraint(
                lessThanOrEqualTo: contentView.bottomAnchor
            )
        ])
    }
}
