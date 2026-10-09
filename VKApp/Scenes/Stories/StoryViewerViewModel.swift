//
//  StoryViewerViewModel.swift
//  VKApp
//
//  Created by Timur Zakirov on 03/10/26.
//

import Foundation

final class StoryViewerViewModel {

    private let repository: FeedRepository

    let stories: [FeedStory]

    private(set) var currentIndex: Int

    var currentStory: FeedStory {
        stories[currentIndex]
    }

    var canMoveBack: Bool {
        currentIndex > 0
    }

    var canMoveForward: Bool {
        currentIndex < stories.count - 1
    }

    init(
        stories: [FeedStory],
        initialIndex: Int,
        repository: FeedRepository
    ) {
        self.stories = stories
        self.repository = repository

        currentIndex = min(
            max(initialIndex, 0),
            max(stories.count - 1, 0)
        )
    }

    func markCurrentAsViewed() {
        try? repository.markStoryAsViewed(
            id: currentStory.id
        )
    }

    func moveForward() -> Bool {
        guard canMoveForward else {
            return false
        }

        currentIndex += 1
        return true
    }

    func moveBack() -> Bool {
        guard canMoveBack else {
            return false
        }

        currentIndex -= 1
        return true
    }
}

