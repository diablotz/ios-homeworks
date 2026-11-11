//
//  MovieService.swift
//  VKApp
//
//  Created by Timur Zakirov on 02/11/26.
//

import Foundation

protocol MovieServiceProtocol: Sendable {

    func loadPopular(
        page: Int
    ) async throws -> [Movie]

    func search(
        query: String
    ) async throws -> [Movie]
}

struct MovieService: MovieServiceProtocol {

    private let client = APIClient()

    func loadPopular(
        page: Int = 0
    ) async throws -> [Movie] {
        guard var components = URLComponents(
            string: "https://api.tvmaze.com/shows"
        ) else {
            throw APIError.invalidURL
        }

        components.queryItems = [
            URLQueryItem(
                name: "page",
                value: String(page)
            )
        ]

        guard let url = components.url else {
            throw APIError.invalidURL
        }

        return try await client.get(
            url: url,
            responseType: [Movie].self
        )
    }

    func search(
        query: String
    ) async throws -> [Movie] {
        guard var components = URLComponents(
            string:
                "https://api.tvmaze.com/search/shows"
        ) else {
            throw APIError.invalidURL
        }

        components.queryItems = [
            URLQueryItem(
                name: "q",
                value: query
            )
        ]

        guard let url = components.url else {
            throw APIError.invalidURL
        }

        let result = try await client.get(
            url: url,
            responseType: [MovieSearchResult].self
        )

        return result.map(\.show)
    }
}

