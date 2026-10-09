//
//  ProfileViewModel.swift
//  VKApp
//
//  Created by Timur Zakirov on 01/10/26.
//

import Foundation

final class ProfileViewModel {

    private let userID: UUID
    private let userRepository: UserRepository
    private let feedRepository: FeedRepository

    private(set) var user: AppUser?
    private(set) var posts: [FeedPost] = []

    var onDataChanged: (() -> Void)?
    var onError: ((String) -> Void)?

    init(
        userID: UUID,
        userRepository: UserRepository,
        feedRepository: FeedRepository
    ) {
        self.userID = userID
        self.userRepository = userRepository
        self.feedRepository = feedRepository
    }

    func loadData() {
        do {
            user = try userRepository.fetchUser(id: userID)
            posts = try feedRepository.fetchPosts(
                authorID: userID
            )

            guard user != nil else {
                onError?("Пользователь не найден")
                return
            }

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
            try feedRepository.toggleLike(
                postID: posts[index].id
            )

            posts = try feedRepository.fetchPosts(
                authorID: userID
            )

            onDataChanged?()
        } catch {
            show(error)
        }
    }

    private func show(_ error: Error) {
        let message =
            (error as? LocalizedError)?.errorDescription
            ?? "Не удалось загрузить профиль"

        onError?(message)
    }
}
