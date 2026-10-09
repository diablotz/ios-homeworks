//
//  SearchViewModel.swift
//  VKApp
//
//  Created by Timur Zakirov on 02/10/26.
//

import Foundation

final class SearchViewModel {

    private let userRepository: UserRepository
    private let feedRepository: FeedRepository
    private let photoRepository: PhotoRepository

    private var allUsers: [FriendListItem] = []
    private var allPosts: [FeedPost] = []
    private var allPhotos: [PhotoItem] = []

    private var query = ""
    private var mode: SearchMode = .forYou

    private(set) var users: [FriendListItem] = []
    private(set) var posts: [FeedPost] = []
    private(set) var photos: [PhotoItem] = []

    var onDataChanged: (() -> Void)?
    var onError: ((String) -> Void)?

    init(
        userRepository: UserRepository,
        feedRepository: FeedRepository,
        photoRepository: PhotoRepository
    ) {
        self.userRepository = userRepository
        self.feedRepository = feedRepository
        self.photoRepository = photoRepository
    }

    func loadData() {
        do {
            allUsers = try userRepository.fetchUsers()
            allPosts = try feedRepository.fetchPosts()
            allPhotos = try photoRepository.fetchPhotos()

            applyFilters()
        } catch {
            show(error)
        }
    }

    func setMode(index: Int) {
        mode = SearchMode(rawValue: index) ?? .forYou
        applyFilters()
    }

    func search(text: String) {
        query = text.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        applyFilters()
    }

    func toggleLike(at index: Int) {
        guard posts.indices.contains(index) else {
            return
        }

        do {
            try feedRepository.toggleLike(
                postID: posts[index].id
            )

            allPosts = try feedRepository.fetchPosts()
            applyFilters()
        } catch {
            show(error)
        }
    }

    private func applyFilters() {
        if query.isEmpty {
            users = []

            switch mode {
            case .forYou:
                photos = allPhotos
                posts = []

            case .news:
                photos = []
                posts = allPosts
            }
        } else {
            photos = []

            users = allUsers.filter {
                $0.fullName.localizedCaseInsensitiveContains(
                    query
                )
            }

            posts = allPosts.filter {
                $0.authorName.localizedCaseInsensitiveContains(
                    query
                )
                || $0.text.localizedCaseInsensitiveContains(
                    query
                )
            }
        }

        onDataChanged?()
    }

    private func show(_ error: Error) {
        onError?(
            (error as? LocalizedError)?.errorDescription
            ?? "Не удалось выполнить поиск"
        )
    }
}
