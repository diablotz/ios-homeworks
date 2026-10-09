//
//  CreateStoryViewController.swift
//  VKApp
//
//  Created by Timur Zakirov on 03/10/26.
//

import UIKit
import PhotosUI


final class CreateStoryViewController:
    UIViewController {

    private let viewModel: CreateStoryViewModel

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var selectButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Выбрать фотографию"
        configuration.baseBackgroundColor = AppColors.vkBlue

        let button = UIButton(configuration: configuration)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(
            self,
            action: #selector(selectImageTapped),
            for: .touchUpInside
        )
        return button
    }()

    init(viewModel: CreateStoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is unavailable")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        navigationItem.title = "Новая история"

        view.addSubview(imageView)
        view.addSubview(selectButton)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            imageView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),
            imageView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),
            imageView.bottomAnchor.constraint(
                equalTo: selectButton.topAnchor,
                constant: -20
            ),

            selectButton.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 24
            ),
            selectButton.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -24
            ),
            selectButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -20
            ),
            selectButton.heightAnchor.constraint(
                equalToConstant: 50
            )
        ])

        viewModel.onCreated = { [weak self] in
            self?.navigationController?
                .popViewController(animated: true)
        }

        viewModel.onError = { [weak self] message in
            self?.showError(message)
        }
    }

    @objc private func selectImageTapped() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1

        let picker = PHPickerViewController(
            configuration: configuration
        )
        picker.delegate = self

        present(picker, animated: true)
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

extension CreateStoryViewController:
    PHPickerViewControllerDelegate {

    func picker(
        _ picker: PHPickerViewController,
        didFinishPicking results:
            [PHPickerResult]
    ) {
        picker.dismiss(animated: true)

        guard
            let provider = results.first?.itemProvider,
            provider.canLoadObject(
                ofClass: UIImage.self
            )
        else {
            return
        }

        provider.loadObject(
            ofClass: UIImage.self
        ) { [weak self] object, _ in
            guard let image = object as? UIImage else {
                return
            }

            DispatchQueue.main.async {
                self?.imageView.image = image
                self?.viewModel.createStory(image: image)
            }
        }
    }
}

