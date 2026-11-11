//
//  CreateMoviePostViewController.swift
//  VKApp
//
//  Created by Timur Zakirov on 03/11/26.
//

import UIKit

@MainActor
final class CreateMoviePostViewController: UIViewController {

    private let viewModel: CreateMoviePostViewModel

    //private var selectedMovieID: Int?
    private var selectedMovie: Movie?

    private lazy var searchController: UISearchController = {
        let controller = UISearchController(
            searchResultsController: nil
        )

        controller.searchResultsUpdater = self
        controller.obscuresBackgroundDuringPresentation = false
        controller.searchBar.placeholder = L10n.string("movie.search")

        return controller
    }()

    private let tableView: UITableView = {
        let tableView = UITableView(
            frame: .zero,
            style: .plain
        )

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 124
        tableView.keyboardDismissMode = .onDrag
        tableView.backgroundColor = AppColors.background
        tableView.translatesAutoresizingMaskIntoConstraints = false

        return tableView
    }()

    private let bottomContainerView: UIView = {
        let view = UIView()

        view.backgroundColor = AppColors.background
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private let textView: UITextView = {
        let textView = UITextView()

        textView.font = AppFonts.body
        textView.textColor = AppColors.primaryText
        textView.backgroundColor = UIColor.secondarySystemBackground
        textView.layer.cornerRadius = 10
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.separator.cgColor
        textView.textContainerInset = UIEdgeInsets(
            top: 10,
            left: 10,
            bottom: 10,
            right: 10
        )
        textView.adjustsFontForContentSizeCategory = true
        textView.translatesAutoresizingMaskIntoConstraints = false

        return textView
    }()

    private let placeholderLabel: UILabel = {
        let label = UILabel()

        label.text = L10n.string("movie.caption")
        label.font = AppFonts.body
        label.textColor = AppColors.secondaryText
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private let activityIndicator = UIActivityIndicatorView(
        style: .medium
    )

//    private lazy var publishButton = UIBarButtonItem(
//        title: "Опубликовать",
//        style: .done,
//        target: self,
//        action: #selector(publishButtonTapped)
//    )
    
    private lazy var publishButton: UIButton = {
        var configuration = UIButton.Configuration.filled()

        configuration.title = L10n.string("movie.publish")
        configuration.cornerStyle = .medium
        configuration.baseBackgroundColor = UIColor.systemBlue
        configuration.baseForegroundColor = UIColor.white

        let button = UIButton(
            configuration: configuration
        )

        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false

        button.addTarget(
            self,
            action: #selector(publishButtonTapped),
            for: .touchUpInside
        )

        return button
    }()



    init(
        viewModel: CreateMoviePostViewModel
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

        viewModel.loadPopularMovies()
    }
    
    override func viewWillDisappear(
        _ animated: Bool
    ) {
        super.viewWillDisappear(animated)

        if isMovingFromParent
            || navigationController?.isBeingDismissed == true {
            viewModel.cancelSearch()
        }
    }



    private func setupView() {
        title = L10n.string("movie.create_title")
        view.backgroundColor = AppColors.background
        definesPresentationContext = true
        textView.delegate = self

        view.addSubview(tableView)
        view.addSubview(bottomContainerView)

        bottomContainerView.addSubview(textView)
        bottomContainerView.addSubview(publishButton)
        textView.addSubview(placeholderLabel)

        activityIndicator.hidesWhenStopped = true
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self

        tableView.register(
            MovieTableViewCell.self,
            forCellReuseIdentifier:
                MovieTableViewCell.reuseIdentifier
        )
    }

    private func setupNavigationBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false

//        publishButton.isEnabled = false
//        navigationItem.rightBarButtonItem = publishButton
        navigationItem.rightBarButtonItem = nil
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
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
//            textView.bottomAnchor.constraint(
//                equalTo: bottomContainerView.bottomAnchor,
//                constant: -8
//            ),
//            textView.heightAnchor.constraint(
//                equalToConstant: 80
//            ),
            
            bottomContainerView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),
            bottomContainerView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),
            bottomContainerView.bottomAnchor.constraint(
                equalTo: view.keyboardLayoutGuide.topAnchor
            ),

            textView.topAnchor.constraint(
                equalTo: bottomContainerView.topAnchor,
                constant: 8
            ),
            textView.leadingAnchor.constraint(
                equalTo: bottomContainerView.leadingAnchor,
                constant: AppLayout.horizontalInset
            ),
            textView.trailingAnchor.constraint(
                equalTo: bottomContainerView.trailingAnchor,
                constant: -AppLayout.horizontalInset
            ),
            textView.heightAnchor.constraint(
                equalToConstant: 80
            ),

            publishButton.topAnchor.constraint(
                equalTo: textView.bottomAnchor,
                constant: 10
            ),
            publishButton.leadingAnchor.constraint(
                equalTo: bottomContainerView.leadingAnchor,
                constant: AppLayout.horizontalInset
            ),
            publishButton.trailingAnchor.constraint(
                equalTo: bottomContainerView.trailingAnchor,
                constant: -AppLayout.horizontalInset
            ),
            publishButton.heightAnchor.constraint(
                greaterThanOrEqualToConstant: 48
            ),
            publishButton.bottomAnchor.constraint(
                equalTo: bottomContainerView.bottomAnchor,
                constant: -10
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
                lessThanOrEqualTo: textView.trailingAnchor,
                constant: -10
            ),

            tableView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            tableView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),
            tableView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),
            tableView.bottomAnchor.constraint(
                equalTo: bottomContainerView.topAnchor
            )
        ])
    }

    private func bindViewModel() {
        viewModel.onMoviesChanged = { [weak self] in
            self?.tableView.reloadData()
        }

        viewModel.onLoadingChanged = { [weak self] isLoading in
            guard let self else {
                return
            }

            if isLoading {
                activityIndicator.startAnimating()
                navigationItem.leftBarButtonItem = UIBarButtonItem(
                    customView: activityIndicator
                )
            } else {
                activityIndicator.stopAnimating()
                navigationItem.leftBarButtonItem = nil
            }
        }
        
        viewModel.onError = { [weak self] message in
            guard message.localizedCaseInsensitiveCompare(
                "cancelled"
            ) != .orderedSame else {
                return
            }

            self?.showError(
                message
            )
        }



//        viewModel.onError = { [weak self] message in
//            self?.showError(
//                message
//            )
//        }

        viewModel.onPostCreated = { [weak self] in
            self?.navigationController?.popViewController(
                animated: true
            )
        }
    }

//    @objc private func publishButtonTapped() {
//        guard let selectedMovieID,
//              let movie = viewModel.movies.first(
//                where: { $0.id == selectedMovieID }
//              )
//        else {
//            showError(
//                "Сначала выберите фильм"
//            )
//            return
//        }
//
//        publishButton.isEnabled = false
//
//        viewModel.publish(
//            movie: movie,
//            text: textView.text
//        )
//    }
    @objc private func publishButtonTapped() {
        guard let selectedMovie else {
            showError(
                L10n.string("movie.select_first")
            )
            return
        }

        publishButton.isEnabled = false

        var configuration = publishButton.configuration
        configuration?.showsActivityIndicator = true
        configuration?.title = L10n.string("movie.publishing")
        publishButton.configuration = configuration

        viewModel.publish(
            movie: selectedMovie,
            text: textView.text
        )
    }



    private func showError(
        _ message: String
    ) {
        //publishButton.isEnabled = selectedMovieID != nil
        publishButton.isEnabled = selectedMovie != nil

        var configuration = publishButton.configuration
        configuration?.showsActivityIndicator = false
        configuration?.title = L10n.string("movie.publish")
        publishButton.configuration = configuration



        let alert = UIAlertController(
            title: L10n.string("common.error"),
            message: message,
            preferredStyle: .alert
        )

        alert.addAction(
            UIAlertAction(
                title: L10n.string("common.ok"),
                style: .default
            )
        )

        present(
            alert,
            animated: true
        )
    }
}



extension CreateMoviePostViewController:
    UITableViewDataSource {

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        viewModel.movies.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MovieTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? MovieTableViewCell,
              let movie = viewModel.movie(
                at: indexPath.row
              )
        else {
            return UITableViewCell()
        }

        cell.configure(
            with: movie,
            isSelected: movie.id == selectedMovie?.id
        )

        return cell
    }
}

extension CreateMoviePostViewController:
    UITableViewDelegate {

//    func tableView(
//        _ tableView: UITableView,
//        didSelectRowAt indexPath: IndexPath
//    ) {
//        guard let movie = viewModel.movie(
//            at: indexPath.row
//        ) else {
//            return
//        }
//
//        selectedMovieID = movie.id
//        publishButton.isEnabled = true
//
//        tableView.reloadData()
//    }
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        guard let movie = viewModel.movie(
            at: indexPath.row
        ) else {
            return
        }

        selectedMovie = movie
        publishButton.isEnabled = true

        tableView.reloadData()

        view.endEditing(true)

        print(
            L10n.string("movie.selected"),
            movie.name,
            "ID:",
            movie.id
        )
    }


}

extension CreateMoviePostViewController:
    UISearchResultsUpdating {

    func updateSearchResults(
        for searchController: UISearchController
    ) {
        viewModel.search(
            query: searchController.searchBar.text ?? ""
        )
    }
}

extension CreateMoviePostViewController:
    UITextViewDelegate {

    func textViewDidChange(
        _ textView: UITextView
    ) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}

