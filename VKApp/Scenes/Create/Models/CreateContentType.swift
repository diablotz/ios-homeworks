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
    case movie
    case music

    var title: String {
        switch self {
        case .story:
            return L10n.string(
                "create.story"
            )

        case .post:
            return L10n.string(
                "create.post"
            )

        case .clip:
            return L10n.string(
                "create.clip"
            )

        case .video:
            return L10n.string(
                "create.video"
            )

        case .movie:
            return L10n.string(
                "create.movie"
            )

        case .music:
            return L10n.string(
                "create.music"
            )
        }
    }

    var image: UIImage? {
        switch self {
        case .story:
            return UIImage(
                systemName: "camera"
            )

        case .post:
            return UIImage(
                systemName: "square.and.pencil"
            )

        case .clip:
            return UIImage(
                systemName: "play.rectangle"
            )

        case .video:
            return UIImage(
                systemName: "video"
            )

        case .movie:
            return UIImage(
                systemName: "film.stack"
            )

        case .music:
            return UIImage(
                systemName: "music.note"
            )
        }
    }
}


//enum CreateContentType: CaseIterable {
//    case story
//    case post
//    case clip
//    case video
//
//    var title: String {
//        switch self {
//        case .story:
//            return "История"
//
//        case .post:
//            return "Пост"
//
//        case .clip:
//            return "Клип"
//
//        case .video:
//            return "Видео"
//        }
//    }
//
//    var image: UIImage? {
//        switch self {
//        case .story:
//            return UIImage(systemName: "camera.circle")
//
//        case .post:
//            return UIImage(
//                systemName: "square.and.pencil"
//            )
//
//        case .clip:
//            return UIImage(
//                systemName: "play.rectangle.on.rectangle"
//            )
//
//        case .video:
//            return UIImage(systemName: "video")
//        }
//    }
//}
