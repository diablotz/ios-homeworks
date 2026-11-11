//
//  MusicTableViewCell.swift
//  VKApp
//
//  Created by Timur Zakirov on 03/11/26.
//

import UIKit

@MainActor
final class MusicTableViewCell: UITableViewCell {

    static let reuseIdentifier = "MusicTableViewCell"

    var onPlayTapped: (() -> Void)?

    private var imageTask: Task<Void, Never>?

    private let artworkImageView: UIImageView = {
        let imageView = UIImageView()

        imageView.image = UIImage(
            systemName: "music.note"
        )
        imageView.tintColor = UIColor.secondaryLabel
        imageView.backgroundColor = UIColor.secondarySystemBackground
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()

        label.font = AppFonts.body
        label.textColor = AppColors.primaryText
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private let artistLabel: UILabel = {
        let label = UILabel()

        label.font = AppFonts.caption
        label.textColor = AppColors.secondaryText
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private let playButton: UIButton = {
        let button = UIButton(type: .system)

        button.tintColor = UIColor.systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()

    private let selectedImageView: UIImageView = {
        let imageView = UIImageView()

        imageView.image = UIImage(
            systemName: "checkmark.circle.fill"
        )
        imageView.tintColor = UIColor.systemBlue
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
        onPlayTapped = nil

        artworkImageView.image = UIImage(
            systemName: "music.note"
        )

        titleLabel.text = nil
        artistLabel.text = nil
        selectedImageView.isHidden = true

        configurePlayButton(
            isPlaying: false
        )
    }

    func configure(
        with track: MusicTrack,
        isSelected: Bool,
        isPlaying: Bool
    ) {
        titleLabel.text = track.trackName

        if let collectionName = track.collectionName,
           !collectionName.isEmpty {
            artistLabel.text =
                "\(track.artistName)\n\(collectionName)"
        } else {
            artistLabel.text = track.artistName
        }

        selectedImageView.isHidden = !isSelected

        configurePlayButton(
            isPlaying: isPlaying
        )

        loadArtwork(
            urlString: track.artworkUrl100
        )
    }

    private func setupView() {
        backgroundColor = AppColors.background
        selectionStyle = .none

        contentView.addSubview(artworkImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(artistLabel)
        contentView.addSubview(playButton)
        contentView.addSubview(selectedImageView)

        playButton.addTarget(
            self,
            action: #selector(playButtonTapped),
            for: .touchUpInside
        )
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            artworkImageView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 10
            ),
            artworkImageView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: AppLayout.horizontalInset
            ),
            artworkImageView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -10
            ),
            artworkImageView.widthAnchor.constraint(
                equalToConstant: 72
            ),
            artworkImageView.heightAnchor.constraint(
                equalToConstant: 72
            ),

            playButton.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -AppLayout.horizontalInset
            ),
            playButton.centerYAnchor.constraint(
                equalTo: contentView.centerYAnchor
            ),
            playButton.widthAnchor.constraint(
                equalToConstant: 44
            ),
            playButton.heightAnchor.constraint(
                equalToConstant: 44
            ),

            selectedImageView.trailingAnchor.constraint(
                equalTo: playButton.leadingAnchor,
                constant: -8
            ),
            selectedImageView.centerYAnchor.constraint(
                equalTo: contentView.centerYAnchor
            ),
            selectedImageView.widthAnchor.constraint(
                equalToConstant: 22
            ),
            selectedImageView.heightAnchor.constraint(
                equalToConstant: 22
            ),

            titleLabel.topAnchor.constraint(
                equalTo: artworkImageView.topAnchor,
                constant: 4
            ),
            titleLabel.leadingAnchor.constraint(
                equalTo: artworkImageView.trailingAnchor,
                constant: 12
            ),
            titleLabel.trailingAnchor.constraint(
                equalTo: selectedImageView.leadingAnchor,
                constant: -8
            ),

            artistLabel.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: 5
            ),
            artistLabel.leadingAnchor.constraint(
                equalTo: titleLabel.leadingAnchor
            ),
            artistLabel.trailingAnchor.constraint(
                equalTo: titleLabel.trailingAnchor
            ),
            artistLabel.bottomAnchor.constraint(
                lessThanOrEqualTo: artworkImageView.bottomAnchor
            )
        ])
    }

    private func configurePlayButton(
        isPlaying: Bool
    ) {
        let imageName = isPlaying
            ? "pause.circle.fill"
            : "play.circle.fill"

        let configuration = UIImage.SymbolConfiguration(
            pointSize: 30,
            weight: .regular
        )

        playButton.setImage(
            UIImage(
                systemName: imageName,
                withConfiguration: configuration
            ),
            for: .normal
        )
    }

    private func loadArtwork(
        urlString: String?
    ) {
        imageTask?.cancel()

        artworkImageView.image = UIImage(
            systemName: "music.note"
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

                self?.artworkImageView.image = image
            } catch {
                self?.artworkImageView.image = UIImage(
                    systemName: "music.note"
                )
            }
        }
    }

    @objc private func playButtonTapped() {
        onPlayTapped?()
    }
}

