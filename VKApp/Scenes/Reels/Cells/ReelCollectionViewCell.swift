//
//  ReelCollectionViewCell.swift
//  VKApp
//
//  Created by Timur Zakirov on 03/10/26.
//

import AVFoundation
import UIKit

final class ReelCollectionViewCell:
    UICollectionViewCell {

    static let reuseIdentifier =
        "ReelCollectionViewCell"

    var onLike: (() -> Void)?
    var onSave: (() -> Void)?

    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?

    private let fallbackLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = AppFonts.body
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let authorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = AppFonts.headline
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let captionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = AppFonts.body
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var likeButton = makeActionButton()
    private lazy var commentButton = makeActionButton()
    private lazy var shareButton = makeActionButton()
    private lazy var saveButton = makeActionButton()

    private lazy var actionsStackView: UIStackView = {
        let stack = UIStackView(
            arrangedSubviews: [
                likeButton,
                commentButton,
                shareButton,
                saveButton
            ]
        )
        stack.axis = .vertical
        stack.spacing = 18
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.backgroundColor = .black

        [
            fallbackLabel,
            authorLabel,
            captionLabel,
            actionsStackView
        ].forEach(contentView.addSubview)

        likeButton.addTarget(
            self,
            action: #selector(likeTapped),
            for: .touchUpInside
        )

        saveButton.addTarget(
            self,
            action: #selector(saveTapped),
            for: .touchUpInside
        )

        NSLayoutConstraint.activate([
            fallbackLabel.centerXAnchor.constraint(
                equalTo: contentView.centerXAnchor
            ),
            fallbackLabel.centerYAnchor.constraint(
                equalTo: contentView.centerYAnchor
            ),
            fallbackLabel.leadingAnchor.constraint(
                greaterThanOrEqualTo:
                    contentView.leadingAnchor,
                constant: 30
            ),
            fallbackLabel.trailingAnchor.constraint(
                lessThanOrEqualTo:
                    contentView.trailingAnchor,
                constant: -30
            ),

            actionsStackView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -16
            ),
            actionsStackView.bottomAnchor.constraint(
                equalTo: contentView.safeAreaLayoutGuide.bottomAnchor,
                constant: -90
            ),

            authorLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 16
            ),
            authorLabel.trailingAnchor.constraint(
                lessThanOrEqualTo:
                    actionsStackView.leadingAnchor,
                constant: -12
            ),
            authorLabel.bottomAnchor.constraint(
                equalTo: captionLabel.topAnchor,
                constant: -10
            ),

            captionLabel.leadingAnchor.constraint(
                equalTo: authorLabel.leadingAnchor
            ),
            captionLabel.trailingAnchor.constraint(
                equalTo: authorLabel.trailingAnchor
            ),
            captionLabel.bottomAnchor.constraint(
                equalTo: contentView.safeAreaLayoutGuide.bottomAnchor,
                constant: -28
            )
        ])
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is unavailable")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = contentView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        player?.pause()

        NotificationCenter.default.removeObserver(
            self,
            name: .AVPlayerItemDidPlayToEndTime,
            object: nil
        )

        playerLayer?.removeFromSuperlayer()
        playerLayer = nil
        player = nil

        fallbackLabel.text = nil
        onLike = nil
        onSave = nil
    }





//    override func prepareForReuse() {
//        super.prepareForReuse()
//
//        stop()
//        playerLayer?.removeFromSuperlayer()
//        playerLayer = nil
//        player = nil
//        onLike = nil
//        onSave = nil
//    }

    func configure(with reel: ReelItem) {
        
        stop()
        
        NotificationCenter.default.removeObserver(
                self,
                name: .AVPlayerItemDidPlayToEndTime,
                object: nil
        )

        playerLayer?.removeFromSuperlayer()
        playerLayer = nil
        player = nil
        
        
        authorLabel.text = reel.authorName
        captionLabel.text = reel.captionText

        configure(
            button: likeButton,
            imageName: reel.isLiked
                ? "heart.fill"
                : "heart",
            title: reel.likesCount.formatted()
        )

        configure(
            button: commentButton,
            imageName: "bubble.right",
            title: reel.commentsCount.formatted()
        )

        configure(
            button: shareButton,
            imageName: "arrowshape.turn.up.right",
            title: reel.sharesCount.formatted()
        )

        configure(
            button: saveButton,
            imageName: reel.isSaved
                ? "bookmark.fill"
                : "bookmark",
            title: ""
        )
        
        
        guard
            let url = LocalVideoStore.shared.url(
                for: reel.videoName
            )
        else {
            fallbackLabel.text =
                "Не найдено видео \(reel.videoName)"
            fallbackLabel.isHidden = false
            return
        }



//        guard
//            let url = Bundle.main.url(
//                forResource: reel.videoName,
//                withExtension: "mp4"
//            )
//        else {
//            fallbackLabel.text =
//                "Добавьте \(reel.videoName).mp4 в Target VKApp"
//            fallbackLabel.isHidden = false
//            return
//        }

        fallbackLabel.isHidden = true

        let player = AVPlayer(url: url)
        player.actionAtItemEnd = .none

        let layer = AVPlayerLayer(player: player)
        layer.videoGravity = .resizeAspectFill
        layer.frame = contentView.bounds

        contentView.layer.insertSublayer(layer, at: 0)

        self.player = player
        self.playerLayer = layer

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playerDidFinish),
            name: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem
        )
    }
    
    func play() {
        guard let player else {
            return
        }

        player.play()
    }

    func pause() {
        player?.pause()
    }

    func stop() {
        guard let player else {
            return
        }

        player.pause()
        player.seek(
            to: .zero,
            toleranceBefore: .zero,
            toleranceAfter: .zero
        )
    }





//    func play() {
//        player?.play()
//    }
//
//    func stop() {
//        player?.pause()
//        player?.seek(to: .zero)
//
//        NotificationCenter.default.removeObserver(
//            self,
//            name: .AVPlayerItemDidPlayToEndTime,
//            object: nil
//        )
//    }

    private func makeActionButton() -> UIButton {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = AppFonts.caption
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.textAlignment = .center
        button.widthAnchor.constraint(
            equalToConstant: 54
        ).isActive = true
        button.heightAnchor.constraint(
            equalToConstant: 54
        ).isActive = true
        return button
    }

    private func configure(
        button: UIButton,
        imageName: String,
        title: String
    ) {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(
            systemName: imageName
        )
        configuration.title = title
        configuration.imagePlacement = .top
        configuration.imagePadding = 4
        configuration.baseForegroundColor = .white

        button.configuration = configuration
    }

    @objc private func likeTapped() {
        onLike?()
    }

    @objc private func saveTapped() {
        onSave?()
    }

    @objc private func playerDidFinish() {
        player?.seek(
            to: .zero,
            toleranceBefore: .zero,
            toleranceAfter: .zero
        ) { [weak self] finished in
            guard finished else {
                return
            }

            self?.player?.play()
        }
    }


}
