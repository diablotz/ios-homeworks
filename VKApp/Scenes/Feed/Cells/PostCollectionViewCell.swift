//
//  PostCollectionViewCell.swift
//  VKApp
//
//  Created by Timur Zakirov on 01/10/26.
//

import UIKit
import AVKit
import AVFoundation

final class PostCollectionViewCell: UICollectionViewCell {

    static let reuseIdentifier = "PostCollectionViewCell"

    var onLike: (() -> Void)?
    var onReadMore: (() -> Void)?
    var onAuthor: (() -> Void)?
    
    //var onVideoTapped:((String) -> Void)?
    private var currentVideoName: String?
    //private var currentPostID: UUID?
    
    private var videoPlayer: AVPlayer?
    private var videoPlayerLayer: AVPlayerLayer?
    


    



    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = AppColors.secondaryBackground
        imageView.layer.cornerRadius = 22
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var authorButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.baseForegroundColor = AppColors.primaryText
        configuration.contentInsets = .zero

        let button = UIButton(configuration: configuration)
        button.contentHorizontalAlignment = .leading
        button.titleLabel?.font = AppFonts.headline
        button.translatesAutoresizingMaskIntoConstraints = false

        button.addTarget(
            self,
            action: #selector(authorTapped),
            for: .touchUpInside
        )

        return button
    }()
    
    private lazy var postImageAspectConstraint: NSLayoutConstraint = {
        postImageView.heightAnchor.constraint(
            equalTo: postImageView.widthAnchor,
            multiplier: 0.75
        )
    }()

    private lazy var postImageZeroHeightConstraint: NSLayoutConstraint = {
        postImageView.heightAnchor.constraint(equalToConstant: 0)
    }()



    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.caption
        label.textColor = AppColors.secondaryText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private let playImageView: UIImageView = {
        let imageView = UIImageView(
            image: UIImage(systemName: "play.circle.fill")
        )

        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true

        return imageView
    }()





    private let postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = AppColors.secondaryBackground
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.body
        label.textColor = AppColors.primaryText
        label.numberOfLines = 3
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var readMoreButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.title = "Читать далее"
        configuration.baseForegroundColor = AppColors.vkBlue
        configuration.contentInsets = .zero

        let button = UIButton(configuration: configuration)
        button.contentHorizontalAlignment = .leading
        button.translatesAutoresizingMaskIntoConstraints = false

        button.addTarget(
            self,
            action: #selector(readMoreTapped),
            for: .touchUpInside
        )

        return button
    }()

    private lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = AppColors.primaryText
        button.translatesAutoresizingMaskIntoConstraints = false

        button.addTarget(
            self,
            action: #selector(likeTapped),
            for: .touchUpInside
        )

        return button
    }()

    private let commentsLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.subheadline
        label.textColor = AppColors.primaryText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let sharesLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.subheadline
        label.textColor = AppColors.primaryText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let viewsLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.caption
        label.textColor = AppColors.secondaryText
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
        setupLayout()
        //videoPlayerLayer?.frame = postImageView.bounds
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is unavailable")
    }
    // 123
    override func layoutSubviews() {
        super.layoutSubviews()

        videoPlayerLayer?.frame = postImageView.bounds
    }



    override func prepareForReuse() {
        super.prepareForReuse()
        
        stopVideo()

        avatarImageView.image = nil
        authorButton.setTitle(nil, for: .normal)
        dateLabel.text = nil
        descriptionLabel.text = nil

        postImageView.image = nil
        postImageView.isHidden = false
        postImageView.contentMode = .scaleAspectFill
        postImageView.tintColor = nil

        playImageView.isHidden = true
        readMoreButton.isHidden = true

        likeButton.setTitle(nil, for: .normal)
        commentsLabel.text = nil
        sharesLabel.text = nil
        viewsLabel.text = nil

        postImageZeroHeightConstraint.isActive = false
        postImageAspectConstraint.isActive = true
    }


    
    func configure(with post: FeedPost) {
        
        //currentPostID = post.id
        currentVideoName = post.videoName
        //onVideoTapped = nil
        
        // Автор
        authorButton.setTitle(post.authorName, for: .normal)
        
        avatarImageView.image =
            UIImage(named: post.authorAvatarName ?? "")
            ?? PostImageLoader.image(
                named: post.authorAvatarName
            )
            ?? UIImage(
                systemName: "person.crop.circle.fill"
            )



//        if let avatarName = post.authorAvatarName,
//           !avatarName.isEmpty {
//            avatarImageView.image =
//                PostImageLoader.image(
//                    named: post.authorAvatarName
//                )
//                //?? UIImage(systemName: "person.crop.circle.fill")
//
//
//        } else {
//            avatarImageView.image = UIImage(
//                systemName: "person.crop.circle.fill"
//            )
//        }

        // Дата и текст публикации
        dateLabel.text = post.createdAt.formatted(
                    date: .abbreviated,
                    time: .shortened
                )
        descriptionLabel.text = post.text

        let postText = post.text.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        descriptionLabel.isHidden = postText.isEmpty

        // Кнопка «Показать ещё»
        let shouldShowReadMore = postText.count > 180

        readMoreButton.isHidden = !shouldShowReadMore
        descriptionLabel.numberOfLines = shouldShowReadMore ? 3 : 0

        // Счётчики
        likeButton.setTitle(
            " \(post.likesCount)",
            for: .normal
        )

        likeButton.setImage(
            UIImage(systemName: post.isLiked ? "heart.fill" : "heart"),
            for: .normal
        )

        likeButton.tintColor = post.isLiked
            ? .systemRed
            : AppColors.secondaryText

        commentsLabel.text = "💬 \(post.commentsCount)"
        sharesLabel.text = "↗ \(post.sharesCount)"
        viewsLabel.text = "◉ \(post.viewsCount)"
        
        let videoName = validMediaName(post.videoName)
        let imageName = validMediaName(post.imageName)
        
        let hasVideo = videoName != nil
        let hasImage = imageName != nil
        let hasMedia = hasVideo || hasImage

        postImageAspectConstraint.isActive = false
        postImageZeroHeightConstraint.isActive = false

        if hasMedia {
            postImageAspectConstraint.isActive = true
        } else {
            postImageZeroHeightConstraint.isActive = true
        }

        if let videoName = post.videoName,
           !videoName.isEmpty {

            print("Пост содержит видео:", videoName)

            configureVideo(
                fileName: videoName
            )

        } else if let imageName = post.imageName,
                  !imageName.isEmpty {
            stopVideo()

            print("===== ЗАГРУЗКА КАРТИНКИ =====")
            print("Название из Core Data:", imageName)
            print(
                "UIImage(named:):",
                UIImage(named: imageName) as Any
            )

            postImageView.isHidden = false
            postImageView.backgroundColor = .clear
            postImageView.contentMode = .scaleAspectFill
            postImageView.tintColor = nil

            let image =
                UIImage(named: imageName)
                ?? PostImageLoader.image(named: imageName)

            postImageView.image = image
            playImageView.isHidden = true

            if image == nil {
                postImageView.backgroundColor =
                    AppColors.secondaryBackground

                print("ИТОГ: картинка не найдена:", imageName)
            } else {
                print("ИТОГ: картинка загружена:", imageName)
            }
        }


//        } else if let imageName = post.imageName,
//                  !imageName.isEmpty {
//
//            print("Пост содержит картинку:", imageName)
//
//            stopVideo()
//
//            postImageView.isHidden = false
//            postImageView.backgroundColor = .clear
//            postImageView.contentMode = .scaleAspectFill
//            postImageView.tintColor = nil
//
//            let image =
//                UIImage(named: imageName)
//                ?? PostImageLoader.image(named: imageName)
//
//            postImageView.image = image
//            playImageView.isHidden = true
//
//            if image == nil {
//                postImageView.backgroundColor =
//                    AppColors.secondaryBackground
//
//                print("Картинка не найдена:", imageName)
//            }
//
//        }
        else {
            print("Пост без изображения и видео:", post.id)

            stopVideo()

            postImageView.image = nil
            postImageView.backgroundColor = .clear
            postImageView.isHidden = true
        }

        setNeedsLayout()


    }


//    private func makeVideoPreview(
//        videoName: String,
//        postID: UUID
//    ) {
//        postImageView.image = UIImage(systemName: "video.fill")
//        postImageView.tintColor = .systemBlue
//        postImageView.contentMode = .scaleAspectFit
//
//        guard let videoURL = LocalVideoStore.shared.url(
//            for: videoName
//        ) else {
//            print("Видео не найдено:", videoName)
//            return
//        }
//
//        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//            let asset = AVURLAsset(url: videoURL)
//            let generator = AVAssetImageGenerator(asset: asset)
//
//            generator.appliesPreferredTrackTransform = true
//            generator.maximumSize = CGSize(
//                width: 1000,
//                height: 1000
//            )
//
//            let time = CMTime(
//                seconds: 0.1,
//                preferredTimescale: 600
//            )
//
//            do {
//                let cgImage = try generator.copyCGImage(
//                    at: time,
//                    actualTime: nil
//                )
//
//                let previewImage = UIImage(cgImage: cgImage)
//
//                DispatchQueue.main.async {
//                    guard self?.currentPostID == postID else {
//                        return
//                    }
//
//                    self?.postImageView.image = previewImage
//                    self?.postImageView.tintColor = nil
//                    self?.postImageView.contentMode = .scaleAspectFill
//                }
//            } catch {
//                print(
//                    "Не удалось получить кадр видео:",
//                    error.localizedDescription
//                )
//            }
//        }
//    }
    // 12345
    private func configureVideo(
        fileName: String
    ) {
        stopVideo()

        guard let videoURL = LocalVideoStore.shared.url(
            for: fileName
        ) else {
            postImageView.isHidden = false
            postImageView.image = UIImage(
                systemName: "exclamationmark.video"
            )
            postImageView.tintColor = .systemRed
            postImageView.contentMode = .scaleAspectFit

            print("Видео поста не найдено:", fileName)
            return
        }

        print("Видео поста найдено:", videoURL.path)

        currentVideoName = fileName

        postImageView.isHidden = false
        postImageView.image = nil
        postImageView.tintColor = nil
        postImageView.backgroundColor = .black

        let player = AVPlayer(url: videoURL)

        let playerLayer = AVPlayerLayer(
            player: player
        )

        playerLayer.videoGravity = .resizeAspect
        playerLayer.backgroundColor =
            UIColor.black.cgColor

        /*
         Сначала заставляем Auto Layout рассчитать
         размер postImageView.
         */
        contentView.layoutIfNeeded()

        playerLayer.frame = postImageView.bounds

        postImageView.layer.insertSublayer(
            playerLayer,
            at: 0
        )

        videoPlayer = player
        videoPlayerLayer = playerLayer

        playImageView.isHidden = false

        player.seek(
            to: CMTime(
                seconds: 0.1,
                preferredTimescale: 600
            ),
            toleranceBefore: .zero,
            toleranceAfter: .zero
        )

        setNeedsLayout()
        layoutIfNeeded()
    }


//    private func configureVideo(
//        fileName: String
//    ) {
//        stopVideo()
//
//        guard let videoURL = LocalVideoStore.shared.url(
//            for: fileName
//        ) else {
//            postImageView.image = UIImage(
//                systemName: "exclamationmark.video"
//            )
//            postImageView.tintColor = .systemRed
//            return
//        }
//
//        currentVideoName = fileName
//
//        postImageView.image = nil
//        postImageView.backgroundColor = .black
//        playImageView.isHidden = false
//
//        let player = AVPlayer(url: videoURL)
//
//        let playerLayer = AVPlayerLayer(player: player)
//        playerLayer.videoGravity = .resizeAspect
//
//        postImageView.layer.insertSublayer(
//            playerLayer,
//            at: 0
//        )
//
//        videoPlayer = player
//        videoPlayerLayer = playerLayer
//
//        player.seek(
//            to: CMTime(
//                seconds: 0.1,
//                preferredTimescale: 600
//            )
//        )
//
//        setNeedsLayout()
//    }







    private func setupView() {
        
        contentView.backgroundColor = AppColors.background
        contentView.layer.cornerRadius = AppLayout.cornerRadius
        contentView.clipsToBounds = true

        [
            avatarImageView,
            authorButton,
            dateLabel,
            postImageView,
            descriptionLabel,
            readMoreButton,
            likeButton,
            commentsLabel,
            sharesLabel,
            viewsLabel
        ].forEach(contentView.addSubview)
        postImageView.isUserInteractionEnabled = true
        postImageView.addSubview(playImageView)

        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(videoTapped)
        )

        postImageView.addGestureRecognizer(tapGesture)


    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 12
            ),
            avatarImageView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 16
            ),
            avatarImageView.widthAnchor.constraint(
                equalToConstant: 44
            ),
            avatarImageView.heightAnchor.constraint(
                equalTo: avatarImageView.widthAnchor
            ),

            authorButton.topAnchor.constraint(
                equalTo: avatarImageView.topAnchor
            ),
            authorButton.leadingAnchor.constraint(
                equalTo: avatarImageView.trailingAnchor,
                constant: 10
            ),
            authorButton.trailingAnchor.constraint(
                lessThanOrEqualTo: contentView.trailingAnchor,
                constant: -16
            ),

            dateLabel.topAnchor.constraint(
                equalTo: authorButton.bottomAnchor,
                constant: 2
            ),
            dateLabel.leadingAnchor.constraint(
                equalTo: authorButton.leadingAnchor
            ),
            dateLabel.trailingAnchor.constraint(
                lessThanOrEqualTo: contentView.trailingAnchor,
                constant: -16
            ),

            postImageView.topAnchor.constraint(
                equalTo: avatarImageView.bottomAnchor,
                constant: 12
            ),
            postImageView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor
            ),
            postImageView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor
            ),
            postImageAspectConstraint,

            descriptionLabel.topAnchor.constraint(
                equalTo: postImageView.bottomAnchor,
                constant: 12
            ),
            descriptionLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 16
            ),
            descriptionLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -16
            ),

            readMoreButton.topAnchor.constraint(
                equalTo: descriptionLabel.bottomAnchor,
                constant: 4
            ),
            readMoreButton.leadingAnchor.constraint(
                equalTo: descriptionLabel.leadingAnchor
            ),
            readMoreButton.heightAnchor.constraint(
                greaterThanOrEqualToConstant: 32
            ),

            likeButton.topAnchor.constraint(
                equalTo: readMoreButton.bottomAnchor,
                constant: 8
            ),
            likeButton.leadingAnchor.constraint(
                equalTo: descriptionLabel.leadingAnchor
            ),
            likeButton.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -12
            ),

            commentsLabel.centerYAnchor.constraint(
                equalTo: likeButton.centerYAnchor
            ),
            commentsLabel.leadingAnchor.constraint(
                equalTo: likeButton.trailingAnchor,
                constant: 18
            ),

            sharesLabel.centerYAnchor.constraint(
                equalTo: likeButton.centerYAnchor
            ),
            sharesLabel.leadingAnchor.constraint(
                equalTo: commentsLabel.trailingAnchor,
                constant: 18
            ),

            viewsLabel.centerYAnchor.constraint(
                equalTo: likeButton.centerYAnchor
            ),
            viewsLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -16
            ),
            viewsLabel.leadingAnchor.constraint(
                greaterThanOrEqualTo: sharesLabel.trailingAnchor,
                constant: 8
            ),
            playImageView.centerXAnchor.constraint(
                equalTo: postImageView.centerXAnchor
            ),
            playImageView.centerYAnchor.constraint(
                equalTo: postImageView.centerYAnchor
            ),
            playImageView.widthAnchor.constraint(
                equalToConstant: 64
            ),
            playImageView.heightAnchor.constraint(
                equalTo: playImageView.widthAnchor
            )

        ])
    }

    @objc private func likeTapped() {
        onLike?()
    }

    @objc private func readMoreTapped() {
        onReadMore?()
    }

    @objc private func authorTapped() {
        onAuthor?()
    }
    
    @objc private func videoTapped() {
        guard currentVideoName != nil,
              let videoPlayer
        else {
            return
        }

        if videoPlayer.timeControlStatus == .playing {
            videoPlayer.pause()
            playImageView.isHidden = false
        } else {
            videoPlayer.play()
            playImageView.isHidden = true
        }
    }
    
    func stopVideo() {
        videoPlayer?.pause()

        videoPlayerLayer?.player = nil
        videoPlayerLayer?.removeFromSuperlayer()

        videoPlayer = nil
        videoPlayerLayer = nil
        currentVideoName = nil

        playImageView.isHidden = true
    }

    
    private func validMediaName(
        _ value: String?
    ) -> String? {
        guard let value else {
            return nil
        }

        let trimmedValue = value.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !trimmedValue.isEmpty,
              trimmedValue != "\"\"",
              trimmedValue != "''"
        else {
            return nil
        }

        return trimmedValue
    }



    
//    func stopVideo() {
//        videoPlayer?.pause()
//
//        videoPlayerLayer?.removeFromSuperlayer()
//
//        videoPlayer = nil
//        videoPlayerLayer = nil
//        currentVideoName = nil
//
//        playImageView.isHidden = true
//    }




}
