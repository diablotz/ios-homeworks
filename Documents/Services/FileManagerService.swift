//
//  FileManagerService.swift
//  Documents
//
//  Created by Timur Zakirov on 14/07/26.
//
import UIKit

final class FileManagerService {

    static let shared = FileManagerService()

    private init() {}

    private var documentsDirectory: URL {
        FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first!
    }

    // MARK: - Save image

    func saveImage(image: UIImage, fileName: String?) {

        let name: String

        if let fileName,
           !fileName.trimmingCharacters(in: .whitespaces).isEmpty {

            name = fileName + ".jpg"

        } else {

            name = nextPictureName()

        }

        let url = documentsDirectory.appendingPathComponent(name)

        guard let data = image.jpegData(compressionQuality: 0.9) else {
            return
        }

        do {
            try data.write(to: url)
        } catch {
            print(error)
        }
    }

    // MARK: - Load images

    func loadImages() -> [URL] {

        guard let files = try? FileManager.default.contentsOfDirectory(
            at: documentsDirectory,
            includingPropertiesForKeys: nil
        ) else {
            return []
        }

        return files.sorted {
            $0.lastPathComponent < $1.lastPathComponent
        }
    }

    // MARK: - Delete image

    func deleteImage(url: URL) {

        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            print(error)
        }
    }

    // MARK: - Automatic filename

    private func nextPictureName() -> String {

        var index = 1

        while true {

            let name = String(format: "picture%03d.jpg", index)

            let url = documentsDirectory.appendingPathComponent(name)

            if !FileManager.default.fileExists(atPath: url.path) {
                return name
            }

            index += 1
        }
    }
}
