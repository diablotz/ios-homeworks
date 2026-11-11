//
//  Movie.swift
//  VKApp
//
//  Created by Timur Zakirov on 02/11/26.
//

import Foundation

nonisolated struct Movie: Decodable, Identifiable, Sendable {

    let id: Int
    let name: String
    let genres: [String]
    let rating: MovieRating
    let image: MovieImage?
    let summary: String?
    let premiered: String?
    let url: String?

    var posterURL: URL? {
        guard let value =
                image?.original ?? image?.medium
        else {
            return nil
        }

        return URL(string: value)
    }

    var ratingText: String {
        guard let value = rating.average else {
            return L10n.string("movie.no_rating")
        }

        return String(
            format: "★ %.1f",
            value
        )
    }

    var yearText: String {
        guard let premiered,
              premiered.count >= 4
        else {
            return L10n.string("movie.year_unknown")
        }

        return String(premiered.prefix(4))
    }

    var subtitle: String {
        let genresText = genres.isEmpty
            ? L10n.string("movie.no_genre")
            : genres.joined(separator: ", ")

        return "\(yearText) • \(genresText) • \(ratingText)"
    }
}

struct MovieRating: Decodable, Sendable {
    let average: Double?
}

struct MovieImage: Decodable, Sendable {
    let medium: String?
    let original: String?
}

nonisolated struct MovieSearchResult: Decodable, Sendable {
    let score: Double
    let show: Movie
}

