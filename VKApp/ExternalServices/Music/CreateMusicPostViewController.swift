//
//  CreateMusicPostViewController.swift
//  VKApp
//
//  Created by Timur Zakirov on 03/11/26.
//




import AVFoundation
import UIKit

@MainActor
final class CreateMusicPostViewController:
    UIViewController {

   

    private let viewModel: CreateMusicPostViewModel

   

    private var player: AVPlayer?
    private var selectedTrack: MusicTrack?
    private var playingTrackID: Int?

    

    private lazy var searchController: UISearchController = {
        let controller = UISearchController(
            searchResultsController: nil
        )

        controller.searchResultsUpdater = self
        controller.obscuresBackgroundDuringPresentation = false
        controller.searchBar.placeholder = L10n.string(
            "music.search_placeholder"
        )

        return controller
    }()

    private let tableView: UITableView = {
        let tableView = UITableView(
            frame: .zero,
            style: .plain
        )

        tableView.rowHeight =
            UITableView.automaticDimension

        tableView.estimatedRowHeight = 92
        tableView.backgroundColor =
            AppColors.background

        tableView.keyboardDismissMode = .onDrag
        tableView.allowsSelection = true
        tableView.translatesAutoresizingMaskIntoConstraints =
            false

        return tableView
    }()

    private let emptyLabel: UILabel = {
        let label = UILabel()

        label.text = L10n.string(
            "music.search_hint"
        )

        label.font = AppFonts.body
        label.textColor =
            AppColors.secondaryText

        label.textAlignment = .center
        label.numberOfLines = 0
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints =
            false

        return label
    }()

    private let bottomContainerView: UIView = {
        let view = UIView()

        view.backgroundColor =
            AppColors.background

        view.translatesAutoresizingMaskIntoConstraints =
            false

        return view
    }()

    private let textView: UITextView = {
        let textView = UITextView()

        textView.font = AppFonts.body
        textView.textColor =
            AppColors.primaryText

        textView.backgroundColor =
            AppColors.secondaryBackground

        textView.layer.cornerRadius = 10
        textView.layer.borderWidth = 1

        textView.textContainerInset = UIEdgeInsets(
            top: 10,
            left: 10,
            bottom: 10,
            right: 10
        )

        textView.adjustsFontForContentSizeCategory = true
        textView.translatesAutoresizingMaskIntoConstraints =
            false

        return textView
    }()

    private let placeholderLabel: UILabel = {
        let label = UILabel()

        label.text = L10n.string(
            "music.caption"
        )

        label.font = AppFonts.body
        label.textColor =
            AppColors.secondaryText

        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints =
            false

        return label
    }()

    private lazy var publishButton: UIButton = {
        var configuration =
            UIButton.Configuration.filled()

        configuration.title = L10n.string(
            "music.publish"
        )

        configuration.cornerStyle = .medium
        configuration.baseBackgroundColor =
            AppColors.accent

        configuration.baseForegroundColor =
            UIColor.white

        let button = UIButton(
            configuration: configuration
        )

        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints =
            false

        button.addTarget(
            self,
            action: #selector(
                publishButtonTapped
            ),
            for: .touchUpInside
        )

        return button
    }()

    private let attributionLabel: UILabel = {
        let label = UILabel()

        label.text = L10n.string(
            "music.itunes"
        )

        label.font = UIFont.preferredFont(
            forTextStyle: .caption2
        )

        label.textColor =
            AppColors.secondaryText

        label.textAlignment = .center
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints =
            false

        return label
    }()

    private let activityIndicator =
        UIActivityIndicatorView(
            style: .medium
        )

   

    init(
        viewModel: CreateMusicPostViewModel
    ) {
        self.viewModel = viewModel

        super.init(
            nibName: nil,
            bundle: nil
        )
    }

    required init?(
        coder: NSCoder
    ) {
        fatalError(
            "init(coder:) has not been implemented"
        )
    }

    

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupTableView()
        setupNavigationBar()
        setupLayout()
        bindViewModel()
        updateThemeColors()
        updatePublishButtonState()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(
                playerItemDidFinishPlaying
            ),
            name: .AVPlayerItemDidPlayToEndTime,
            object: nil
        )
        
        registerForTraitChanges(
                [UITraitUserInterfaceStyle.self]
            ) { (controller: Self, previousTraitCollection: UITraitCollection) in
                controller.updateThemeColors()
            }

            updateThemeColors()
    }

    override func viewWillDisappear(
        _ animated: Bool
    ) {
        super.viewWillDisappear(animated)

        stopPlayback()

        if isMovingFromParent
            || navigationController?
                .isBeingDismissed == true {
            viewModel.cancelSearch()
        }
    }

//    override func traitCollectionDidChange(
//        _ previousTraitCollection:
//            UITraitCollection?
//    ) {
//        super.traitCollectionDidChange(
//            previousTraitCollection
//        )
//
//        guard previousTraitCollection?
//            .hasDifferentColorAppearance(
//                comparedTo: traitCollection
//            ) == true
//        else {
//            return
//        }
//
//        updateThemeColors()
//    }

    deinit {
        NotificationCenter.default.removeObserver(
            self
        )
    }

    

    private func setupView() {
        title = L10n.string(
            "music.create_title"
        )

        view.backgroundColor =
            AppColors.background

        definesPresentationContext = true
        textView.delegate = self

        view.addSubview(
            tableView
        )

        view.addSubview(
            emptyLabel
        )

        view.addSubview(
            bottomContainerView
        )

        bottomContainerView.addSubview(
            textView
        )

        bottomContainerView.addSubview(
            publishButton
        )

        bottomContainerView.addSubview(
            attributionLabel
        )

        textView.addSubview(
            placeholderLabel
        )

        activityIndicator.hidesWhenStopped = true
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self

        tableView.register(
            MusicTableViewCell.self,
            forCellReuseIdentifier:
                MusicTableViewCell.reuseIdentifier
        )
    }

    private func setupNavigationBar() {
        navigationItem.searchController =
            searchController

        navigationItem.hidesSearchBarWhenScrolling =
            false

        navigationItem.rightBarButtonItem = nil
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            bottomContainerView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),
            bottomContainerView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),
            bottomContainerView.bottomAnchor.constraint(
                equalTo:
                    view.keyboardLayoutGuide.topAnchor
            ),

            textView.topAnchor.constraint(
                equalTo:
                    bottomContainerView.topAnchor,
                constant: 8
            ),
            textView.leadingAnchor.constraint(
                equalTo:
                    bottomContainerView.leadingAnchor,
                constant:
                    AppLayout.horizontalInset
            ),
            textView.trailingAnchor.constraint(
                equalTo:
                    bottomContainerView.trailingAnchor,
                constant:
                    -AppLayout.horizontalInset
            ),
            textView.heightAnchor.constraint(
                equalToConstant: 72
            ),

            placeholderLabel.topAnchor.constraint(
                equalTo: textView.topAnchor,
                constant: 10
            ),
            placeholderLabel.leadingAnchor.constraint(
                equalTo: textView.leadingAnchor,
                constant: 15
            ),
            placeholderLabel.trailingAnchor.constraint(
                lessThanOrEqualTo:
                    textView.trailingAnchor,
                constant: -10
            ),

            publishButton.topAnchor.constraint(
                equalTo: textView.bottomAnchor,
                constant: 10
            ),
            publishButton.leadingAnchor.constraint(
                equalTo:
                    bottomContainerView.leadingAnchor,
                constant:
                    AppLayout.horizontalInset
            ),
            publishButton.trailingAnchor.constraint(
                equalTo:
                    bottomContainerView.trailingAnchor,
                constant:
                    -AppLayout.horizontalInset
            ),
            publishButton.heightAnchor.constraint(
                equalToConstant: 48
            ),

            attributionLabel.topAnchor.constraint(
                equalTo:
                    publishButton.bottomAnchor,
                constant: 6
            ),
            attributionLabel.leadingAnchor.constraint(
                equalTo:
                    bottomContainerView.leadingAnchor,
                constant:
                    AppLayout.horizontalInset
            ),
            attributionLabel.trailingAnchor.constraint(
                equalTo:
                    bottomContainerView.trailingAnchor,
                constant:
                    -AppLayout.horizontalInset
            ),
            attributionLabel.bottomAnchor.constraint(
                equalTo:
                    bottomContainerView.bottomAnchor,
                constant: -6
            ),

            tableView.topAnchor.constraint(
                equalTo:
                    view.safeAreaLayoutGuide.topAnchor
            ),
            tableView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),
            tableView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),
            tableView.bottomAnchor.constraint(
                equalTo:
                    bottomContainerView.topAnchor
            ),

            emptyLabel.centerXAnchor.constraint(
                equalTo: tableView.centerXAnchor
            ),
            emptyLabel.centerYAnchor.constraint(
                equalTo: tableView.centerYAnchor
            ),
            emptyLabel.leadingAnchor.constraint(
                greaterThanOrEqualTo:
                    tableView.leadingAnchor,
                constant: 30
            ),
            emptyLabel.trailingAnchor.constraint(
                lessThanOrEqualTo:
                    tableView.trailingAnchor,
                constant: -30
            )
        ])
    }

    

    private func bindViewModel() {
        viewModel.onTracksChanged = {
            [weak self] in

            guard let self else {
                return
            }

            tableView.reloadData()

            emptyLabel.isHidden =
                !viewModel.tracks.isEmpty

            updatePublishButtonState()
        }

        viewModel.onLoadingChanged = {
            [weak self] isLoading in

            guard let self else {
                return
            }

            if isLoading {
                activityIndicator.startAnimating()

                navigationItem.leftBarButtonItem =
                    UIBarButtonItem(
                        customView:
                            activityIndicator
                    )
            } else {
                activityIndicator.stopAnimating()

                navigationItem.leftBarButtonItem =
                    nil
            }
        }

        viewModel.onError = {
            [weak self] message in

            guard !message
                .localizedCaseInsensitiveContains(
                    "cancelled"
                )
            else {
                return
            }

            self?.showError(
                message
            )
        }

        viewModel.onPostCreated = {
            [weak self] in

            guard let self else {
                return
            }

            stopPlayback()

            navigationController?
                .popViewController(
                    animated: true
                )
        }
    }

    

    private func selectTrack(
        _ track: MusicTrack
    ) {
        selectedTrack = track

        updatePublishButtonState()

        tableView.reloadData()

        print("Выбран музыкальный трек:")
        print(
            "Название:",
            track.trackName
        )
        print(
            "Исполнитель:",
            track.artistName
        )
        print(
            "ID:",
            track.trackId
        )
        print(
            "Preview:",
            track.previewUrl ?? "nil"
        )
    }

    private func updatePublishButtonState() {
        let isAvailable =
            selectedTrack != nil

        publishButton.isEnabled =
            isAvailable

        var configuration =
            publishButton.configuration

        configuration?.showsActivityIndicator =
            false

        configuration?.title = L10n.string(
            "music.publish"
        )

        configuration?.baseBackgroundColor =
            isAvailable
            ? AppColors.accent
            : UIColor.systemGray4

        configuration?.baseForegroundColor =
            isAvailable
            ? UIColor.white
            : UIColor.secondaryLabel

        publishButton.configuration =
            configuration
    }

    // MARK: - Playback

    private func togglePlayback(
        track: MusicTrack
    ) {
        if playingTrackID ==
            track.trackId {
            stopPlayback()
            return
        }

        guard let previewString =
                track.previewUrl,
              !previewString.isEmpty,
              let previewURL = URL(
                string: previewString
              )
        else {
            showError(
                L10n.string(
                    "music.no_preview"
                )
            )
            return
        }

        player?.pause()

        do {
            let audioSession =
                AVAudioSession.sharedInstance()

            try audioSession.setCategory(
                .playback,
                mode: .default
            )

            try audioSession.setActive(
                true
            )
        } catch {
            print(
                L10n.string("common.error") + " AVAudioSession:",
                error.localizedDescription
            )
        }

        let newPlayer = AVPlayer(
            url: previewURL
        )

        player = newPlayer
        playingTrackID =
            track.trackId

        newPlayer.play()

        tableView.reloadData()
    }

    private func stopPlayback() {
        player?.pause()
        player = nil
        playingTrackID = nil

        tableView.reloadData()
    }

    @objc private func playerItemDidFinishPlaying(
        _ notification: Notification
    ) {
        guard let finishedItem =
                notification.object
                as? AVPlayerItem,
              finishedItem ===
                player?.currentItem
        else {
            return
        }

        stopPlayback()
    }

    

    @objc private func publishButtonTapped() {
        guard let selectedTrack else {
            showError(
                L10n.string(
                    "music.select_first"
                )
            )
            return
        }

        guard selectedTrack.previewUrl?
            .isEmpty == false
        else {
            showError(
                L10n.string(
                    "music.no_preview"
                )
            )
            return
        }

        publishButton.isEnabled = false

        var configuration =
            publishButton.configuration

        configuration?.showsActivityIndicator =
            true

        configuration?.title = L10n.string(
            "music.publishing"
        )

        publishButton.configuration =
            configuration

        stopPlayback()

        viewModel.publish(
            track: selectedTrack,
            text: textView.text
        )
    }

    
    private func updateThemeColors() {
        textView.layer.borderColor =
            AppColors.separator.resolvedColor(
                with: traitCollection
            ).cgColor
    }

    

    private func showError(
        _ message: String
    ) {
        updatePublishButtonState()

        let alert = UIAlertController(
            title: L10n.string(
                "common.error"
            ),
            message: message,
            preferredStyle: .alert
        )

        alert.addAction(
            UIAlertAction(
                title: L10n.string(
                    "common.ok"
                ),
                style: .default
            )
        )

        present(
            alert,
            animated: true
        )
    }
}



extension CreateMusicPostViewController:
    UITableViewDataSource {

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        viewModel.tracks.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell =
                tableView.dequeueReusableCell(
                    withIdentifier:
                        MusicTableViewCell
                            .reuseIdentifier,
                    for: indexPath
                ) as? MusicTableViewCell,
              let track = viewModel.track(
                at: indexPath.row
              )
        else {
            return UITableViewCell()
        }

        cell.configure(
            with: track,
            isSelected:
                track.trackId ==
                    selectedTrack?.trackId,
            isPlaying:
                track.trackId ==
                    playingTrackID
        )

        cell.onPlayTapped = {
            [weak self] in

            guard let self else {
                return
            }

            // Play одновременно выбирает трек
            selectTrack(
                track
            )

            togglePlayback(
                track: track
            )
        }

        return cell
    }
}



extension CreateMusicPostViewController:
    UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        guard let track = viewModel.track(
            at: indexPath.row
        ) else {
            return
        }

        selectTrack(
            track
        )

        view.endEditing(
            true
        )
    }
}



extension CreateMusicPostViewController:
    UISearchResultsUpdating {

    func updateSearchResults(
        for searchController:
            UISearchController
    ) {
        viewModel.search(
            query:
                searchController.searchBar.text
                ?? ""
        )
    }
}


extension CreateMusicPostViewController:
    UITextViewDelegate {

    func textViewDidChange(
        _ textView: UITextView
    ) {
        placeholderLabel.isHidden =
            !textView.text.isEmpty
    }
}


//import AVFoundation
//import UIKit
//
//@MainActor
//final class CreateMusicPostViewController: UIViewController {
//
//    private let viewModel: CreateMusicPostViewModel
//
//    private var player: AVPlayer?
//    //private var selectedTrackID: Int?
//    private var selectedTrack: MusicTrack?
//    private var playingTrackID: Int?
//
//    private lazy var searchController: UISearchController = {
//        let controller = UISearchController(
//            searchResultsController: nil
//        )
//
//        controller.searchResultsUpdater = self
//        controller.obscuresBackgroundDuringPresentation = false
//        controller.searchBar.placeholder = L10n.string("music.search_placeholder")
//            
//
//        return controller
//    }()
//
//    private let tableView: UITableView = {
//        let tableView = UITableView(
//            frame: .zero,
//            style: .plain
//        )
//
//        tableView.rowHeight = UITableView.automaticDimension
//        tableView.estimatedRowHeight = 92
//        tableView.backgroundColor = AppColors.background
//        tableView.keyboardDismissMode = .onDrag
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//
//        return tableView
//    }()
//
//    private let emptyLabel: UILabel = {
//        let label = UILabel()
//
//        label.text = L10n.string("music.search_hint")
//            
//        label.font = AppFonts.body
//        label.textColor = AppColors.secondaryText
//        label.textAlignment = .center
//        label.numberOfLines = 0
//        label.translatesAutoresizingMaskIntoConstraints = false
//
//        return label
//    }()
//
//    private let bottomContainerView: UIView = {
//        let view = UIView()
//
//        view.backgroundColor = AppColors.background
//        view.translatesAutoresizingMaskIntoConstraints = false
//
//        return view
//    }()
//
//    private let textView: UITextView = {
//        let textView = UITextView()
//
//        textView.font = AppFonts.body
//        textView.textColor = AppColors.primaryText
//        textView.backgroundColor = UIColor.secondarySystemBackground
//        textView.layer.cornerRadius = 10
//        textView.layer.borderWidth = 1
//        textView.layer.borderColor = UIColor.separator.cgColor
//        textView.textContainerInset = UIEdgeInsets(
//            top: 10,
//            left: 10,
//            bottom: 10,
//            right: 10
//        )
//        textView.translatesAutoresizingMaskIntoConstraints = false
//
//        return textView
//    }()
//
//    private let placeholderLabel: UILabel = {
//        let label = UILabel()
//
//        label.text = L10n.string("music.caption")
//        label.font = AppFonts.body
//        label.textColor = AppColors.secondaryText
//        label.translatesAutoresizingMaskIntoConstraints = false
//
//        return label
//    }()
//
//    private let attributionLabel: UILabel = {
//        let label = UILabel()
//
//        label.text = L10n.string("music.audius")
//        label.font = UIFont.preferredFont(
//            forTextStyle: .caption2
//        )
//        label.textColor = AppColors.secondaryText
//        label.textAlignment = .center
//        label.translatesAutoresizingMaskIntoConstraints = false
//
//        return label
//    }()
//
//    private let activityIndicator = UIActivityIndicatorView(
//        style: .medium
//    )
//
////    private lazy var publishButton = UIBarButtonItem(
////        title: "Опубликовать",
////        style: .done,
////        target: self,
////        action: #selector(publishButtonTapped)
////    )
//    
//    private lazy var publishButton: UIButton = {
//        var configuration = UIButton.Configuration.filled()
//
//        configuration.title = L10n.string("music.publish")
//        configuration.cornerStyle = .medium
//        configuration.baseBackgroundColor = UIColor.systemBlue
//        configuration.baseForegroundColor = UIColor.white
//
//        let button = UIButton(
//            configuration: configuration
//        )
//
//        button.isEnabled = false
//        button.translatesAutoresizingMaskIntoConstraints = false
//
//        button.addTarget(
//            self,
//            action: #selector(publishButtonTapped),
//            for: .touchUpInside
//        )
//
//        return button
//    }()
//
//
//
//    init(
//        viewModel: CreateMusicPostViewModel
//    ) {
//        self.viewModel = viewModel
//
//        super.init(
//            nibName: nil,
//            bundle: nil
//        )
//    }
//
//    required init?(
//        coder: NSCoder
//    ) {
//        fatalError(
//            "init(coder:) has not been implemented"
//        )
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        setupView()
//        setupTableView()
//        setupNavigationBar()
//        setupLayout()
//        bindViewModel()
//    }
//
//    override func viewWillDisappear(
//        _ animated: Bool
//    ) {
//        super.viewWillDisappear(animated)
//
//        stopPlayback()
//
//        if isMovingFromParent
//            || navigationController?.isBeingDismissed == true {
//            viewModel.cancelSearch()
//        }
//    }
//
//
//
//    private func setupView() {
//        title = L10n.string("music.create_title")
//        view.backgroundColor = AppColors.background
//        definesPresentationContext = true
//
//        textView.delegate = self
//
//        view.addSubview(tableView)
//        view.addSubview(emptyLabel)
//        view.addSubview(bottomContainerView)
//
//        bottomContainerView.addSubview(textView)
//        bottomContainerView.addSubview(publishButton)
//        bottomContainerView.addSubview(attributionLabel)
//        textView.addSubview(placeholderLabel)
//
//        activityIndicator.hidesWhenStopped = true
//    }
//
//    private func setupTableView() {
//        tableView.dataSource = self
//        tableView.delegate = self
//
//        tableView.register(
//            MusicTableViewCell.self,
//            forCellReuseIdentifier:
//                MusicTableViewCell.reuseIdentifier
//        )
//    }
//
//    private func setupNavigationBar() {
//        navigationItem.searchController = searchController
//        navigationItem.hidesSearchBarWhenScrolling = false
//
//        //publishButton.isEnabled = false
//        //navigationItem.rightBarButtonItem = publishButton
//        navigationItem.rightBarButtonItem = nil
//    }
//
//    private func setupLayout() {
//        NSLayoutConstraint.activate([
////            bottomContainerView.leadingAnchor.constraint(
////                equalTo: view.leadingAnchor
////            ),
////            bottomContainerView.trailingAnchor.constraint(
////                equalTo: view.trailingAnchor
////            ),
////            bottomContainerView.bottomAnchor.constraint(
////                equalTo: view.keyboardLayoutGuide.topAnchor
////            ),
////
////            textView.topAnchor.constraint(
////                equalTo: bottomContainerView.topAnchor,
////                constant: 8
////            ),
////            textView.leadingAnchor.constraint(
////                equalTo: bottomContainerView.leadingAnchor,
////                constant: AppLayout.horizontalInset
////            ),
////            textView.trailingAnchor.constraint(
////                equalTo: bottomContainerView.trailingAnchor,
////                constant: -AppLayout.horizontalInset
////            ),
////            textView.heightAnchor.constraint(
////                equalToConstant: 72
////            ),
//
//            
//            bottomContainerView.leadingAnchor.constraint(
//                equalTo: view.leadingAnchor
//            ),
//            bottomContainerView.trailingAnchor.constraint(
//                equalTo: view.trailingAnchor
//            ),
//            bottomContainerView.bottomAnchor.constraint(
//                equalTo: view.keyboardLayoutGuide.topAnchor
//            ),
//
//            textView.topAnchor.constraint(
//                equalTo: bottomContainerView.topAnchor,
//                constant: 8
//            ),
//            textView.leadingAnchor.constraint(
//                equalTo: bottomContainerView.leadingAnchor,
//                constant: AppLayout.horizontalInset
//            ),
//            textView.trailingAnchor.constraint(
//                equalTo: bottomContainerView.trailingAnchor,
//                constant: -AppLayout.horizontalInset
//            ),
//            textView.heightAnchor.constraint(
//                equalToConstant: 72
//            ),
//
//            publishButton.topAnchor.constraint(
//                equalTo: textView.bottomAnchor,
//                constant: 10
//            ),
//            publishButton.leadingAnchor.constraint(
//                equalTo: bottomContainerView.leadingAnchor,
//                constant: AppLayout.horizontalInset
//            ),
//            publishButton.trailingAnchor.constraint(
//                equalTo: bottomContainerView.trailingAnchor,
//                constant: -AppLayout.horizontalInset
//            ),
//            publishButton.heightAnchor.constraint(
//                greaterThanOrEqualToConstant: 48
//            ),
//
//            attributionLabel.topAnchor.constraint(
//                equalTo: publishButton.bottomAnchor,
//                constant: 6
//            ),
//            attributionLabel.leadingAnchor.constraint(
//                equalTo: bottomContainerView.leadingAnchor,
//                constant: AppLayout.horizontalInset
//            ),
//            attributionLabel.trailingAnchor.constraint(
//                equalTo: bottomContainerView.trailingAnchor,
//                constant: -AppLayout.horizontalInset
//            ),
//            attributionLabel.bottomAnchor.constraint(
//                equalTo: bottomContainerView.bottomAnchor,
//                constant: -6
//            ),
//
//
//            placeholderLabel.topAnchor.constraint(
//                equalTo: textView.topAnchor,
//                constant: 10
//            ),
//            placeholderLabel.leadingAnchor.constraint(
//                equalTo: textView.leadingAnchor,
//                constant: 15
//            ),
//
////            attributionLabel.topAnchor.constraint(
////                equalTo: textView.bottomAnchor,
////                constant: 5
////            ),
////            attributionLabel.leadingAnchor.constraint(
////                equalTo: bottomContainerView.leadingAnchor,
////                constant: AppLayout.horizontalInset
////            ),
////            attributionLabel.trailingAnchor.constraint(
////                equalTo: bottomContainerView.trailingAnchor,
////                constant: -AppLayout.horizontalInset
////            ),
////            attributionLabel.bottomAnchor.constraint(
////                equalTo: bottomContainerView.bottomAnchor,
////                constant: -5
////            ),
//
//            tableView.topAnchor.constraint(
//                equalTo: view.safeAreaLayoutGuide.topAnchor
//            ),
//            tableView.leadingAnchor.constraint(
//                equalTo: view.leadingAnchor
//            ),
//            tableView.trailingAnchor.constraint(
//                equalTo: view.trailingAnchor
//            ),
//            tableView.bottomAnchor.constraint(
//                equalTo: bottomContainerView.topAnchor
//            ),
//
//            emptyLabel.centerXAnchor.constraint(
//                equalTo: tableView.centerXAnchor
//            ),
//            emptyLabel.centerYAnchor.constraint(
//                equalTo: tableView.centerYAnchor
//            ),
//            emptyLabel.leadingAnchor.constraint(
//                greaterThanOrEqualTo: tableView.leadingAnchor,
//                constant: 30
//            ),
//            emptyLabel.trailingAnchor.constraint(
//                lessThanOrEqualTo: tableView.trailingAnchor,
//                constant: -30
//            )
//        ])
//    }
//
//    private func bindViewModel() {
//        viewModel.onTracksChanged = { [weak self] in
//            guard let self else {
//                return
//            }
//
//            tableView.reloadData()
//            emptyLabel.isHidden = !viewModel.tracks.isEmpty
//        }
//
//        viewModel.onLoadingChanged = { [weak self] isLoading in
//            guard let self else {
//                return
//            }
//
//            if isLoading {
//                activityIndicator.startAnimating()
//
//                navigationItem.leftBarButtonItem = UIBarButtonItem(
//                    customView: activityIndicator
//                )
//            } else {
//                activityIndicator.stopAnimating()
//                navigationItem.leftBarButtonItem = nil
//            }
//        }
//        
//        viewModel.onError = { [weak self] message in
//            guard message.localizedCaseInsensitiveCompare(
//                "cancelled"
//            ) != .orderedSame else {
//                return
//            }
//
//            self?.showError(
//                message
//            )
//        }
//
//
//
////        viewModel.onError = { [weak self] message in
////            self?.showError(message)
////        }
//
//        viewModel.onPostCreated = { [weak self] in
//            self?.stopPlayback()
//
//            self?.navigationController?.popViewController(
//                animated: true
//            )
//        }
//    }
//
//    private func togglePlayback(
//        track: MusicTrack
//    ) {
//        if playingTrackID == track.trackId {
//            stopPlayback()
//            return
//        }
//
//        guard let previewString = track.previewUrl,
//              let previewURL = URL(string: previewString)
//        else {
//            showError(
//                L10n.string("music.no_preview")
//            )
//            return
//        }
//
//        player?.pause()
//
//        let newPlayer = AVPlayer(
//            url: previewURL
//        )
//
//        player = newPlayer
//        playingTrackID = track.trackId
//
//        newPlayer.play()
//        tableView.reloadData()
//    }
//
//    private func stopPlayback() {
//        player?.pause()
//        player = nil
//        playingTrackID = nil
//
//        tableView.reloadData()
//    }
//
////    @objc private func publishButtonTapped() {
////        guard let selectedTrackID,
////              let track = viewModel.tracks.first(
////                where: {
////                    $0.trackId == selectedTrackID
////                }
////              )
////        else {
////            showError(
////                "Сначала выберите музыкальный трек"
////            )
////            return
////        }
////
////        publishButton.isEnabled = false
////
////        viewModel.publish(
////            track: track,
////            text: textView.text
////        )
////    }
//    
//    @objc private func publishButtonTapped() {
//        guard let selectedTrack else {
//            showError(
//                L10n.string("music.select_first")
//            )
//            return
//        }
//
//        guard let previewURL = selectedTrack.previewUrl,
//              !previewURL.isEmpty
//        else {
//            showError(
//                L10n.string("music.no_preview")
//            )
//            return
//        }
//
//        publishButton.isEnabled = false
//
//        var configuration = publishButton.configuration
//        configuration?.showsActivityIndicator = true
//        configuration?.title = L10n.string("music.piblishing")
//        publishButton.configuration = configuration
//
//        stopPlayback()
//
//        viewModel.publish(
//            track: selectedTrack,
//            text: textView.text
//        )
//    }
//
//
//
//    private func showError(
//        _ message: String
//    ) {
//        //publishButton.isEnabled = selectedTrackID != nil
//        publishButton.isEnabled = selectedTrack != nil
//
//        var configuration = publishButton.configuration
//        configuration?.showsActivityIndicator = false
//        configuration?.title = L10n.string("music.publish")
//        publishButton.configuration = configuration
//
//
//
//        let alert = UIAlertController(
//            title: L10n.string("common.error"),
//            message: message,
//            preferredStyle: .alert
//        )
//
//        alert.addAction(
//            UIAlertAction(
//                title: L10n.string("common.ok"),
//                style: .default
//            )
//        )
//
//        present(
//            alert,
//            animated: true
//        )
//    }
//}
//
//extension CreateMusicPostViewController:
//    UITableViewDataSource {
//
//    func tableView(
//        _ tableView: UITableView,
//        numberOfRowsInSection section: Int
//    ) -> Int {
//        viewModel.tracks.count
//    }
//
//    func tableView(
//        _ tableView: UITableView,
//        cellForRowAt indexPath: IndexPath
//    ) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(
//            withIdentifier:
//                MusicTableViewCell.reuseIdentifier,
//            for: indexPath
//        ) as? MusicTableViewCell,
//              let track = viewModel.track(
//                at: indexPath.row
//              )
//        else {
//            return UITableViewCell()
//        }
//
//        cell.configure(
//            with: track,
//            isSelected: track.trackId == selectedTrack?.id,
//            isPlaying: track.trackId == playingTrackID
//        )
//
//        cell.onPlayTapped = { [weak self] in
//            self?.togglePlayback(
//                track: track
//            )
//        }
//
//        return cell
//    }
//}
//
//extension CreateMusicPostViewController:
//    UITableViewDelegate {
//
////    func tableView(
////        _ tableView: UITableView,
////        didSelectRowAt indexPath: IndexPath
////    ) {
////        guard let track = viewModel.track(
////            at: indexPath.row
////        ) else {
////            return
////        }
////
////        selectedTrackID = track.trackId
////        publishButton.isEnabled = true
////
////        tableView.reloadData()
////    }
//    
//    func tableView(
//        _ tableView: UITableView,
//        didSelectRowAt indexPath: IndexPath
//    ) {
//        guard let track = viewModel.track(
//            at: indexPath.row
//        ) else {
//            return
//        }
//
//        selectedTrack = track
//        publishButton.isEnabled = true
//
//        tableView.reloadData()
//
//        view.endEditing(true)
//
//        print(
//            L10n.string("music.track_selected"),
//            track.trackName,
//            "ID:",
//            track.trackId
//        )
//    }
//
//
//}
//
//extension CreateMusicPostViewController:
//    UISearchResultsUpdating {
//
//    func updateSearchResults(
//        for searchController: UISearchController
//    ) {
//        viewModel.search(
//            query: searchController.searchBar.text ?? ""
//        )
//    }
//}
//
//extension CreateMusicPostViewController:
//    UITextViewDelegate {
//
//    func textViewDidChange(
//        _ textView: UITextView
//    ) {
//        placeholderLabel.isHidden = !textView.text.isEmpty
//    }
//}
//
