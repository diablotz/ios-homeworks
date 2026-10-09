//
//  CreateStoryViewModel.swift
//  VKApp
//
//  Created by Timur Zakirov on 03/10/26.
//

import UIKit

final class CreateStoryViewModel {

    private let currentUserID: UUID
    private let repository: FeedRepository
    private let imageStore: LocalImageStore

    var onCreated: (() -> Void)?
    var onError: ((String) -> Void)?

    init(
        currentUserID: UUID,
        repository: FeedRepository,
        imageStore: LocalImageStore = .shared
    ) {
        self.currentUserID = currentUserID
        self.repository = repository
        self.imageStore = imageStore
    }

    func createStory(image: UIImage) {
        do {
            let imageName = try imageStore.save(
                image: image,
                prefix: "story"
            )

            try repository.createStory(
                authorID: currentUserID,
                imageName: imageName
            )

            onCreated?()
        } catch {
            onError?("Не удалось создать историю")
        }
    }
}

