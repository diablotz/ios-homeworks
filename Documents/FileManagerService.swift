//
//  FileManagerService.swift
//  Documents
//
//  Created by Timur Zakirov on 14/07/26.
//

import UIKit

final class FileManagerService{
    
    static let shared = FileManagerService()
    
    private init() {
        
    }
    
    private var documentsDirectory: URL? {
        FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first!
    }
    
    func saveImage(image: UIImage) {
        
        var index = 1
        var url: URL
        repeat {
            let fileName = String(format: "picture%03d.jpg", index)
            url = documentsDirectory!.appendingPathComponent(fileName)
            index += 1
        } while FileManager.default.fileExists(atPath: url.path)
        
        if let data = image.jpegData(compressionQuality: 0.9) {
            try? data.write(to: url)
        }
    }
    
    func loadImages() -> [URL] {
        let files = try? FileManager.default.contentsOfDirectory(
            at: documentsDirectory!,
            includingPropertiesForKeys: nil
            
        )
        return files ?? []
    }
    
    func deleteImage(url: URL) {
        try? FileManager.default.removeItem(at: url)
    }
    
}
