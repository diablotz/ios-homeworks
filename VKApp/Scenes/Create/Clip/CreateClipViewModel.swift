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
            onError?(L10n.string("error.select_clip"))
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
                ?? L10n.string("error.create_clip")
            )
        }
    }
}




