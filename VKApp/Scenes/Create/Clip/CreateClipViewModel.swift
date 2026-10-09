//
//  CreateClipViewModel.swift
//  VKApp
//
//  Created by Timur Zakirov on 06/10/26.
//

import Foundation


@MainActor
final class CreateClipViewModel {

    private let currentUserID: UUID
    private let repository: ReelRepository

    private(set) var selectedVideoName: String?

    var onVideoSelected: ((String) -> Void)?
    var onCreated: (() -> Void)?
    var onError: ((String) -> Void)?

    init(
        currentUserID: UUID,
        repository: ReelRepository
    ) {
        self.currentUserID = currentUserID
        self.repository = repository
    }

    func setSelectedVideoName(_ fileName: String) {
        selectedVideoName = fileName
        onVideoSelected?(fileName)
    }

    func createClip(caption: String) {
        guard let selectedVideoName else {
            onError?("Сначала выберите видео")
            return
        }

        do {
            try repository.createReel(
                authorID: currentUserID,
                videoName: selectedVideoName,
                caption: caption
            )

            onCreated?()
        } catch {
            onError?(
                (error as? LocalizedError)?.errorDescription
                ?? "Не удалось создать клип"
            )
        }
    }
}


//final class CreateClipViewModel {
//
//    private let currentUserID: UUID
//    private let repository: ReelRepository
//    private let videoStore: LocalVideoStore
//
//    private(set) var selectedVideoName: String?
//
//    var onVideoSelected: ((String) -> Void)?
//    var onCreated: (() -> Void)?
//    var onError: ((String) -> Void)?
//
//    init(
//        currentUserID: UUID,
//        repository: ReelRepository,
//        videoStore: LocalVideoStore = .shared
//    ) {
//        self.currentUserID = currentUserID
//        self.repository = repository
//        self.videoStore = videoStore
//    }
//
//    func saveSelectedVideo(from temporaryURL: URL) {
//        do {
//            selectedVideoName = try videoStore.saveVideo(
//                from: temporaryURL
//            )
//
//            if let selectedVideoName {
//                onVideoSelected?(selectedVideoName)
//            }
//        } catch {
//            onError?("Не удалось сохранить выбранное видео")
//        }
//    }
//
//    func createClip(caption: String) {
//        guard let selectedVideoName else {
//            onError?("Сначала выберите видео")
//            return
//        }
//
//        do {
//            try repository.createReel(
//                authorID: currentUserID,
//                videoName: selectedVideoName,
//                caption: caption
//            )
//
//            onCreated?()
//        } catch {
//            onError?(
//                (error as? LocalizedError)?.errorDescription
//                ?? "Не удалось создать клип"
//            )
//        }
//    }
//    
//    
//    
//    func saveSelectedVideo(
//        _ temporaryURL: URL
//    ) {
//        do {
//            let fileName = try videoStore.saveVideo(
//                from: temporaryURL
//            )
//
//            selectedVideoName = fileName
//
//            DispatchQueue.main.async { [weak self] in
//                self?.onVideoSelected?(fileName)
//            }
//        } catch {
//            DispatchQueue.main.async { [weak self] in
//                self?.onError?(
//                    "Не удалось сохранить видео: "
//                    + error.localizedDescription
//                )
//            }
//        }
//    }
//
//
//
//
//
//
//}

