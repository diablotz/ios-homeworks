//
//  CreateVideoViewModel.swift
//  VKApp
//
//  Created by Timur Zakirov on 06/10/26.
//


import Foundation

@MainActor
final class CreateVideoViewModel {
    
    private let currentUserID: UUID
    private let repository: FeedRepository

    private(set) var selectedVideoName: String?

    var onVideoSelected: ((String) -> Void)?
    var onCreated: (() -> Void)?
    var onError: ((String) -> Void)?

    init(
        currentUserID: UUID,
        repository: FeedRepository
    ) {
        self.currentUserID = currentUserID
        self.repository = repository
    }

    func setSelectedVideoName(_ fileName: String) {
        selectedVideoName = fileName
        onVideoSelected?(fileName)
    }

    func createVideo(caption: String) {
        guard let selectedVideoName else {
            onError?("Сначала выберите видео")
            return
        }

        do {
            try repository.createVideoPost(
                authorID: currentUserID,
                text: caption,
                videoName: selectedVideoName
                
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

