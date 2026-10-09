//
//  FriendsViewModel.swift
//  VKApp
//
//  Created by Timur Zakirov on 01/10/26.
//

import Foundation

final class FriendsViewModel {

    private let repository: UserRepository

    private(set) var friends: [FriendListItem] = []
    private var allFriends: [FriendListItem] = []

    var onDataChanged: (() -> Void)?
    var onError: ((String) -> Void)?

    init(repository: UserRepository) {
        self.repository = repository
    }

    func loadFriends() {
        do {
            allFriends = try repository.fetchFriends()
            friends = allFriends
            onDataChanged?()
        } catch {
            show(error)
        }
    }

    func search(text: String) {
        let query = text.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !query.isEmpty else {
            friends = allFriends
            onDataChanged?()
            return
        }

        friends = allFriends.filter {
            $0.fullName.localizedCaseInsensitiveContains(query)
        }

        onDataChanged?()
    }

    func friend(at index: Int) -> FriendListItem? {
        guard friends.indices.contains(index) else {
            return nil
        }

        return friends[index]
    }

    private func show(_ error: Error) {
        let message =
            (error as? LocalizedError)?.errorDescription
            ?? "Не удалось загрузить друзей"

        onError?(message)
    }
}
