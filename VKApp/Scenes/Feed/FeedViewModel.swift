//
//  FeedViewModel.swift
//  VKApp
//
//  Created by Timur Zakirov on 01/10/26.
//

import Foundation

final class FeedViewModel {

    private let repository: FeedRepository

    private(set) var stories: [FeedStory] = []
    private(set) var posts: [FeedPost] = []

    var onDataChanged: (() -> Void)?
    var onError: ((String) -> Void)?

    init(repository: FeedRepository) {
        self.repository = repository
    }

    func loadData() {
        do {
            stories = try repository.fetchStories()
            posts = try repository.fetchPosts()
            onDataChanged?()
        } catch {
            show(error)
        }
    }

    func toggleLike(at index: Int) {
        guard posts.indices.contains(index) else {
            return
        }

        do {
            try repository.toggleLike(
                postID: posts[index].id
            )

            posts = try repository.fetchPosts()
            onDataChanged?()
        } catch {
            show(error)
        }
    }

    private func show(_ error: Error) {
        let message =
            (error as? LocalizedError)?.errorDescription
            ?? "Произошла неизвестная ошибка"

        onError?(message)
    }
}
