//
//  ReelRepository.swift
//  VKApp
//
//  Created by Timur Zakirov on 03/10/26.
//

import Foundation

protocol ReelRepository {
    func fetchReels() throws -> [ReelItem]

    func createReel(
        authorID: UUID,
        videoName: String,
        caption: String
    ) throws

    func toggleLike(id: UUID) throws
    func toggleSaved(id: UUID) throws
}

