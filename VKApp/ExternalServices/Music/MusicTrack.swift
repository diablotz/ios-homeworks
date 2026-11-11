//
//  MusicTrack.swift
//  VKApp
//
//  Created by Timur Zakirov on 02/11/26.
//

import Foundation

nonisolated struct MusicSearchResponse: Decodable, Sendable {
    let resultCount: Int
    let results: [MusicTrack]
}




nonisolated struct MusicTrack: Decodable, Identifiable, Sendable {

    let trackId: Int
    let trackName: String
    let artistName: String
    let collectionName: String?
    let artworkUrl100: String?
    let previewUrl: String?
    let trackViewUrl: String?
    let primaryGenreName: String?
    let trackTimeMillis: Int?

    var id: Int {
        trackId
    }

    var artworkURL: URL? {
        guard let artworkUrl100 else {
            return nil
        }

        /*
         Запрашиваем более крупную версию обложки.
         */
        let enlargedURL = artworkUrl100.replacingOccurrences(
            of: "100x100",
            with: "600x600"
        )

        return secureURL(from: enlargedURL)
    }

    var previewURL: URL? {
        secureURL(from: previewUrl)
    }

    var storeURL: URL? {
        secureURL(from: trackViewUrl)
    }

    var subtitle: String {
        if let collectionName,
           !collectionName.isEmpty {
            return "\(artistName) • \(collectionName)"
        }

        return artistName
    }

    var durationText: String {
        guard let trackTimeMillis else {
            return ""
        }

        let totalSeconds = trackTimeMillis / 1_000
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60

        return String(
            format: "%d:%02d",
            minutes,
            seconds
        )
    }

    private func secureURL(
        from value: String?
    ) -> URL? {
        guard let value,
              var components = URLComponents(
                  string: value
              )
        else {
            return nil
        }

        components.scheme = "https"

        return components.url
    }
}

