//
//  ReelsViewModel.swift
//  VKApp
//
//  Created by Timur Zakirov on 03/10/26.
//

import Foundation

final class ReelsViewModel {

    private let repository: ReelRepository

    private(set) var reels: [ReelItem] = []

    var onDataChanged: (() -> Void)?
    var onError: ((String) -> Void)?

    init(repository: ReelRepository) {
        self.repository = repository
    }

    func loadReels() {
        do {
            reels = try repository.fetchReels()
            onDataChanged?()
        } catch {
            show(error)
        }
    }

    func toggleLike(at index: Int) {
        guard reels.indices.contains(index) else {
            return
        }

        do {
            try repository.toggleLike(
                id: reels[index].id
            )
            loadReels()
        } catch {
            show(error)
        }
    }

    func toggleSaved(at index: Int) {
        guard reels.indices.contains(index) else {
            return
        }

        do {
            try repository.toggleSaved(
                id: reels[index].id
            )
            loadReels()
        } catch {
            show(error)
        }
    }

    private func show(_ error: Error) {
        onError?(
            (error as? LocalizedError)?.errorDescription
            ?? "Не удалось выполнить операцию"
        )
    }
}
