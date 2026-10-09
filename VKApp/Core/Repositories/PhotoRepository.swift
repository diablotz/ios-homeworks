//
//  PhotoRepository.swift
//  VKApp
//
//  Created by Timur Zakirov on 01/10/26.
//

import Foundation

protocol PhotoRepository {
    func fetchPhotos() throws -> [PhotoItem]
    func toggleLike(photoID: UUID) throws
}
