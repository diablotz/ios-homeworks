//
//  LocalImageStore.swift
//  VKApp
//
//  Created by Timur Zakirov on 03/10/26.
//

import UIKit

enum LocalImageStoreError: Error {
    case jpegConversionFailed
}

final class LocalImageStore {

    static let shared = LocalImageStore()

    private let fileManager = FileManager.default

    private init() {}

    func save(
        image: UIImage,
        prefix: String
    ) throws -> String {
        guard
            let data = image.jpegData(
                compressionQuality: 0.85
            )
        else {
            throw LocalImageStoreError
                .jpegConversionFailed
        }

        let fileName =
            "\(prefix)_\(UUID().uuidString).jpg"

        let url = try directoryURL()
            .appendingPathComponent(fileName)

        try data.write(
            to: url,
            options: .atomic
        )

        return fileName
    }

    func image(fileName: String) -> UIImage? {
        if let assetImage = UIImage(named: fileName) {
            return assetImage
        }

        guard
            let directory = try? directoryURL()
        else {
            return nil
        }

        let url = directory.appendingPathComponent(fileName)

        return UIImage(contentsOfFile: url.path)
    }
    
//    func image(fileName: String) -> UIImage? {
//        guard let url = fileURL(for: fileName) else {
//            return nil
//        }
//
//        return UIImage(contentsOfFile: url.path)
//    }



    private func directoryURL() throws -> URL {
        let rootURL = try fileManager.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )

        let imagesURL = rootURL.appendingPathComponent(
            "VKAppImages",
            isDirectory: true
        )

        if !fileManager.fileExists(
            atPath: imagesURL.path
        ) {
            try fileManager.createDirectory(
                at: imagesURL,
                withIntermediateDirectories: true
            )
        }

        return imagesURL
    }
}

