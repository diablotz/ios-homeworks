//
//  LocalVideoStore.swift
//  VKApp
//
//  Created by Timur Zakirov on 06/10/26.
//

import Foundation

final class LocalVideoStore: @unchecked Sendable {

    static let shared = LocalVideoStore()

    private let fileManager = FileManager.default

    private init() {}

    private var videosDirectoryURL: URL {
        let applicationSupportURL = fileManager.urls(
            for: .applicationSupportDirectory,
            in: .userDomainMask
        )[0]

        return applicationSupportURL.appendingPathComponent(
            "Videos",
            isDirectory: true
        )
    }

    private func createDirectoryIfNeeded() throws {
        guard !fileManager.fileExists(
            atPath: videosDirectoryURL.path
        ) else {
            return
        }

        try fileManager.createDirectory(
            at: videosDirectoryURL,
            withIntermediateDirectories: true
        )
    }

    func saveVideo(from temporaryURL: URL) throws -> String {
        try createDirectoryIfNeeded()

        let originalExtension = temporaryURL.pathExtension
        let fileExtension = originalExtension.isEmpty
            ? "mov"
            : originalExtension

        let fileName =
            "video_\(UUID().uuidString).\(fileExtension)"

        let destinationURL = videosDirectoryURL
            .appendingPathComponent(fileName)

        try fileManager.copyItem(
            at: temporaryURL,
            to: destinationURL
        )

        guard fileManager.fileExists(
            atPath: destinationURL.path
        ) else {
            throw LocalVideoStoreError.copyFailed
        }

        print("Видео скопировано:")
        print(destinationURL.path)

        return fileName
    }
    
    func url(for fileName: String) -> URL? {
        let trimmedName = fileName.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !trimmedName.isEmpty,
              trimmedName != "\"\"",
              trimmedName != "''"
        else {
            print("Передано пустое имя видео")
            return nil
        }

        let sourceURL = URL(
            fileURLWithPath: trimmedName
        )

        let safeFileName = sourceURL.lastPathComponent
        let nameWithoutExtension = sourceURL
            .deletingPathExtension()
            .lastPathComponent

        let existingExtension = sourceURL.pathExtension

        // 1. Пользовательские видео из Application Support
        let exactLocalURL = videosDirectoryURL
            .appendingPathComponent(safeFileName)

        if fileManager.fileExists(
            atPath: exactLocalURL.path
        ) {
            print(
                "Видео найдено в Application Support:",
                exactLocalURL.path
            )

            return exactLocalURL
        }

        // 2. Локальное видео без указанного расширения
        if existingExtension.isEmpty {
            for fileExtension in ["mp4", "mov", "m4v"] {
                let localURL = videosDirectoryURL
                    .appendingPathComponent(
                        "\(safeFileName).\(fileExtension)"
                    )

                if fileManager.fileExists(
                    atPath: localURL.path
                ) {
                    print(
                        "Видео найдено в Application Support:",
                        localURL.path
                    )

                    return localURL
                }
            }
        }

        // 3. Файл с расширением в корне Bundle
        if !existingExtension.isEmpty,
           let bundleURL = Bundle.main.url(
               forResource: nameWithoutExtension,
               withExtension: existingExtension
           ) {
            print(
                "Видео найдено в Bundle:",
                bundleURL.path
            )

            return bundleURL
        }

        // 4. Файл без расширения в корне Bundle
        for fileExtension in ["mp4", "mov", "m4v"] {
            if let bundleURL = Bundle.main.url(
                forResource: nameWithoutExtension,
                withExtension: fileExtension
            ) {
                print(
                    "Видео найдено в Bundle:",
                    bundleURL.path
                )

                return bundleURL
            }
        }

        // 5. Файл внутри папки Videos в Bundle
        for fileExtension in ["mp4", "mov", "m4v"] {
            if let bundleURL = Bundle.main.url(
                forResource: nameWithoutExtension,
                withExtension: fileExtension,
                subdirectory: "Videos"
            ) {
                print(
                    "Видео найдено в Bundle/Videos:",
                    bundleURL.path
                )

                return bundleURL
            }
        }

        print("Видео не найдено:", trimmedName)
        print(
            "Проверен Application Support:",
            exactLocalURL.path
        )

        return nil
    }



//    func url(for fileName: String) -> URL? {
//        let safeFileName = URL(
//            fileURLWithPath: fileName
//        ).lastPathComponent
//
//        let fileURL = videosDirectoryURL
//            .appendingPathComponent(safeFileName)
//
//        guard fileManager.fileExists(
//            atPath: fileURL.path
//        ) else {
//            print("Видео не найдено:")
//            print(fileURL.path)
//            return nil
//        }
//
//        return fileURL
//    }

    func deleteVideo(fileName: String) throws {
        guard let fileURL = url(for: fileName) else {
            return
        }

        try fileManager.removeItem(at: fileURL)
    }
}

enum LocalVideoStoreError: LocalizedError {
    case copyFailed

    var errorDescription: String? {
        switch self {
        case .copyFailed:
            return "Не удалось сохранить видео."
        }
    }
}


//import Foundation
//
//final class LocalVideoStore: @unchecked Sendable {
//
//    static let shared = LocalVideoStore()
//
//    private let fileManager = FileManager.default
//
//    private init() {}
//
//    private var videosDirectoryURL: URL {
//        let applicationSupportURL = fileManager.urls(
//            for: .applicationSupportDirectory,
//            in: .userDomainMask
//        )[0]
//
//        return applicationSupportURL.appendingPathComponent(
//            "Videos",
//            isDirectory: true
//        )
//    }
//
//    private func createVideosDirectoryIfNeeded() throws {
//        let directoryURL = videosDirectoryURL
//
//        guard !fileManager.fileExists(
//            atPath: directoryURL.path
//        ) else {
//            return
//        }
//
//        try fileManager.createDirectory(
//            at: directoryURL,
//            withIntermediateDirectories: true
//        )
//    }
//
//    @discardableResult
//    func saveVideo(from temporaryURL: URL) throws -> String {
//        try createVideosDirectoryIfNeeded()
//
//        var fileExtension = temporaryURL.pathExtension.lowercased()
//
//        if fileExtension.isEmpty {
//            fileExtension = "mov"
//        }
//
//        let fileName =
//            "video_\(UUID().uuidString).\(fileExtension)"
//
//        let destinationURL = videosDirectoryURL
//            .appendingPathComponent(fileName)
//
//        if fileManager.fileExists(
//            atPath: destinationURL.path
//        ) {
//            try fileManager.removeItem(at: destinationURL)
//        }
//
//        /*
//         Файл из PHPicker является временным,
//         поэтому копируем его сразу.
//         */
//        try fileManager.copyItem(
//            at: temporaryURL,
//            to: destinationURL
//        )
//
//        guard fileManager.fileExists(
//            atPath: destinationURL.path
//        ) else {
//            throw LocalVideoStoreError.fileWasNotCopied
//        }
//
//        print("Видео сохранено:")
//        print(destinationURL.path)
//
//        return fileName
//    }
//
//    func url(for fileName: String) -> URL? {
//        /*
//         Защищаемся от случая, когда в Core Data
//         случайно сохранился полный путь.
//         */
//        let safeFileName = URL(
//            fileURLWithPath: fileName
//        ).lastPathComponent
//
//        let videoURL = videosDirectoryURL
//            .appendingPathComponent(safeFileName)
//
//        guard fileManager.fileExists(
//            atPath: videoURL.path
//        ) else {
//            print("Файл видео отсутствует:")
//            print(videoURL.path)
//            return nil
//        }
//
//        return videoURL
//    }
//
//    func deleteVideo(fileName: String) throws {
//        guard let videoURL = url(for: fileName) else {
//            return
//        }
//
//        try fileManager.removeItem(at: videoURL)
//    }
//}
//
//enum LocalVideoStoreError: LocalizedError {
//    case fileWasNotCopied
//
//    var errorDescription: String? {
//        switch self {
//        case .fileWasNotCopied:
//            return "Не удалось скопировать видео в хранилище."
//        }
//    }
//}
//
//
////import Foundation
////
////enum LocalVideoStoreError: LocalizedError {
////    case invalidFile
////
////    var errorDescription: String? {
////        switch self {
////        case .invalidFile:
////            return "Некорректный видеофайл"
////        }
////    }
////}
////
////
////
////final class LocalVideoStore {
////
////    static let shared = LocalVideoStore()
////
////    private let fileManager = FileManager.default
////
////    private init() {}
////    
////    func saveVideo(from sourceURL: URL) throws -> String {
////        guard sourceURL.isFileURL else {
////            throw LocalVideoStoreError.invalidFile
////        }
////
////        let fileExtension = sourceURL.pathExtension.isEmpty
////            ? "mov"
////            : sourceURL.pathExtension.lowercased()
////
////        let fileName =
////            "clip_\(UUID().uuidString).\(fileExtension)"
////
////        let destinationURL = try directoryURL()
////            .appendingPathComponent(fileName)
////
////        let sourceWasAccessed =
////            sourceURL.startAccessingSecurityScopedResource()
////
////        defer {
////            if sourceWasAccessed {
////                sourceURL.stopAccessingSecurityScopedResource()
////            }
////        }
////
////        do {
////            try FileManager.default.copyItem(
////                at: sourceURL,
////                to: destinationURL
////            )
////
////            return fileName
////        } catch {
////            throw error
////        }
////    }
////
////
////
//////    func saveVideo(from sourceURL: URL) throws -> String {
//////        guard sourceURL.isFileURL else {
//////            throw LocalVideoStoreError.invalidFile
//////        }
//////
//////        let fileExtension = sourceURL.pathExtension.isEmpty
//////            ? "mp4"
//////            : sourceURL.pathExtension.lowercased()
//////
//////        let fileName =
//////            "clip_\(UUID().uuidString).\(fileExtension)"
//////
//////        let destinationURL = try directoryURL()
//////            .appendingPathComponent(fileName)
//////
//////        if fileManager.fileExists(
//////            atPath: destinationURL.path
//////        ) {
//////            try fileManager.removeItem(
//////                at: destinationURL
//////            )
//////        }
//////
//////        try fileManager.copyItem(
//////            at: sourceURL,
//////            to: destinationURL
//////        )
//////
//////        return fileName
//////    }
////    
////    func url(for fileName: String) -> URL? {
////        let fileManager = FileManager.default
////
////        guard let applicationSupportURL =
////            fileManager.urls(
////                for: .applicationSupportDirectory,
////                in: .userDomainMask
////            ).first
////        else {
////            return nil
////        }
////
////        let videosDirectory = applicationSupportURL
////            .appendingPathComponent(
////                "Videos",
////                isDirectory: true
////            )
////
////        let videoURL = videosDirectory
////            .appendingPathComponent(fileName)
////
////        guard fileManager.fileExists(
////            atPath: videoURL.path
////        ) else {
////            print(
////                "Файл видео отсутствует:",
////                videoURL.path
////            )
////            return nil
////        }
////
////        return videoURL
////    }
////
////
////
//////    func url(named name: String) -> URL? {
//////        let fileName = name as NSString
//////        let fileExtension = fileName.pathExtension
//////        let baseName = fileName.deletingPathExtension
//////
//////        // Видео, выбранное пользователем.
//////        if let directory = try? directoryURL() {
//////            let localURL = directory.appendingPathComponent(
//////                name
//////            )
//////
//////            if fileManager.fileExists(
//////                atPath: localURL.path
//////            ) {
//////                return localURL
//////            }
//////        }
//////
//////        // Видео из Bundle с расширением в имени.
//////        if !fileExtension.isEmpty {
//////            return Bundle.main.url(
//////                forResource: baseName,
//////                withExtension: fileExtension
//////            )
//////        }
//////
//////        // Тестовые reel_1 и reel_2.
//////        return Bundle.main.url(
//////            forResource: name,
//////            withExtension: "mp4"
//////        )
//////    }
////
////    private func directoryURL() throws -> URL {
////        let applicationSupportURL =
////            try fileManager.url(
////                for: .applicationSupportDirectory,
////                in: .userDomainMask,
////                appropriateFor: nil,
////                create: true
////            )
////
////        let videosURL =
////            applicationSupportURL.appendingPathComponent(
////                "VKAppVideos",
////                isDirectory: true
////            )
////
////        if !fileManager.fileExists(
////            atPath: videosURL.path
////        ) {
////            try fileManager.createDirectory(
////                at: videosURL,
////                withIntermediateDirectories: true
////            )
////        }
////
////        return videosURL
////    }
////}
////
