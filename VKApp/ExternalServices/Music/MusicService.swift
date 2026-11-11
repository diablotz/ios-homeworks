//
//  MusicService.swift
//  VKApp
//
//  Created by Timur Zakirov on 02/11/26.
//

import Foundation

protocol MusicServiceProtocol: Sendable {

    func search(
        query: String
    ) async throws -> [MusicTrack]
}



struct MusicService: MusicServiceProtocol {

    private let client = APIClient()

    func search(
        query: String
    ) async throws -> [MusicTrack] {
        guard var components = URLComponents(
            string:
                "https://itunes.apple.com/search"
        ) else {
            throw APIError.invalidURL
        }

        components.queryItems = [
            URLQueryItem(
                name: "term",
                value: query
            ),
            URLQueryItem(
                name: "media",
                value: "music"
            ),
            URLQueryItem(
                name: "entity",
                value: "song"
            ),
            URLQueryItem(
                name: "limit",
                value: "30"
            ),
            URLQueryItem(
                name: "country",
                value: "US"
            ),
            URLQueryItem(
                name: "explicit",
                value: "No"
            )
        ]

        guard let url = components.url else {
            throw APIError.invalidURL
        }

        let response = try await client.get(
            url: url,
            responseType:
                MusicSearchResponse.self
        )

        return response.results.filter {
            $0.previewURL != nil
        }
    }
}

