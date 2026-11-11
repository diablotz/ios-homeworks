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
    
    // для external services
    var onMusicTapped: ((
        UUID,
        String
    ) -> Void)?

    var onExternalLinkTapped: ((String) -> Void)?

    private var remoteImageTask: Task<Void, Never>?
    private var currentPostID: UUID?
    private var externalStoreURL: String?
    private var currentExternalMediaURL: String?

    private var postImageHeightConstraint: NSLayoutConstraint?



    



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
        
        remoteImageTask?.cancel()
        remoteImageTask = nil

        currentPostID = nil
        externalStoreURL = nil

        onMusicTapped = nil
        onExternalLinkTapped = nil

        remoteImageActivityIndicator.stopAnimating()

        musicPlayButton.isHidden = true
        movieLinkButton.isHidden = true
        setMusicPlaying(false)
        
        remoteImageActivityIndicator.stopAnimating()

        currentExternalMediaURL = nil
        stopVideo()
        
    }

    func configure(
        with post: FeedPost
    ) {
        remoteImageTask?.cancel()
        remoteImageTask = nil

        currentPostID = post.id
        currentVideoName = post.videoName
        currentExternalMediaURL = post.externalMediaURL
        externalStoreURL = post.externalStoreURL

        musicPlayButton.isHidden = true
        setMusicPlaying(false)

        

        authorButton.setTitle(
            post.authorName,
            for: .normal
        )

        avatarImageView.image =
            UIImage(
                named: post.authorAvatarName ?? ""
            )
            ?? PostImageLoader.image(
                named: post.authorAvatarName
            )
            ?? UIImage(
                systemName: "person.crop.circle.fill"
            )

        

        dateLabel.text = post.createdAt.formatted(
            date: .abbreviated,
            time: .shortened
        )

        

        let descriptionText: String

        switch post.mediaType {
        case .movie, .music:
            descriptionText = makeExternalDescription(
                title: post.externalTitle,
                subtitle: post.externalSubtitle,
                postText: post.text
            )

        case .text, .image, .video:
            descriptionText = post.text
        }

        descriptionLabel.text = descriptionText

        let normalizedDescription = descriptionText
            .trimmingCharacters(
                in: .whitespacesAndNewlines
            )

        descriptionLabel.isHidden =
            normalizedDescription.isEmpty

       

        let shouldShowReadMore =
            normalizedDescription.count > 180

        readMoreButton.isHidden =
            !shouldShowReadMore

        descriptionLabel.numberOfLines =
            shouldShowReadMore ? 3 : 0

        

        likeButton.setTitle(
            " \(post.likesCount)",
            for: .normal
        )

        likeButton.setImage(
            UIImage(
                systemName: post.isLiked
                    ? "heart.fill"
                    : "heart"
            ),
            for: .normal
        )

        likeButton.tintColor = post.isLiked
            ? .systemRed
            : AppColors.secondaryText

        commentsLabel.text =
            "💬 \(post.commentsCount)"

        sharesLabel.text =
            "↗ \(post.sharesCount)"

        viewsLabel.text =
            "◉ \(post.viewsCount)"

       
        let videoName = validMediaName(
            post.videoName
        )

        let imageName = validMediaName(
            post.imageName
        )

        let externalImageURL = validMediaName(
            post.externalImageURL
        )

        let hasVideo = videoName != nil
        let hasLocalImage = imageName != nil
        let hasExternalImage = externalImageURL != nil

        let hasMedia =
            hasVideo
            || hasLocalImage
            || hasExternalImage

        postImageAspectConstraint.isActive = false
        postImageZeroHeightConstraint.isActive = false

        if hasMedia {
            postImageAspectConstraint.isActive = true
        } else {
            postImageZeroHeightConstraint.isActive = true
        }

        

        switch post.mediaType {
        case .video:
            guard let videoName else {
                configureEmptyMedia()
                break
            }

            print(
                "Пост содержит видео:",
                videoName
            )

            // Это  прежний рабочий метод
            configureVideo(
                fileName: videoName
            )

        case .image:
            guard let imageName else {
                configureEmptyMedia()
                break
            }

            configureLocalImage(
                imageName: imageName
            )

            
        case .movie:
            stopVideo()

            postImageView.isHidden = false
            postImageView.image = nil
            postImageView.backgroundColor =
                AppColors.secondaryBackground
            postImageView.contentMode = .scaleAspectFit
            postImageView.tintColor =
                AppColors.secondaryText

            playImageView.isHidden = true
            musicPlayButton.isHidden = true

            movieLinkButton.isHidden =
                post.externalStoreURL == nil

            loadRemoteImage(
                urlString: externalImageURL,
                placeholderName: "film"
            )

            contentView.bringSubviewToFront(
                movieLinkButton
            )

            print("Фильм:")
            print(
                "externalStoreURL:",
                post.externalStoreURL ?? "nil"
            )


//        case .movie:
//            stopVideo()
//
//            postImageView.isHidden = false
//            postImageView.image = nil
//            postImageView.backgroundColor =
//                AppColors.secondaryBackground
//            postImageView.contentMode = .scaleAspectFit
//            postImageView.tintColor =
//                AppColors.secondaryText
//
//            playImageView.isHidden = true
//            musicPlayButton.isHidden = true
//
//            loadRemoteImage(
//                urlString: externalImageURL,
//                placeholderName: "film"
//            )
//
//            print("Пост содержит фильм:")
//            print(
//                "Название:",
//                post.externalTitle ?? "nil"
//            )
//            print(
//                "Постер:",
//                externalImageURL ?? "nil"
//            )

        case .music:
            stopVideo()

            postImageView.isHidden = false
            postImageView.image = nil
            postImageView.backgroundColor =
                AppColors.secondaryBackground
            postImageView.contentMode = .scaleAspectFit
            postImageView.tintColor =
                AppColors.secondaryText

            playImageView.isHidden = true
            movieLinkButton.isHidden = true

            musicPlayButton.isHidden =
                post.externalMediaURL == nil

            loadRemoteImage(
                urlString: externalImageURL,
                placeholderName: "music.note"
            )

            contentView.bringSubviewToFront(
                musicPlayButton
            )

            print("Музыка:")
            print(
                "externalMediaURL:",
                post.externalMediaURL ?? "nil"
            )


//        case .music:
//            stopVideo()
//
//            postImageView.isHidden = false
//            postImageView.image = nil
//            postImageView.backgroundColor =
//                AppColors.secondaryBackground
//            postImageView.contentMode = .scaleAspectFit
//            postImageView.tintColor =
//                AppColors.secondaryText
//
//            playImageView.isHidden = true
//
//            musicPlayButton.isHidden =
//                post.externalMediaURL == nil
//
//            loadRemoteImage(
//                urlString: externalImageURL,
//                placeholderName: "music.note"
//            )
//
//            print("Пост содержит музыку:")
//            print(
//                "Название:",
//                post.externalTitle ?? "nil"
//            )
//            print(
//                "Обложка:",
//                externalImageURL ?? "nil"
//            )
//            print(
//                "Preview:",
//                post.externalMediaURL ?? "nil"
//            )

        case .text:
            configureEmptyMedia()
        }

        setNeedsLayout()
    }



//    func configure(with post: FeedPost) {
//        currentPostID = post.id
//        currentExternalMediaURL = post.externalMediaURL
//        externalStoreURL = post.externalStoreURL
//
//        remoteImageTask?.cancel()
//        remoteImageTask = nil
//
//        musicPlayButton.isHidden = true
//        setMusicPlaying(false)
//
//        updateMediaHeight(
//            for: post
//        )
//
//        switch post.mediaType {
//        case .text:
//            postImageView.image = nil
//            postImageView.isHidden = true
//
//            descriptionLabel.text = post.text
//
//        case .image:
//            postImageView.isHidden = false
//            postImageView.contentMode = .scaleAspectFill
//
//            if let imageName = post.imageName {
//                postImageView.image = UIImage(
//                    named: imageName
//                )
//            } else {
//                postImageView.image = nil
//            }
//
//            descriptionLabel.text = post.text
//
//        case .video:
//            postImageView.isHidden = false
//            postImageView.contentMode = .scaleAspectFill
//
//            configureVideoPost(
//                post
//            )
//
//            descriptionLabel.text = post.text
//
//        case .movie:
//            postImageView.isHidden = false
//            postImageView.contentMode = .scaleAspectFit
//            postImageView.backgroundColor =
//                UIColor.secondarySystemBackground
//
//            loadRemoteImage(
//                urlString: post.externalImageURL,
//                placeholderName: "film"
//            )
//
//            descriptionLabel.text = makeExternalDescription(
//                title: post.externalTitle,
//                subtitle: post.externalSubtitle,
//                postText: post.text
//            )
//
//        case .music:
//            postImageView.isHidden = false
//            postImageView.contentMode = .scaleAspectFit
//            postImageView.backgroundColor =
//                UIColor.secondarySystemBackground
//
//            musicPlayButton.isHidden =
//                post.externalMediaURL == nil
//
//            loadRemoteImage(
//                urlString: post.externalImageURL,
//                placeholderName: "music.note"
//            )
//
//            descriptionLabel.text = makeExternalDescription(
//                title: post.externalTitle,
//                subtitle: post.externalSubtitle,
//                postText: post.text
//            )
//        }
//
//
//    }
//    
//    func configure(with post: FeedPost) {
//        
//        updateMediaHeight(for: post)
//        
//        currentExternalMediaURL = post.externalMediaURL
//        //currentPostID = post.id
//        currentVideoName = post.videoName
//        //onVideoTapped = nil
//        
//        // Автор
//        authorButton.setTitle(post.authorName, for: .normal)
//        
//        avatarImageView.image =
//            UIImage(named: post.authorAvatarName ?? "")
//            ?? PostImageLoader.image(
//                named: post.authorAvatarName
//            )
//            ?? UIImage(
//                systemName: "person.crop.circle.fill"
//            )
//
//
//        // Дата и текст публикации
//        dateLabel.text = post.createdAt.formatted(
//                    date: .abbreviated,
//                    time: .shortened
//                )
//        descriptionLabel.text = post.text
//
//        let postText = post.text.trimmingCharacters(
//            in: .whitespacesAndNewlines
//        )
//
//        descriptionLabel.isHidden = postText.isEmpty
//
//        // Кнопка «Показать ещё»
//        let shouldShowReadMore = postText.count > 180
//
//        readMoreButton.isHidden = !shouldShowReadMore
//        descriptionLabel.numberOfLines = shouldShowReadMore ? 3 : 0
//
//        // Счётчики
//        likeButton.setTitle(
//            " \(post.likesCount)",
//            for: .normal
//        )
//
//        likeButton.setImage(
//            UIImage(systemName: post.isLiked ? "heart.fill" : "heart"),
//            for: .normal
//        )
//
//        likeButton.tintColor = post.isLiked
//            ? .systemRed
//            : AppColors.secondaryText
//
//        commentsLabel.text = "💬 \(post.commentsCount)"
//        sharesLabel.text = "↗ \(post.sharesCount)"
//        viewsLabel.text = "◉ \(post.viewsCount)"
//        
//        let videoName = validMediaName(post.videoName)
//        let imageName = validMediaName(post.imageName)
//        
//        let hasVideo = videoName != nil
//        let hasImage = imageName != nil
//        let hasMedia = hasVideo || hasImage
//
//        postImageAspectConstraint.isActive = false
//        postImageZeroHeightConstraint.isActive = false
//
//        if hasMedia {
//            postImageAspectConstraint.isActive = true
//        } else {
//            postImageZeroHeightConstraint.isActive = true
//        }
//
//        if let videoName = post.videoName,
//           !videoName.isEmpty {
//
//            print("Пост содержит видео:", videoName)
//
//            configureVideo(
//                fileName: videoName
//            )
//
//        } else if let imageName = post.imageName,
//                  !imageName.isEmpty {
//            stopVideo()
//
//            print("===== ЗАГРУЗКА КАРТИНКИ =====")
//            print("Название из Core Data:", imageName)
//            print(
//                "UIImage(named:):",
//                UIImage(named: imageName) as Any
//            )
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
//                print("ИТОГ: картинка не найдена:", imageName)
//            } else {
//                print("ИТОГ: картинка загружена:", imageName)
//            }
//        }
//
//
//        else {
//            print("Пост без изображения и видео:", post.id)
//
//            stopVideo()
//
//            postImageView.image = nil
//            postImageView.backgroundColor = .clear
//            postImageView.isHidden = true
//        }
//        
//        
//        remoteImageTask?.cancel()
//        remoteImageTask = nil
//
//        currentPostID = post.id
//        externalStoreURL = post.externalStoreURL
//
//        musicPlayButton.isHidden = true
//        setMusicPlaying(false)
//
//
//        setNeedsLayout()
//
//
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
    
    private func configureMoviePost(
        _ post: FeedPost
    ) {
        musicPlayButton.isHidden = true

        postImageView.contentMode = .scaleAspectFit
        postImageView.backgroundColor = UIColor.secondarySystemBackground

        loadRemoteImage(
            urlString: post.externalImageURL,
            placeholderName: "film"
        )

        descriptionLabel.text = makeExternalDescription(
            title: post.externalTitle,
            subtitle: post.externalSubtitle,
            postText: post.text
        )
    }

    
    private func configureMusicPost(
        _ post: FeedPost
    ) {
        musicPlayButton.isHidden =
            post.externalMediaURL == nil

        postImageView.contentMode = .scaleAspectFit
        postImageView.backgroundColor = UIColor.secondarySystemBackground

        loadRemoteImage(
            urlString: post.externalImageURL,
            placeholderName: "music.note"
        )

        descriptionLabel.text = makeExternalDescription(
            title: post.externalTitle,
            subtitle: post.externalSubtitle,
            postText: post.text
        )
    }
    private func configureLocalImage(
        imageName: String
    ) {
        stopVideo()

        print("===== ЗАГРУЗКА КАРТИНКИ =====")
        print(
            "Название из Core Data:",
            imageName
        )

        postImageView.isHidden = false
        postImageView.backgroundColor = .clear
        postImageView.contentMode = .scaleAspectFill
        postImageView.tintColor = nil

        let image =
            UIImage(
                named: imageName
            )
            ?? PostImageLoader.image(
                named: imageName
            )

        postImageView.image = image
        playImageView.isHidden = true
        musicPlayButton.isHidden = true

        if image == nil {
            postImageView.backgroundColor =
                AppColors.secondaryBackground

            print(
                "ИТОГ: картинка не найдена:",
                imageName
            )
        } else {
            print(
                "ИТОГ: картинка загружена:",
                imageName
            )
        }
    }


    private func configureEmptyMedia() {
        stopVideo()

        postImageView.image = nil
        postImageView.backgroundColor = .clear
        postImageView.isHidden = true

        playImageView.isHidden = true
        musicPlayButton.isHidden = true
    }



    private func makeExternalDescription(
        title: String?,
        subtitle: String?,
        postText: String
    ) -> String {
        var components: [String] = []

        if let title {
            let normalizedTitle = title.trimmingCharacters(
                in: .whitespacesAndNewlines
            )

            if !normalizedTitle.isEmpty {
                components.append(
                    normalizedTitle
                )
            }
        }

        if let subtitle {
            let normalizedSubtitle =
                subtitle.trimmingCharacters(
                    in: .whitespacesAndNewlines
                )

            if !normalizedSubtitle.isEmpty {
                components.append(
                    normalizedSubtitle
                )
            }
        }

        let normalizedText =
            postText.trimmingCharacters(
                in: .whitespacesAndNewlines
            )

        if !normalizedText.isEmpty {
            components.append(
                normalizedText
            )
        }

        return components.joined(
            separator: "\n"
        )
    }



//    // формирование текста поста
//    private func makeExternalDescription(
//        title: String?,
//        subtitle: String?,
//        postText: String
//    ) -> String {
//        var components: [String] = []
//
//        if let title,
//           !title.isEmpty {
//            components.append(title)
//        }
//
//        if let subtitle,
//           !subtitle.isEmpty {
//            components.append(subtitle)
//        }
//
//        let normalizedText = postText.trimmingCharacters(
//            in: .whitespacesAndNewlines
//        )
//
//        if !normalizedText.isEmpty {
//            components.append(normalizedText)
//        }
//
//        return components.joined(
//            separator: "\n"
//        )
//    }

    // загрузкка обложки-картинки
    private func loadRemoteImage(
        urlString: String?,
        placeholderName: String
    ) {
        remoteImageTask?.cancel()

        postImageView.image = UIImage(
            systemName: placeholderName
        )
        postImageView.tintColor = .secondaryLabel

        guard let urlString,
              let url = URL(string: urlString)
        else {
            return
        }

        remoteImageActivityIndicator.startAnimating()

        remoteImageTask = Task { [weak self] in
            guard let self else {
                return
            }

            do {
                let image = try await RemoteImageLoader.shared.image(
                    from: url
                )

                guard !Task.isCancelled else {
                    return
                }

                postImageView.image = image
                postImageView.tintColor = nil
                remoteImageActivityIndicator.stopAnimating()
            } catch {
                guard !Task.isCancelled else {
                    return
                }

                postImageView.image = UIImage(
                    systemName: placeholderName
                )
                remoteImageActivityIndicator.stopAnimating()

                print(
                    "Не удалось загрузить изображение:",
                    urlString
                )
            }
        }
    }



    private let movieLinkButton: UIButton = {
        var configuration = UIButton.Configuration.filled()

        configuration.title = L10n.string("post.movie_details")
        configuration.image = UIImage(
            systemName: "arrow.up.right.square"
        )
        configuration.imagePadding = 8
        configuration.cornerStyle = .capsule
        configuration.baseBackgroundColor =
            UIColor.black.withAlphaComponent(0.72)
        configuration.baseForegroundColor = .white

        let button = UIButton(
            configuration: configuration
        )

        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()


    
    private let musicPlayButton: UIButton = {
        let button = UIButton(type: .system)

        let configuration = UIImage.SymbolConfiguration(
            pointSize: 54,
            weight: .regular
        )

        button.setImage(
            UIImage(
                systemName: "play.circle.fill",
                withConfiguration: configuration
            ),
            for: .normal
        )

        button.tintColor = .white
        button.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        button.layer.cornerRadius = 35
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()

    // индикатор загрузки
    private let remoteImageActivityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(
            style: .large
        )

        indicator.color = .secondaryLabel
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false

        return indicator
    }()












    private func setupView() {
        
        contentView.backgroundColor = AppColors.background
        contentView.layer.cornerRadius = AppLayout.cornerRadius
        contentView.clipsToBounds = true
        
        

        musicPlayButton.addTarget(
            self,
            action: #selector(musicPlayButtonTapped),
            for: .touchUpInside
        )
        
        movieLinkButton.addTarget(
            self,
            action: #selector(movieLinkButtonTapped),
            for: .touchUpInside
        )



        postImageView.isUserInteractionEnabled = true

        let imageTapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(postImageTapped)
        )

        postImageView.addGestureRecognizer(
            imageTapGesture
        )


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
        
        contentView.addSubview(musicPlayButton)
        contentView.addSubview(remoteImageActivityIndicator)
        contentView.addSubview(movieLinkButton)


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
            
            musicPlayButton.centerXAnchor.constraint(
                equalTo: postImageView.centerXAnchor
            ),
            musicPlayButton.centerYAnchor.constraint(
                equalTo: postImageView.centerYAnchor
            ),
            musicPlayButton.widthAnchor.constraint(
                equalToConstant: 70
            ),
            musicPlayButton.heightAnchor.constraint(
                equalToConstant: 70
            ),
            
            movieLinkButton.trailingAnchor.constraint(
                    equalTo: postImageView.trailingAnchor,
                    constant: -16
                ),
                movieLinkButton.bottomAnchor.constraint(
                    equalTo: postImageView.bottomAnchor,
                    constant: -16
                ),
                movieLinkButton.heightAnchor.constraint(
                    greaterThanOrEqualToConstant: 44
                ),


            remoteImageActivityIndicator.centerXAnchor.constraint(
                equalTo: postImageView.centerXAnchor
            ),
            remoteImageActivityIndicator.centerYAnchor.constraint(
                equalTo: postImageView.centerYAnchor
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
        postImageHeightConstraint = postImageView.heightAnchor.constraint(
            equalTo: postImageView.widthAnchor,
            multiplier: 0.75
        )

        postImageHeightConstraint?.isActive = true
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
    
    
    func setMusicPlaying(
        _ isPlaying: Bool
    ) {
        let imageName = isPlaying
            ? "pause.circle.fill"
            : "play.circle.fill"

        let configuration = UIImage.SymbolConfiguration(
            pointSize: 54,
            weight: .regular
        )

        musicPlayButton.setImage(
            UIImage(
                systemName: imageName,
                withConfiguration: configuration
            ),
            for: .normal
        )
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
    
    

    @objc private func musicPlayButtonTapped() {
        guard let currentPostID,
              let mediaURL = currentExternalMediaURL
        else {
            return
        }

        onMusicTapped?(
            currentPostID,
            mediaURL
        )
    }
    
    @objc private func movieLinkButtonTapped() {
        guard let externalStoreURL,
              !externalStoreURL.isEmpty
        else {
            print(
                "У фильма отсутствует ссылка"
            )
            return
        }

        print(
            "Нажата кнопка фильма:",
            externalStoreURL
        )

        onExternalLinkTapped?(
            externalStoreURL
        )
    }


    
    
    @objc private func postImageTapped() {
        guard let externalStoreURL,
              !externalStoreURL.isEmpty
        else {
            return
        }

        onExternalLinkTapped?(
            externalStoreURL
        )
    }
    
    private func updateMediaHeight(
        for post: FeedPost
    ) {
        postImageHeightConstraint?.isActive = false

        switch post.mediaType {
        case .text:
            postImageHeightConstraint =
                postImageView.heightAnchor.constraint(
                    equalToConstant: 0
                )

        case .movie:
            postImageHeightConstraint =
                postImageView.heightAnchor.constraint(
                    equalTo: postImageView.widthAnchor,
                    multiplier: 1.15
                )

        case .music:
            postImageHeightConstraint =
                postImageView.heightAnchor.constraint(
                    equalTo: postImageView.widthAnchor,
                    multiplier: 0.75
                )

        case .image, .video:
            postImageHeightConstraint =
                postImageView.heightAnchor.constraint(
                    equalTo: postImageView.widthAnchor,
                    multiplier: 0.75
                )
        }

        postImageHeightConstraint?.isActive = true
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
