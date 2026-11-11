//
//  RemoteImageLoader.swift
//  VKApp
//
//  Created by Timur Zakirov on 03/11/26.
//

import UIKit

@MainActor
final class RemoteImageLoader {

    static let shared = RemoteImageLoader()

    private let cache = NSCache<NSURL, UIImage>()

    private init() {}

    func image(
        from url: URL
    ) async throws -> UIImage {
        if let cachedImage = cache.object(
            forKey: url as NSURL
        ) {
            return cachedImage
        }

        let (data, response) = try await URLSession.shared.data(
            from: url
        )

        guard let httpResponse = response as? HTTPURLResponse,
              200...299 ~= httpResponse.statusCode,
              let image = UIImage(data: data)
        else {
            throw RemoteImageError.invalidImage
        }

        cache.setObject(
            image,
            forKey: url as NSURL
        )

        return image
    }
}

enum RemoteImageError: LocalizedError {

    case invalidImage

    var errorDescription: String? {
        switch self {
        case .invalidImage:
            return "Не удалось загрузить изображение"
        }
    }
}

