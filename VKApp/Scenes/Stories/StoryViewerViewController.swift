//
//  StoryViewerViewController.swift
//  VKApp
//
//  Created by Timur Zakirov on 03/10/26.
//

import UIKit

final class StoryViewerViewController: UIViewController {

    private let viewModel: StoryViewerViewModel

    private var timer: Timer?
    private var progress: Float = 0

    private let storyDuration: Float = 5
    private let timerInterval: TimeInterval = 0.05

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .black
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.headline
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(
            UIImage(systemName: "xmark"),
            for: .normal
        )
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(
            self,
            action: #selector(closeTapped),
            for: .touchUpInside
        )
        return button
    }()

    private let progressStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 4
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    init(viewModel: StoryViewerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        modalPresentationStyle = .fullScreen
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is unavailable")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupProgressViews()
        setupGestures()
        showCurrentStory()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopTimer()
    }

    private func setupView() {
        view.backgroundColor = .black

        view.addSubview(imageView)
        view.addSubview(progressStackView)
        view.addSubview(authorLabel)
        view.addSubview(closeButton)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(
                equalTo: view.topAnchor
            ),
            imageView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),
            imageView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),
            imageView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor
            ),

            progressStackView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 8
            ),
            progressStackView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 12
            ),
            progressStackView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -12
            ),
            progressStackView.heightAnchor.constraint(
                equalToConstant: 3
            ),

            authorLabel.topAnchor.constraint(
                equalTo: progressStackView.bottomAnchor,
                constant: 14
            ),
            authorLabel.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 16
            ),
            authorLabel.trailingAnchor.constraint(
                lessThanOrEqualTo: closeButton.leadingAnchor,
                constant: -12
            ),

            closeButton.centerYAnchor.constraint(
                equalTo: authorLabel.centerYAnchor
            ),
            closeButton.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -16
            ),
            closeButton.widthAnchor.constraint(
                equalToConstant: 44
            ),
            closeButton.heightAnchor.constraint(
                equalToConstant: 44
            )
        ])
    }

    private func setupProgressViews() {
        viewModel.stories.forEach { _ in
            let progressView = UIProgressView(
                progressViewStyle: .bar
            )

            progressView.progressTintColor = .white
            progressView.trackTintColor =
                UIColor.white.withAlphaComponent(0.35)

            progressStackView.addArrangedSubview(
                progressView
            )
        }
    }

    private func setupGestures() {
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(viewTapped)
        )

        view.addGestureRecognizer(tap)
    }

    private func showCurrentStory() {
        let story = viewModel.currentStory

        imageView.image =
            LocalImageStore.shared.image(
                fileName: story.imageName
            )

        if imageView.image == nil {
            imageView.image = UIImage(
                systemName: "photo"
            )
            imageView.tintColor = .white
        }

        authorLabel.text = story.authorName

        viewModel.markCurrentAsViewed()

        progress = 0
        updateProgressViews()
        startTimer()
    }

    private func startTimer() {
        stopTimer()

        timer = Timer.scheduledTimer(
            timeInterval: timerInterval,
            target: self,
            selector: #selector(timerTick),
            userInfo: nil,
            repeats: true
        )
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    @objc private func timerTick() {
        progress += Float(timerInterval) / storyDuration

        updateProgressViews()

        if progress >= 1 {
            showNextStory()
        }
    }

    private func updateProgressViews() {
        for (
            index,
            arrangedView
        ) in progressStackView.arrangedSubviews.enumerated() {
            guard
                let progressView =
                    arrangedView as? UIProgressView
            else {
                continue
            }

            if index < viewModel.currentIndex {
                progressView.progress = 1
            } else if index == viewModel.currentIndex {
                progressView.progress = progress
            } else {
                progressView.progress = 0
            }
        }
    }

    private func showNextStory() {
        if viewModel.moveForward() {
            showCurrentStory()
        } else {
            dismiss(animated: true)
        }
    }

    private func showPreviousStory() {
        if viewModel.moveBack() {
            showCurrentStory()
        } else {
            progress = 0
            updateProgressViews()
            startTimer()
        }
    }

    @objc private func viewTapped(
        _ gesture: UITapGestureRecognizer
    ) {
        let location = gesture.location(in: view)

        if location.x < view.bounds.width * 0.35 {
            showPreviousStory()
        } else {
            showNextStory()
        }
    }

    @objc private func closeTapped() {
        dismiss(animated: true)
    }
}

