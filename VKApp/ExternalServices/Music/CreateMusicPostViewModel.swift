//
//  CreateMusicPostViewModel.swift
//  VKApp
//
//  Created by Timur Zakirov on 03/11/26.
//

import Foundation

@MainActor
final class CreateMusicPostViewModel {

    private let musicService: MusicServiceProtocol
    private let feedRepository: FeedRepository
    private let currentUser: AppUser

    private var searchTask: Task<Void, Never>?

    private(set) var tracks: [MusicTrack] = []

    var onTracksChanged: (() -> Void)?
    var onLoadingChanged: ((Bool) -> Void)?
    var onError: ((String) -> Void)?
    var onPostCreated: (() -> Void)?

    init(
        musicService: MusicServiceProtocol,
        feedRepository: FeedRepository,
        currentUser: AppUser
    ) {
        self.musicService = musicService
        self.feedRepository = feedRepository
        self.currentUser = currentUser
    }

    deinit {
        searchTask?.cancel()
    }
    
    func search(
        query: String
    ) {
        searchTask?.cancel()

        let normalizedQuery = query.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard normalizedQuery.count >= 2 else {
            tracks = []
            onTracksChanged?()
            onLoadingChanged?(false)
            return
        }

        searchTask = Task { [weak self] in
            guard let self else {
                return
            }

            do {
                try await Task.sleep(
                    for: .milliseconds(400)
                )

                guard !Task.isCancelled else {
                    return
                }

                onLoadingChanged?(true)

                defer {
                    onLoadingChanged?(false)
                }

                let result = try await musicService.search(
                    query: normalizedQuery
                )

                guard !Task.isCancelled else {
                    return
                }

                tracks = result
                onTracksChanged?()

            } catch {
                if Task.isCancelled
                    || error.isCancellationError {
                    return
                }

                onLoadingChanged?(false)

                onError?(
                    error.localizedDescription
                )
            }
        }
    }



//    func search(
//        query: String
//    ) {
//        searchTask?.cancel()
//
//        let normalizedQuery = query.trimmingCharacters(
//            in: .whitespacesAndNewlines
//        )
//
//        guard normalizedQuery.count >= 2 else {
//            tracks = []
//            onTracksChanged?()
//            onLoadingChanged?(false)
//            return
//        }
//
//        searchTask = Task { [weak self] in
//            guard let self else {
//                return
//            }
//
//            do {
//                try await Task.sleep(
//                    for: .milliseconds(400)
//                )
//
//                guard !Task.isCancelled else {
//                    return
//                }
//
//                onLoadingChanged?(true)
//
//                defer {
//                    onLoadingChanged?(false)
//                }
//
//                let result = try await musicService.search(
//                    query: normalizedQuery
//                )
//
//                guard !Task.isCancelled else {
//                    return
//                }
//
//                tracks = result
//                onTracksChanged?()
//            } catch is CancellationError {
//                return
//            } catch {
//                onLoadingChanged?(false)
//                onError?(
//                    error.localizedDescription
//                )
//            }
//        }
//    }

    func track(
        at index: Int
    ) -> MusicTrack? {
        guard tracks.indices.contains(index) else {
            return nil
        }

        return tracks[index]
    }

    func publish(
        track: MusicTrack,
        text: String
    ) {
        cancelSearch()

        do {
            try feedRepository.createMusicPost(
                authorID: currentUser.id,
                text: text,
                track: track
            )

            onPostCreated?()
        } catch {
            guard !error.isCancellationError else {
                return
            }

            onError?(
                error.localizedDescription
            )
        }
    }


//    func publish(
//        track: MusicTrack,
//        text: String
//    ) {
//        do {
//            try feedRepository.createMusicPost(
//                authorID: currentUser.id,
//                text: text,
//                track: track
//            )
//
//            onPostCreated?()
//        } catch {
//            onError?(
//                error.localizedDescription
//            )
//        }
//    }
    
    func cancelSearch() {
        searchTask?.cancel()
        searchTask = nil
        onLoadingChanged?(false)
    }


}

