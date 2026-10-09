//
//  ReelsViewController.swift
//  VKApp
//
//  Created by Timur Zakirov on 24/09/26.
//

import UIKit

final class ReelsViewController: UIViewController {

    private let viewModel: ReelsViewModel
    
    private weak var playingCell: ReelCollectionViewCell?
    
    private let reelsContainerView: UIView = {
        let view = UIView()

        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()



    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0

        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )

        collectionView.backgroundColor = .black
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentInsetAdjustmentBehavior = .never

        collectionView.register(
            ReelCollectionViewCell.self,
            forCellWithReuseIdentifier:
                ReelCollectionViewCell.reuseIdentifier
        )

        return collectionView
    }()

    init(viewModel: ReelsViewModel) {
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
        navigationItem.title = "Для вас"

        //view.addSubview(collectionView)
        view.addSubview(reelsContainerView)
        reelsContainerView.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            reelsContainerView.topAnchor.constraint(
                equalTo: view.topAnchor
            ),
            reelsContainerView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor
            ),
            reelsContainerView.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            reelsContainerView.widthAnchor.constraint(
                lessThanOrEqualToConstant:
                    AdaptiveLayout.reelsMaximumWidth
            ),
            reelsContainerView.widthAnchor.constraint(
                lessThanOrEqualTo: view.widthAnchor
            ),

            collectionView.topAnchor.constraint(
                equalTo: reelsContainerView.topAnchor
            ),
            collectionView.leadingAnchor.constraint(
                equalTo: reelsContainerView.leadingAnchor
            ),
            collectionView.trailingAnchor.constraint(
                equalTo: reelsContainerView.trailingAnchor
            ),
            collectionView.bottomAnchor.constraint(
                equalTo: reelsContainerView.bottomAnchor
            )
            
            
        ])

        let preferredWidth = reelsContainerView.widthAnchor.constraint(
                equalTo: view.widthAnchor
        )

        preferredWidth.priority = .defaultHigh
        preferredWidth.isActive = true




//        NSLayoutConstraint.activate([
//            collectionView.topAnchor.constraint(
//                equalTo: view.topAnchor
//            ),
//            collectionView.leadingAnchor.constraint(
//                equalTo: view.leadingAnchor
//            ),
//            collectionView.trailingAnchor.constraint(
//                equalTo: view.trailingAnchor
//            ),
//            collectionView.bottomAnchor.constraint(
//                equalTo: view.bottomAnchor
//            )
//        ])

        viewModel.onDataChanged = { [weak self] in
            guard let self else {
                return
            }

            let offset = collectionView.contentOffset

            collectionView.reloadData()
            collectionView.layoutIfNeeded()
            collectionView.setContentOffset(
                offset,
                animated: false
            )

            DispatchQueue.main.async { [weak self] in
                self?.playCurrentReel()
            }
        }




//        viewModel.onDataChanged = { [weak self] in
//            self?.collectionView.reloadData()
//            self?.playVisibleReel()
//        }

        viewModel.onError = { [weak self] message in
            self?.showError(message)
        }

        viewModel.loadReels()
        print(
            "Прямой поиск reel_1:",
            Bundle.main.url(
                forResource: "reel_1",
                withExtension: "mp4"
            ) as Any
        )

        print(
            "Прямой поиск reel_2:",
            Bundle.main.url(
                forResource: "reel_2",
                withExtension: "mp4"
            ) as Any
        )

        print(
            "LocalVideoStore reel_1:",
            LocalVideoStore.shared.url(
                for: "reel_1"
            ) as Any
        )

        print(
            "LocalVideoStore reel_2:",
            LocalVideoStore.shared.url(
                for: "reel_2"
            ) as Any
        )


    }
    
    override func viewWillTransition(
        to size: CGSize,
        with coordinator: UIViewControllerTransitionCoordinator
    ) {
        super.viewWillTransition(
            to: size,
            with: coordinator
        )

        coordinator.animate(
            alongsideTransition: { [weak self] _ in
                self?.collectionView
                    .collectionViewLayout
                    .invalidateLayout()
            },
            completion: { [weak self] _ in
                self?.playCurrentReel()
            }
        )
    }



    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        guard
            let layout = collectionView.collectionViewLayout
                as? UICollectionViewFlowLayout
        else {
            return
        }

        if layout.itemSize != collectionView.bounds.size {
            layout.itemSize = collectionView.bounds.size
            layout.invalidateLayout()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        DispatchQueue.main.async { [weak self] in
            self?.playCurrentReel()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        pauseCurrentReel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadReels()
    }


    
    private func playCurrentReel() {
        guard
            collectionView.bounds.height > 0,
            !viewModel.reels.isEmpty
        else {
            return
        }

        let rawPage =
            collectionView.contentOffset.y
            / collectionView.bounds.height

        let page = min(
            max(Int(round(rawPage)), 0),
            viewModel.reels.count - 1
        )

        let indexPath = IndexPath(
            item: page,
            section: 0
        )

        guard
            let cell = collectionView.cellForItem(
                at: indexPath
            ) as? ReelCollectionViewCell
        else {
            /*
             Ячейка может ещё не успеть появиться после reloadData.
             Повторяем на следующем цикле RunLoop.
             */
            DispatchQueue.main.async { [weak self] in
                self?.playCurrentReel()
            }
            return
        }

        collectionView.visibleCells.forEach {
            guard
                let visibleCell =
                    $0 as? ReelCollectionViewCell,
                visibleCell !== cell
            else {
                return
            }

            visibleCell.pause()
        }

        if playingCell !== cell {
            playingCell?.pause()
        }

        playingCell = cell
        cell.play()
    }

    private func pauseCurrentReel() {
        playingCell?.pause()
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
    
//    func scrollViewWillBeginDragging(
//        _ scrollView: UIScrollView
//    ) {
//        playingCell?.stop()
//        playingCell = nil
//    }


}

extension ReelsViewController:
    UICollectionViewDataSource,
    UICollectionViewDelegate {

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        viewModel.reels.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier:
                ReelCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as! ReelCollectionViewCell

        cell.configure(
            with: viewModel.reels[indexPath.item]
        )

        cell.onLike = { [weak self] in
            self?.viewModel.toggleLike(
                at: indexPath.item
            )
        }

        cell.onSave = { [weak self] in
            self?.viewModel.toggleSaved(
                at: indexPath.item
            )
        }

        return cell
    }


    
    
    func scrollViewWillBeginDragging(
        _ scrollView: UIScrollView
    ) {
        /*
         Только пауза. Не вызываем seek(to:).
         */
        pauseCurrentReel()
    }

    func scrollViewDidEndDecelerating(
        _ scrollView: UIScrollView
    ) {
        playCurrentReel()
    }

    func scrollViewDidEndDragging(
        _ scrollView: UIScrollView,
        willDecelerate decelerate: Bool
    ) {
        if !decelerate {
            playCurrentReel()
        }
    }

    func scrollViewDidEndScrollingAnimation(
        _ scrollView: UIScrollView
    ) {
        playCurrentReel()
    }

    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        /*
         Ячейка подготовлена, но пока не запускается.
         Она запустится после завершения перелистывания.
         */
        (cell as? ReelCollectionViewCell)?.pause()
    }

    func collectionView(
        _ collectionView: UICollectionView,
        didEndDisplaying cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        guard
            let reelCell = cell as? ReelCollectionViewCell
        else {
            return
        }

        reelCell.stop()

        if playingCell == reelCell {
            playingCell = nil
        }
    }




}




