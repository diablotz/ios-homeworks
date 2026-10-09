//
//  CreateClipViewController.swift
//  VKApp
//
//  Created by Timur Zakirov on 06/10/26.
//

import UIKit
import AVKit
import PhotosUI
import UniformTypeIdentifiers

@MainActor
final class CreateVideoViewController: UIViewController {
    

    private let viewModel: CreateVideoViewModel

    private var previewController: AVPlayerViewController?

    private let previewContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = AppLayout.cornerRadius
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Видео не выбрано"
        label.textColor = .white
        label.font = AppFonts.body
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let captionTextView: UITextView = {
        let textView = UITextView()
        textView.font = AppFonts.body
        textView.textColor = AppColors.primaryText
        textView.backgroundColor =
            AppColors.secondaryBackground
        textView.layer.cornerRadius =
            AppLayout.cornerRadius
        textView.textContainerInset = UIEdgeInsets(
            top: 12,
            left: 12,
            bottom: 12,
            right: 12
        )
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    private lazy var selectVideoButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Выбрать видео"
        configuration.image = UIImage(
            systemName: "video.badge.plus"
        )
        configuration.imagePadding = 8
        configuration.baseBackgroundColor =
            AppColors.vkBlue

        let button = UIButton(configuration: configuration)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(
            self,
            action: #selector(selectVideoTapped),
            for: .touchUpInside
        )
        return button
    }()

    init(viewModel: CreateVideoViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is unavailable")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupLayout()
        bindViewModel()
    }

    private func setupView() {
        view.backgroundColor = AppColors.background
        navigationItem.title = "Новое видео"

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Опубликовать",
            style: .done,
            target: self,
            action: #selector(publishTapped)
        )

        view.addSubview(previewContainerView)
        previewContainerView.addSubview(
            placeholderLabel
        )
        view.addSubview(captionTextView)
        view.addSubview(selectVideoButton)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            previewContainerView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 16
            ),
            previewContainerView.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            previewContainerView.widthAnchor.constraint(
                lessThanOrEqualToConstant: 420
            ),
            previewContainerView.widthAnchor.constraint(
                equalTo: view.widthAnchor,
                multiplier: 0.8
            ),
            previewContainerView.heightAnchor.constraint(
                equalTo: previewContainerView.widthAnchor,
                multiplier: 16.0 / 9.0
            ),

            placeholderLabel.centerXAnchor.constraint(
                equalTo: previewContainerView.centerXAnchor
            ),
            placeholderLabel.centerYAnchor.constraint(
                equalTo: previewContainerView.centerYAnchor
            ),

            captionTextView.topAnchor.constraint(
                equalTo: previewContainerView.bottomAnchor,
                constant: 16
            ),
            captionTextView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: AppLayout.horizontalInset
            ),
            captionTextView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -AppLayout.horizontalInset
            ),
            captionTextView.heightAnchor.constraint(
                equalToConstant: 110
            ),

            selectVideoButton.topAnchor.constraint(
                equalTo: captionTextView.bottomAnchor,
                constant: 16
            ),
            selectVideoButton.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            selectVideoButton.heightAnchor.constraint(
                greaterThanOrEqualToConstant:
                    AppLayout.buttonHeight
            ),
            selectVideoButton.bottomAnchor.constraint(
                lessThanOrEqualTo:
                    view.safeAreaLayoutGuide.bottomAnchor,
                constant: -16
            )
        ])
    }
    
    private func bindViewModel() {
        viewModel.onVideoSelected = {
            [weak self] videoName in

            DispatchQueue.main.async {
                self?.showPreview(
                    videoName: videoName
                )
            }
        }

        viewModel.onCreated = { [weak self] in
            DispatchQueue.main.async {
                self?.navigationController?
                    .popViewController(animated: true)
            }
        }

        viewModel.onError = { [weak self] message in
            DispatchQueue.main.async {
                self?.showError(message)
            }
        }
    }




    
    @MainActor
    private func showPreview(videoName: String) {
        guard
            let url = LocalVideoStore.shared.url(
                for: videoName
            )
        else {
            showError("Сохранённое видео не найдено")
            return
        }

        previewController?.player?.pause()

        if let previewController {
            previewController.willMove(toParent: nil)
            previewController.view.removeFromSuperview()
            previewController.removeFromParent()
        }

        let playerController = AVPlayerViewController()
        playerController.player = AVPlayer(url: url)

        addChild(playerController)

        playerController.view.translatesAutoresizingMaskIntoConstraints =
            false

        previewContainerView.addSubview(
            playerController.view
        )

        NSLayoutConstraint.activate([
            playerController.view.topAnchor.constraint(
                equalTo: previewContainerView.topAnchor
            ),
            playerController.view.leadingAnchor.constraint(
                equalTo: previewContainerView.leadingAnchor
            ),
            playerController.view.trailingAnchor.constraint(
                equalTo: previewContainerView.trailingAnchor
            ),
            playerController.view.bottomAnchor.constraint(
                equalTo: previewContainerView.bottomAnchor
            )
        ])

        playerController.didMove(toParent: self)

        previewController = playerController
        placeholderLabel.isHidden = true

        playerController.player?.play()
    }




    @objc private func selectVideoTapped() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .videos
        configuration.selectionLimit = 1
        configuration.preferredAssetRepresentationMode =
            .current

        let picker = PHPickerViewController(
            configuration: configuration
        )
        picker.delegate = self

        present(picker, animated: true)
    }

    @objc private func publishTapped() {
        viewModel.createVideo(
            caption: captionTextView.text
        )
    }

    private func showError(_ message: String) {
        let alert = UIAlertController(
            title: "Ошибка",
            message: message,
            preferredStyle: .alert
        )

        alert.addAction(
            UIAlertAction(title: "ОК", style: .default)
        )

        present(alert, animated: true)
    }
    
    
    
}

extension CreateVideoViewController:
    PHPickerViewControllerDelegate {
    
    func picker(
        _ picker: PHPickerViewController,
        didFinishPicking results: [PHPickerResult]
    ) {
        picker.dismiss(animated: true)
        
        guard let result = results.first else {
            return
        }
        
        let provider = result.itemProvider
        
        guard provider.hasItemConformingToTypeIdentifier(
            UTType.movie.identifier
        ) else {
            showError("Выбранный файл не является видео")
            return
        }
        
        provider.loadFileRepresentation(
            forTypeIdentifier: UTType.movie.identifier
        ) { [weak self] temporaryURL, error in // <-- ДОБАВИЛИ [weak self] СЮДА
            
            // Теперь внутри всего этого блока self стал опциональным (self?)
            
            if let error {
                DispatchQueue.main.async {
                    // Внутренние [weak self] больше не нужны, так как self уже weak во внешней области
                    self?.showError(
                        "Ошибка загрузки видео: " + error.localizedDescription
                    )
                }
                return
            }
            
            guard let temporaryURL else {
                DispatchQueue.main.async {
                    self?.showError("Не удалось получить видеофайл")
                }
                return
            }
            
            do {
                let fileName = try LocalVideoStore.shared.saveVideo(from: temporaryURL)
                
                DispatchQueue.main.async {
                    self?.viewModel.setSelectedVideoName(fileName)
                }
            } catch {
                DispatchQueue.main.async {
                    self?.showError(
                        "Не удалось сохранить видео: " + error.localizedDescription
                    )
                }
            }
        }
        
    }
}
