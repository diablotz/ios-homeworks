//
//  MessengerViewModel.swift
//  VKApp
//
//  Created by Timur Zakirov on 02/10/26.
//

import Foundation

final class MessengerViewModel {

    private let repository: MessengerRepository

    private(set) var conversations: [ConversationItem] = []

    var onDataChanged: (() -> Void)?
    var onError: ((String) -> Void)?

    init(repository: MessengerRepository) {
        self.repository = repository
    }

    func loadConversations() {
        do {
            conversations =
                try repository.fetchConversations()
            onDataChanged?()
        } catch {
            show(error)
        }
    }

    func conversation(
        at index: Int
    ) -> ConversationItem? {
        guard conversations.indices.contains(index) else {
            return nil
        }

        return conversations[index]
    }

    private func show(_ error: Error) {
        onError?(
            (error as? LocalizedError)?.errorDescription
            ?? "Не удалось загрузить диалоги"
        )
    }
}
