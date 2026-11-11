//
//  MovieTableViewCell.swift
//  VKApp
//
//  Created by Timur Zakirov on 03/11/26.
//

import UIKit

@MainActor
final class MovieTableViewCell: UITableViewCell {

    static let reuseIdentifier = "MovieTableViewCell"

    private var imageTask: Task<Void, Never>?

    private let posterImageView: UIImageView = {
        let imageView = UIImageView()

        imageView.image = UIImage(
            systemName: "film"
        )
        imageView.tintColor = AppColors.secondaryText
        imageView.backgroundColor = AppColors.secondaryBackground
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()

        label.font = AppFonts.body
        label.textColor = AppColors.primaryText
        label.numberOfLines = 2
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private let detailsLabel: UILabel = {
        let label = UILabel()

        label.font = AppFonts.caption
        label.textColor = AppColors.secondaryText
        label.numberOfLines = 3
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private let selectedIconImageView: UIImageView = {
        let imageView = UIImageView()

        imageView.image = UIImage(
            systemName: "checkmark.circle.fill"
        )
        imageView.tintColor = AppColors.accent
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
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

    required init?(
        coder: NSCoder
    ) {
        fatalError(
            "init(coder:) has not been implemented"
        )
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        imageTask?.cancel()
        imageTask = nil

        posterImageView.image = UIImage(
            systemName: "film"
        )

        titleLabel.text = nil
        detailsLabel.text = nil
        selectedIconImageView.isHidden = true
    }

    func configure(
        with movie: Movie,
        isSelected: Bool
    ) {
        titleLabel.text = movie.name
        detailsLabel.text = makeDetails(
            for: movie
        )
        selectedIconImageView.isHidden = !isSelected

        loadPoster(
            urlString: movie.image?.medium
                ?? movie.image?.original
        )
    }

    private func setupView() {
        backgroundColor = AppColors.background
        selectionStyle = .none

        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(detailsLabel)
        contentView.addSubview(selectedIconImageView)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 10
            ),
            posterImageView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: AppLayout.horizontalInset
            ),
            posterImageView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -10
            ),
            posterImageView.widthAnchor.constraint(
                equalToConstant: 72
            ),
            posterImageView.heightAnchor.constraint(
                equalToConstant: 104
            ),

            selectedIconImageView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -AppLayout.horizontalInset
            ),
            selectedIconImageView.centerYAnchor.constraint(
                equalTo: contentView.centerYAnchor
            ),
            selectedIconImageView.widthAnchor.constraint(
                equalToConstant: 24
            ),
            selectedIconImageView.heightAnchor.constraint(
                equalToConstant: 24
            ),

            titleLabel.topAnchor.constraint(
                equalTo: posterImageView.topAnchor,
                constant: 4
            ),
            titleLabel.leadingAnchor.constraint(
                equalTo: posterImageView.trailingAnchor,
                constant: 12
            ),
            titleLabel.trailingAnchor.constraint(
                equalTo: selectedIconImageView.leadingAnchor,
                constant: -12
            ),

            detailsLabel.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: 8
            ),
            detailsLabel.leadingAnchor.constraint(
                equalTo: titleLabel.leadingAnchor
            ),
            detailsLabel.trailingAnchor.constraint(
                equalTo: titleLabel.trailingAnchor
            ),
            detailsLabel.bottomAnchor.constraint(
                lessThanOrEqualTo: posterImageView.bottomAnchor
            )
        ])
    }

    private func makeDetails(
        for movie: Movie
    ) -> String {
        var components: [String] = []

        if !movie.genres.isEmpty {
            components.append(
                movie.genres.joined(separator: ", ")
            )
        }

        if let rating = movie.rating.average {
            components.append(
                String(format: L10n.string("movie.rating") + ": %.1f", rating)
            )
        }

        if let premiered = movie.premiered,
           !premiered.isEmpty {
            components.append(premiered)
        }

        return components.joined(separator: "\n")
    }

    private func loadPoster(
        urlString: String?
    ) {
        imageTask?.cancel()

        posterImageView.image = UIImage(
            systemName: "film"
        )

        guard let urlString,
              let url = URL(string: urlString)
        else {
            return
        }

        imageTask = Task { [weak self] in
            do {
                let image = try await RemoteImageLoader.shared.image(
                    from: url
                )

                guard !Task.isCancelled else {
                    return
                }

                self?.posterImageView.image = image
            } catch {
                guard !Task.isCancelled else {
                    return
                }

                self?.posterImageView.image = UIImage(
                    systemName: "film"
                )
            }
        }
    }
}

