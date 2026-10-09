//
//  CreateContentType.swift
//  VKApp
//
//  Created by Timur Zakirov on 02/10/26.
//

import UIKit

enum CreateContentType: CaseIterable {
    case story
    case post
    case clip
    case video

    var title: String {
        switch self {
        case .story:
            return "История"

        case .post:
            return "Пост"

        case .clip:
            return "Клип"

        case .video:
            return "Видео"
        }
    }

    var image: UIImage? {
        switch self {
        case .story:
            return UIImage(systemName: "camera.circle")

        case .post:
            return UIImage(
                systemName: "square.and.pencil"
            )

        case .clip:
            return UIImage(
                systemName: "play.rectangle.on.rectangle"
            )

        case .video:
            return UIImage(systemName: "video")
        }
    }
}
