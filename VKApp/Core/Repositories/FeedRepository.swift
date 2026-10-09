//
//  FeedRepositories.swift
//  VKApp
//
//  Created by Timur Zakirov on 01/10/26.
//

import Foundation

protocol FeedRepository {
    func fetchStories() throws -> [FeedStory]
    func fetchPosts() throws -> [FeedPost]
    func fetchPosts(authorID: UUID) throws -> [FeedPost]
    func toggleLike(postID: UUID) throws
    
      
    func createPost(
        authorID: UUID,
        text: String,
        imageName: String?
    ) throws
    
    func createVideoPost(
        authorID: UUID,
        text: String,
        videoName: String
    ) throws
    
    func createStory(
        authorID: UUID,
        imageName: String
    ) throws
    
    func markStoryAsViewed(
        id: UUID
    ) throws
}

