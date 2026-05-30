//
//  PhotosViewController.swift
//  Navigation
//

//
//  PhotosViewController.swift
//  Navigation
//

import UIKit
import iOSIntPackage

class PhotosViewController: UIViewController {
    
    // Класс обработки изображений из iOSIntPackage
    private let imageProcessor = ImageProcessor()
    
    let photoIdent = "photoCell"
    
    // таймер для смены картинок
    private var photoTimer: Timer?
    
    //let imagePublisherFacade = ImagePublisherFacade()
    
    private var photos: [UIImage] = []
    
    

    // MARK: Visual objects
    
    lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8)
        return layout
    }()

    lazy var photosCollectionView: UICollectionView = {
        let photos = UICollectionView(frame: .zero, collectionViewLayout: layout)
        photos.translatesAutoresizingMaskIntoConstraints = false
        photos.backgroundColor = .white
        photos.register(PhotosCollectionViewCell.self, forCellWithReuseIdentifier: photoIdent)
        return photos
    }()
    
    // MARK: - Setup section
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Photo Gallery"
        self.view.addSubview(photosCollectionView)
        self.photosCollectionView.dataSource = self
        self.photosCollectionView.delegate = self
        setupConstraints()
        loadImages()
        processImages()
        
        startPhotoTimer()
        
        //imagePublisherFacade.subscribe(self)
        //imagePublisherFacade.addImagesWithTimer(time: 0.5, repeat: 12)
    }
//    deinit {
//        imagePublisherFacade.removeSubscription(for: self)
//        
//        // выдает такое предупреждение Main actor-isolated conformance of 'PhotosViewController' to 'ImageLibrarySubscriber' cannot be used in nonisolated context; this is an error in the Swift 6 language mode,
//        // поэтому в ДЗ №5 в extension PhotosViewController: ImageLibrarySubscriber использовал nonisolated func receive - запрашивал у АИ
//    }
    
    // MARK: - Load Images

    private func loadImages() {

        // Загружаем изображения из assets
        for index in 1...20 {

            // Проверяем наличие изображения
            if let image = UIImage(named: "\(index)") {

                // Добавляем изображение в массив
                photos.append(image)
            }
        }
    }
    
    
    // MARK: - Image Processing

    private func processImages() {

        // Засекаем время начала обработки
        let startTime = CFAbsoluteTimeGetCurrent()
        let q0s: QualityOfService = .userInitiated
        // Обработка изображений в отдельном потоке
        imageProcessor.processImagesOnThread(

            // Исходные изображения
            sourceImages: photos,

            // Фильтр обработки
            filter: .chrome,

            // Приоритет потока
            qos: q0s

        ) { [weak self] processedImages in

            // Защита от retain cycle
            guard let self else { return }

            // Время завершения обработки
            let time = CFAbsoluteTimeGetCurrent() - startTime

            print("Затраченное время: \(time) секунд - .\(q0s.description)")
            //________ Различное время выполнения при установленном filter: .chrome в зависимости от QoS ______
            //Затраченное время: 1.0515469312667847 секунд - .userInitiated
            //Затраченное время: 3.517359972000122 секунд - .background
            //Затраченное время: 0.9997611045837402 секунд - .default
            //Затраченное время: 0.9046719074249268 секунд - .userInteractive
            //Затраченное время: 0.9200000762939453 секунд - .utility

            // Обновляем UI в главном потоке
            DispatchQueue.main.async {

                // Сохраняем обработанные изображения
                self.photos = processedImages.compactMap {
                image in
                    guard let image else { return nil }
                    return UIImage(cgImage: image)
                }

                // Обновляем collectionView
                self.photosCollectionView.reloadData()
            }
        }
    }
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            photosCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            photosCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            photosCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            photosCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = true
        
        photoTimer?.invalidate()
        photoTimer = nil
        
        //imagePublisherFacade.removeSubscription(for: self)
//       избавился от предупреждения Main actor-isolated conformance of 'PhotosViewController' to 'ImageLibrarySubscriber' cannot be used in nonisolated context; this is an error in the Swift 6 language mode
//
//        
    }
    // timer для смены картинок
    private func startPhotoTimer() {
        /*var counter = 10
        let interval = 1.0
        photoTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) {
            [weak self] timer in counter -= 1
            let upToFinish = Double(counter) * interval
            print ("Осталось \(counter) секунд, осталось \(upToFinish) секунд"   )
                
            if counter == 0 {
                //timer.invalidate()
                self?.changePhoto()
            }
            
        }
         */
        photoTimer = Timer.scheduledTimer(
            timeInterval: 10,
            target: self,
            selector: #selector(changePhoto),
            userInfo: nil,
            repeats: true
        )
    }
    
    // смена фоток
    @objc private func changePhoto() {
        // очищаем коллекцию фоток
        photos.removeAll()
        
        DispatchQueue.main.async {

            // Сохраняем обработанные изображения
            self.photos = Photos.shared.examples.shuffled()

            // Обновляем collectionView
            self.photosCollectionView.reloadData()
        }
        
    }
}

// MARK: - Extensions

extension PhotosViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let countItem: CGFloat = 2
        let accessibleWidth = collectionView.frame.width - 32
        let widthItem = (accessibleWidth / countItem)
        return CGSize(width: widthItem, height: widthItem * 0.56)
    }
}

extension PhotosViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return Photos.shared.examples.count
        return photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //let imageView = UIImageView()
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: photoIdent, for: indexPath) as? PhotosCollectionViewCell else { return UICollectionViewCell()}
        //cell.configCellCollection(photo: Photos.shared.examples[indexPath.item])
        cell.configCellCollection(photo: photos[indexPath.item])
        //cell.imageView.image = photos[indexPath.item]
        return cell
    }
}


extension PhotosViewController: ImageLibrarySubscriber {
    /*
     nonisolated func receive(images: [UIImage]) {

        let loadedImages = images.compactMap { $0 }
        Task { @MainActor in
             photos.append(contentsOf: loadedImages)
             
             photosCollectionView.reloadData()
         }
    }
     */
    func receive(images: [UIImage]) {
        photos = images
        photosCollectionView.reloadData()
    }
}


extension QualityOfService {

    var description: String {
        switch self {
        case .background:
            return "background"
        case .utility:
            return "utility"
        case .default:
            return "default"
        case .userInitiated:
            return "userInitiated"
        case .userInteractive:
            return "userInteractive"
        default:
            return "unspecified"
        }
    }
}

