//
//  CreatePostViewModel.swift
//  VKApp
//
//  Created by Timur Zakirov on 02/10/26.
//

import Foundation

final class CreatePostViewModel {

    private let currentUserID: UUID
    private let repository: FeedRepository

    var onPostCreated: (() -> Void)?
    var onError: ((String) -> Void)?

    init(
        currentUserID: UUID,
        repository: FeedRepository
    ) {
        self.currentUserID = currentUserID
        self.repository = repository
    }

    func createPost(text: String) {
        do {
            try repository.createPost(
                authorID: currentUserID,
                text: text,
                imageName: nil
            )

            onPostCreated?()
        } catch {
            let message =
                (error as? LocalizedError)?.errorDescription
                ?? "Не удалось создать публикацию"

            onError?(message)
        }
    }
}
