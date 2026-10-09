//
//  PhotosViewModel.swift
//  VKApp
//
//  Created by Timur Zakirov on 01/10/26.
//

import Foundation

final class PhotosViewModel {

    private let repository: PhotoRepository

    private(set) var photos: [PhotoItem] = []

    var onDataChanged: (() -> Void)?
    var onError: ((String) -> Void)?

    init(repository: PhotoRepository) {
        self.repository = repository
    }

    func loadPhotos() {
        do {
            photos = try repository.fetchPhotos()
            onDataChanged?()
        } catch {
            show(error)
        }
    }

    func photo(at index: Int) -> PhotoItem? {
        guard photos.indices.contains(index) else {
            return nil
        }

        return photos[index]
    }

    func toggleLike(photoID: UUID) {
        do {
            try repository.toggleLike(photoID: photoID)
            photos = try repository.fetchPhotos()
            onDataChanged?()
        } catch {
            show(error)
        }
    }

    private func show(_ error: Error) {
        let message =
            (error as? LocalizedError)?.errorDescription
            ?? "Не удалось загрузить фотографии"

        onError?(message)
    }
}
