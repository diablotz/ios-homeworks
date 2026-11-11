//
//  CreateMoviePostViewModel.swift
//  VKApp
//
//  Created by Timur Zakirov on 03/11/26.
//

import Foundation

@MainActor
final class CreateMoviePostViewModel {

    private let movieService: MovieServiceProtocol
    private let feedRepository: FeedRepository
    private let currentUser: AppUser

    private var searchTask: Task<Void, Never>?

    private(set) var movies: [Movie] = []

    var onMoviesChanged: (() -> Void)?
    var onLoadingChanged: ((Bool) -> Void)?
    var onError: ((String) -> Void)?
    var onPostCreated: (() -> Void)?

    init(
        movieService: MovieServiceProtocol,
        feedRepository: FeedRepository,
        currentUser: AppUser
    ) {
        self.movieService = movieService
        self.feedRepository = feedRepository
        self.currentUser = currentUser
    }

    deinit {
        searchTask?.cancel()
    }
    
    func loadPopularMovies() {
        searchTask?.cancel()

        searchTask = Task { [weak self] in
            guard let self else {
                return
            }

            onLoadingChanged?(true)

            defer {
                onLoadingChanged?(false)
            }

            do {
                let result = try await movieService.loadPopular(
                    page: 0
                )

                guard !Task.isCancelled else {
                    return
                }

                movies = result
                onMoviesChanged?()

            } catch {
                if Task.isCancelled
                    || error.isCancellationError {
                    return
                }

                onError?(
                    error.localizedDescription
                )
            }
        }
    }



//    func loadPopularMovies() {
//        searchTask?.cancel()
//
//        searchTask = Task { [weak self] in
//            guard let self else {
//                return
//            }
//
//            onLoadingChanged?(true)
//
//            defer {
//                onLoadingChanged?(false)
//            }
//
//            do {
//                let loadedMovies = try await movieService.loadPopular(
//                    page: 0
//                )
//
//                guard !Task.isCancelled else {
//                    return
//                }
//
//                movies = loadedMovies
//                onMoviesChanged?()
//            } catch is CancellationError {
//                return
//            } catch {
//                onError?(
//                    error.localizedDescription
//                )
//            }
//        }
//    }
    
    func search(
        query: String
    ) {
        searchTask?.cancel()

        let normalizedQuery = query.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !normalizedQuery.isEmpty else {
            loadPopularMovies()
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

                let result = try await movieService.search(
                    query: normalizedQuery
                )

                guard !Task.isCancelled else {
                    return
                }

                movies = result
                onMoviesChanged?()

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
//        guard !normalizedQuery.isEmpty else {
//            loadPopularMovies()
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
//                let searchResult = try await movieService.search(
//                    query: normalizedQuery
//                )
//
//                guard !Task.isCancelled else {
//                    return
//                }
//
//                movies = searchResult
//                onMoviesChanged?()
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

    func movie(
        at index: Int
    ) -> Movie? {
        guard movies.indices.contains(index) else {
            return nil
        }

        return movies[index]
    }
    
    func publish(
        movie: Movie,
        text: String
    ) {
        cancelSearch()

        do {
            try feedRepository.createMoviePost(
                authorID: currentUser.id,
                text: text,
                movie: movie
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
//        movie: Movie,
//        text: String
//    ) {
//        do {
//            try feedRepository.createMoviePost(
//                authorID: currentUser.id,
//                text: text,
//                movie: movie
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


