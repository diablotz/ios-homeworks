//
//  PostImageLoader.swift
//  VKApp
//
//  Created by Timur Zakirov on 07/10/26.
//


import UIKit

enum PostImageLoader {

    static func image(
        named imageName: String?
    ) -> UIImage? {
        guard let imageName,
              !imageName.isEmpty
        else {
            return nil
        }

        // 1. Assets.xcassets
        if let image = UIImage(named: imageName) {
            return image
        }

        // 2. Assets без расширения
        let nameWithoutExtension = URL(
            fileURLWithPath: imageName
        )
        .deletingPathExtension()
        .lastPathComponent

        if let image = UIImage(
            named: nameWithoutExtension
        ) {
            return image
        }

        // 3. Полный путь
        if imageName.hasPrefix("/"),
           let image = UIImage(
               contentsOfFile: imageName
           ) {
            return image
        }

        // 4. Локальное хранилище
        if let image = LocalImageStore.shared.image(
            fileName: imageName
        ) {
            return image
        }

        // 5. Отдельный файл в Bundle
        let fileURL = URL(
            fileURLWithPath: imageName
        )

        let resourceName = fileURL
            .deletingPathExtension()
            .lastPathComponent

        let fileExtension = fileURL.pathExtension

        if !fileExtension.isEmpty,
           let bundleURL = Bundle.main.url(
               forResource: resourceName,
               withExtension: fileExtension
           ),
           let image = UIImage(
               contentsOfFile: bundleURL.path
           ) {
            return image
        }

        print("PostImageLoader не нашёл:", imageName)

        return nil
    }
}



//import UIKit
//
//enum PostImageLoader {
//
//    static func image(
//        named imageName: String?
//    ) -> UIImage? {
//        guard let imageName,
//              !imageName.isEmpty
//        else {
//            return nil
//        }
//
//        /*
//         1. Картинка из Assets.xcassets или Bundle.
//         */
//        if let image = UIImage(named: imageName) {
//            return image
//        }
//
//        /*
//         2. Локальная картинка из Application Support.
//         */
//        if let image = LocalImageStore.shared.image(
//            fileName: imageName
//        ) {
//            return image
//        }
//
//        print("Не найдена картинка:", imageName)
//
//        return nil
//    }
//}

