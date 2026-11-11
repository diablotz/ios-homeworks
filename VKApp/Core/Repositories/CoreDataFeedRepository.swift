//
//  CoreDataFeedRepository.swift
//  VKApp
//
//  Created by Timur Zakirov on 01/10/26.
//


import Foundation
import CoreData

final class CoreDataFeedRepository: FeedRepository {
    
    

    private let context: NSManagedObjectContext
    private let persistenceController: PersistenceController

    init(
        context: NSManagedObjectContext,
        persistenceController: PersistenceController
    ) {
        self.context = context
        self.persistenceController = persistenceController
    }
    
    func fetchStories() throws -> [FeedStory] {
        let request = NSFetchRequest<StoryEntity>(
            entityName: "StoryEntity"
        )

        request.sortDescriptors = [
            NSSortDescriptor(
                key: "createdAt",
                ascending: false
            )
        ]

        do {
            let entities = try context.fetch(request)

            print(
                "Количество StoryEntity в Core Data:",
                entities.count
            )

            let stories = entities.compactMap {
                story -> FeedStory? in

                guard let id = story.id else {
                    print("Story пропущена: отсутствует id")
                    return nil
                }

                guard let author = story.author else {
                    print("Story пропущена: отсутствует author")
                    return nil
                }

                guard let imageName = story.imageName else {
                    print("Story пропущена: отсутствует imageName")
                    return nil
                }

                return FeedStory(
                    id: id,
                    authorName: author.displayName,
                    avatarName: author.avatarName,
                    imageName: imageName,
                    isViewed: story.isViewed
                )
            }

            print(
                "Количество подготовленных Stories:",
                stories.count
            )

            return stories
        } catch {
            print("Ошибка загрузки Stories:", error)

            throw FeedRepositoryError.fetchFailed(error)
        }
    }



//    func fetchStories() throws -> [FeedStory] {
//        let request = NSFetchRequest<StoryEntity>(
//            entityName: "StoryEntity"
//        )
//
//        request.sortDescriptors = [
//            NSSortDescriptor(
//                key: "createdAt",
//                ascending: false
//            )
//        ]
//
//        do {
//            return try context.fetch(request).compactMap {
//                story in
//
//                guard
//                    let id = story.id,
//                    let imageName = story.imageName,
//                    let author = story.author,
//                    let authorID = author.id
//                else {
//                    return nil
//                }
//
//                _ = authorID
//
//                return FeedStory(
//                    id: id,
//                    authorName: author.displayName,
//                    avatarName: author.avatarName,
//                    imageName: imageName,
//                    isViewed: story.isViewed
//                )
//            }
//        } catch {
//            throw FeedRepositoryError.fetchFailed(error)
//        }
//    }
    
    func fetchPosts(authorID: UUID) throws -> [FeedPost] {
        let request = NSFetchRequest<PostEntity>(
            entityName: "PostEntity"
        )

        request.predicate = NSPredicate(
            format: "author.id == %@",
            authorID as NSUUID
        )

        request.sortDescriptors = [
            NSSortDescriptor(
                key: "createdAt",
                ascending: false
            )
        ]

        do {
            return try context.fetch(request).compactMap {
                makePost(from: $0)
            }
        } catch {
            throw FeedRepositoryError.fetchFailed(error)
        }
    }
    
    func fetchPosts() throws -> [FeedPost] {
        let request = NSFetchRequest<PostEntity>(
            entityName: "PostEntity"
        )

        request.sortDescriptors = [
            NSSortDescriptor(
                key: "createdAt",
                ascending: false
            )
        ]

        do {
            return try context.fetch(request).compactMap {
                makePost(from: $0)
            }
        } catch {
            throw FeedRepositoryError.fetchFailed(error)
        }
    }



//    func fetchPosts() throws -> [FeedPost] {
//        let request = NSFetchRequest<PostEntity>(
//            entityName: "PostEntity"
//        )
//
//        request.sortDescriptors = [
//            NSSortDescriptor(
//                key: "createdAt",
//                ascending: false
//            )
//        ]
//
//        do {
//            return try context.fetch(request).compactMap {
//                post in
//
//                guard
//                    let id = post.id,
//                    let author = post.author,
//                    let authorID = author.id
//                else {
//                    return nil
//                }
//
//                return FeedPost(
//                    id: id,
//                    authorID: authorID,
//                    authorName: author.displayName,
//                    authorAvatarName: author.avatarName,
//                    text: post.text ?? "",
//                    imageName: post.imageName,
//                    createdAt: post.createdAt ?? Date(),
//                    likesCount: post.likesCount,
//                    viewsCount: post.viewsCount,
//                    commentsCount: post.commentsCount,
//                    sharesCount: post.sharesCount,
//                    isLiked: post.isLiked
//                )
//            }
//        } catch {
//            throw FeedRepositoryError.fetchFailed(error)
//        }
//    }

    func toggleLike(postID: UUID) throws {
        let request = NSFetchRequest<PostEntity>(
            entityName: "PostEntity"
        )

        request.fetchLimit = 1
        request.predicate = NSPredicate(
            format: "id == %@",
            postID as NSUUID
        )

        do {
            guard let post = try context.fetch(request).first else {
                throw FeedRepositoryError.postNotFound
            }

            post.isLiked.toggle()

            if post.isLiked {
                post.likesCount += 1
            } else {
                post.likesCount = max(0, post.likesCount - 1)
            }

            try context.save()
        } catch let error as FeedRepositoryError {
            throw error
        } catch {
            context.rollback()
            throw FeedRepositoryError.saveFailed(error)
        }
    }
    
    
    
    private func makePost(
        from post: PostEntity
    ) -> FeedPost? {
        guard
            let id = post.id,
            let author = post.author,
            let authorID = author.id
        else {
            return nil
        }

//        let mediaType: PostMediaType
//
//        if let rawValue = post.mediaType,
//           let savedType = PostMediaType(rawValue: rawValue) {
//            mediaType = savedType
//        } else if post.videoName != nil {
//            mediaType = .video
//        } else if post.imageName != nil {
//            mediaType = .image
//        } else {
//            mediaType = .text
//        }

        return FeedPost(
            id: id,
            authorID: authorID,
            authorName: author.displayName,
            authorAvatarName: author.avatarName,
            text: post.text ?? "",
            imageName: post.imageName,
            videoName: post.videoName,
            //mediaType: makeMediaType(imageName: post.imageName, videoName: post.videoName, storedValue: post.mediaType),
            mediaType: makeMediaType(from: post),
            createdAt: post.createdAt ?? Date(),
            likesCount: Int(post.likesCount),
            commentsCount: Int(post.commentsCount),
            sharesCount: Int(post.sharesCount),
            viewsCount: Int(post.viewsCount),
            isLiked: post.isLiked,
            externalID: post.externalID,
            externalTitle: post.externalTitle,
            externalSubtitle: post.externalSubtitle,
            externalImageURL: post.externalImageURL,
            externalMediaURL: post.externalMediaURL,
            externalStoreURL: post.externalStoreURL
            


        )
    }


    
    func createPost(
        authorID: UUID,
        text: String,
        imageName: String?
    ) throws {
        let trimmedText = text.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !trimmedText.isEmpty else {
            throw FeedRepositoryError.emptyPost
        }

        let request = NSFetchRequest<UserEntity>(
            entityName: "UserEntity"
        )

        request.fetchLimit = 1
        request.predicate = NSPredicate(
            format: "id == %@",
            authorID as NSUUID
        )

        do {
            guard let author = try context.fetch(request).first else {
                throw FeedRepositoryError.authorNotFound
            }

            let post = PostEntity(context: context)
            post.id = UUID()
            post.author = author
            post.text = trimmedText
            post.imageName = imageName
            post.createdAt = Date()
            post.likesCount = 0
            post.viewsCount = 0
            post.commentsCount = 0
            post.sharesCount = 0
            post.isLiked = false
            post.videoName = nil
            post.mediaType = imageName == nil ? PostMediaType.text.rawValue : PostMediaType.image.rawValue
            

            try context.save()
        } catch let error as FeedRepositoryError {
            throw error
        } catch {
            context.rollback()
            throw FeedRepositoryError.saveFailed(error)
        }
    }
    
    
    func createVideoPost(
        authorID: UUID,
        text: String,
        videoName: String
    ) throws {
        let context = persistenceController
            .container
            .viewContext

        guard LocalVideoStore.shared.url(
            for: videoName
        ) != nil else {
            throw FeedRepositoryError.videoNotFound
        }

        let userRequest = UserEntity.fetchRequest()

        userRequest.fetchLimit = 1
        userRequest.predicate = NSPredicate(
            format: "id == %@",
            authorID as CVarArg
        )

        guard let author = try context.fetch(userRequest).first else {
            throw FeedRepositoryError.authorNotFound
        }

        let post = PostEntity(context: context)

        post.id = UUID()
        post.text = text
        post.createdAt = Date()

        //post.imageName = nil
        post.videoName = videoName
        post.mediaType = PostMediaType.video.rawValue

        post.likesCount = 0
        post.commentsCount = 0
        post.sharesCount = 0
        post.viewsCount = 0
        post.isLiked = false

        // Связываем публикацию с пользователем
        post.author = author

        try context.save()

        print("Видеопост сохранён:")
        print("Автор:", author.displayName)
        print("videoName:", post.videoName ?? "nil")
        print("mediaType:", post.mediaType ?? "nil")
    }






    
    
    func createStory(
        authorID: UUID,
        imageName: String
    ) throws {
        let request = NSFetchRequest<UserEntity>(
            entityName: "UserEntity"
        )

        request.fetchLimit = 1
        request.predicate = NSPredicate(
            format: "id == %@",
            authorID as NSUUID
        )

        do {
            guard let author = try context.fetch(request).first else {
                throw FeedRepositoryError.authorNotFound
            }

            let story = StoryEntity(context: context)
            story.id = UUID()
            story.author = author
            story.imageName = imageName
            story.createdAt = Date()
            story.isViewed = false

            try context.save()
        } catch let error as FeedRepositoryError {
            throw error
        } catch {
            context.rollback()
            throw FeedRepositoryError.saveFailed(error)
        }
    }
    
    
    func createMoviePost(
        authorID: UUID,
        text: String,
        movie: Movie
    ) throws {
        let context = persistenceController
            .container
            .viewContext

        let author = try findUser(
            id: authorID,
            context: context
        )

        let post = PostEntity(context: context)

        post.id = UUID()
        post.author = author
        post.text = text.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
        post.createdAt = Date()

        post.mediaType = PostMediaType.movie.rawValue

        post.imageName = nil
        post.videoName = nil

        post.externalID = String(movie.id)
        post.externalTitle = movie.name
        post.externalSubtitle = makeMovieSubtitle(
            movie
        )
        post.externalImageURL = movie.image?.original
            ?? movie.image?.medium
        post.externalMediaURL = nil
        post.externalStoreURL = movie.url

        post.likesCount = 0
        post.commentsCount = 0
        post.sharesCount = 0
        post.viewsCount = 0
        post.isLiked = false

        print("Пост с фильмом сохранён:")
        print("Название:", movie.name)
        print(
            "Постер:",
            post.externalImageURL ?? "отсутствует"
        )
        
        try context.save()

        
    }
    
//    func createMusicPost(
//        authorID: UUID,
//        text: String,
//        track: MusicTrack
//    ) throws {
//        let context = persistenceController
//            .container
//            .viewContext
//
//        let author = try findUser(
//            id: authorID,
//            context: context
//        )
//
//        let post = PostEntity(
//            context: context
//        )
//
//        post.id = UUID()
//        post.author = author
//        post.text = text.trimmingCharacters(
//            in: .whitespacesAndNewlines
//        )
//        post.createdAt = Date()
//
//        post.mediaType =
//            PostMediaType.music.rawValue
//
//        post.imageName = nil
//        post.videoName = nil
//
//        post.externalID = track.id
//        post.externalTitle = track.title
//        post.externalSubtitle =
//            track.artistName
//        post.externalImageURL =
//            track.artworkURL
//        post.externalMediaURL =
//            track.streamURL
//        post.externalStoreURL =
//            track.storeURL
//
//        post.likesCount = 0
//        post.commentsCount = 0
//        post.sharesCount = 0
//        post.viewsCount = 0
//        post.isLiked = false
//
//        try context.save()
//
////        NotificationCenter.default.post(
////            name: .feedDidChange,
////            object: nil
////        )
//    }

    
    
    func createMusicPost(
        authorID: UUID,
        text: String,
        track: MusicTrack
    ) throws {
        guard let previewURL = track.previewUrl,
              !previewURL.isEmpty
        else {
            throw FeedRepositoryError.invalidExternalMedia
        }

        let context = persistenceController
            .container
            .viewContext

        let author = try findUser(
            id: authorID,
            context: context
        )

        let post = PostEntity(context: context)

        post.id = UUID()
        post.author = author
        post.text = text.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
        post.createdAt = Date()

        post.mediaType = PostMediaType.music.rawValue

        post.imageName = nil
        post.videoName = nil

        post.externalID = String(track.trackId)
        post.externalTitle = track.trackName
        post.externalSubtitle = makeMusicSubtitle(
            track
        )
        post.externalImageURL = makeLargeArtworkURL(
            from: track.artworkUrl100 ?? ""
        )
        post.externalMediaURL = previewURL
        post.externalStoreURL = track.trackViewUrl

        post.likesCount = 0
        post.commentsCount = 0
        post.sharesCount = 0
        post.viewsCount = 0
        post.isLiked = false

        print("Пост с музыкой сохранён:")
        print("Трек:", track.trackName)
        print("Исполнитель:", track.artistName)
        print("Preview URL:", previewURL)
        
        try context.save()

        
    }





    func markStoryAsViewed(id: UUID) throws {
        let request = NSFetchRequest<StoryEntity>(
            entityName: "StoryEntity"
        )

        request.fetchLimit = 1
        request.predicate = NSPredicate(
            format: "id == %@",
            id as NSUUID
        )

        do {
            guard let story = try context.fetch(request).first else {
                return
            }

            guard !story.isViewed else {
                return
            }

            story.isViewed = true
            try context.save()
        } catch {
            context.rollback()
            throw FeedRepositoryError.saveFailed(error)
        }
    }
    
//    private func makeMediaType(
//        imageName: String?,
//        videoName: String?,
//        storedValue: String?
//    ) -> PostMediaType {
//        /*
//         Реальное наличие файла важнее старого значения mediaType.
//         */
//        if videoName != nil {
//            return .video
//        }
//
//        if imageName != nil {
//            return .image
//        }
//
//        if let storedValue,
//           let mediaType = PostMediaType(
//               rawValue: storedValue
//           ) {
//            return mediaType
//        }
//
//        return .text
//    }
    
    private func makeMediaType(
        from entity: PostEntity
    ) -> PostMediaType {
        if let rawValue = entity.mediaType,
           let mediaType = PostMediaType(
               rawValue: rawValue
           ) {
            return mediaType
        }

        if normalizedValue(entity.videoName) != nil {
            return .video
        }

        if normalizedValue(entity.imageName) != nil {
            return .image
        }

        if normalizedValue(entity.externalMediaURL) != nil {
            return .music
        }

        if normalizedValue(entity.externalImageURL) != nil {
            return .movie
        }

        return .text
    }


    
    
    private func makeMovieSubtitle(
        _ movie: Movie
    ) -> String {
        var components: [String] = []

        if !movie.genres.isEmpty {
            components.append(
                movie.genres.joined(separator: ", ")
            )
        }

        if let rating = movie.rating.average {
            components.append(
                String(format: "★ %.1f", rating)
            )
        }

        if let premiered = movie.premiered,
           !premiered.isEmpty {
            components.append(premiered)
        }

        return components.joined(separator: " • ")
    }
    
    
    
    private func makeMusicSubtitle(
        _ track: MusicTrack
    ) -> String {
        var components = [track.artistName]

        if let collectionName = track.collectionName,
           !collectionName.isEmpty {
            components.append(collectionName)
        }

        return components.joined(separator: " • ")
    }

    
    private func makeLargeArtworkURL(
        from artworkURL: String
    ) -> String {
        artworkURL
            .replacingOccurrences(
                of: "100x100",
                with: "600x600"
            )
    }


    
    private func findUser(
        id: UUID,
        context: NSManagedObjectContext
    ) throws -> UserEntity {
        let request = UserEntity.fetchRequest()

        request.fetchLimit = 1
        request.predicate = NSPredicate(
            format: "id == %@",
            id as CVarArg
        )

        guard let user = try context.fetch(request).first else {
            throw FeedRepositoryError.userNotFound
        }

        return user
    }







    
//    private func makeMediaType(
//        from entity: PostEntity
//    ) -> PostMediaType {
//        if let rawValue = entity.mediaType,
//           let type = PostMediaType(rawValue: rawValue) {
//            return type
//        }
//
//        if let videoName = entity.videoName,
//           !videoName.isEmpty {
//            return .video
//        }
//
//        if let imageName = entity.imageName,
//           !imageName.isEmpty {
//            return .image
//        }
//
//        return .text
//    }
    
    
//    private func makeFeedPost(
//        from entity: PostEntity
//    ) -> FeedPost {
//        let imageName = normalizedMediaName(
//            entity.imageName
//        )
//
//        let videoName = normalizedMediaName(
//            entity.videoName
//        )
//
//        return FeedPost(
//            id: entity.id ?? UUID(),
//            authorID: entity.author?.id ?? UUID(),
//            authorName: entity.author?.displayName
//                ?? "Пользователь",
//            authorAvatarName: entity.author?.avatarName,
//            text: entity.text ?? "",
//            imageName: imageName,
//            videoName: videoName,
////            mediaType: makeMediaType(
////                imageName: imageName,
////                videoName: videoName,
////                storedValue: entity.mediaType
////            ),
//            mediaType: makeMediaType(from: entity),
//            createdAt: entity.createdAt ?? Date(),
//            likesCount: Int(entity.likesCount),
//            commentsCount: Int(entity.commentsCount),
//            sharesCount: Int(entity.sharesCount),
//            viewsCount: Int(entity.viewsCount),
//            isLiked: entity.isLiked,
//            externalID: entity.externalID,
//            externalTitle: entity.externalTitle,
//            externalSubtitle: entity.externalSubtitle,
//            externalImageURL: entity.externalImageURL,
//            externalMediaURL: entity.externalMediaURL,
//            externalStoreURL: entity.externalStoreURL
//            
//        )
//    }

    private func makeFeedPost(
        from entity: PostEntity
    ) -> FeedPost {
        let mediaType = makeMediaType(
            from: entity
        )

        let post = FeedPost(
            id: entity.id ?? UUID(),
            authorID: entity.author?.id ?? UUID(),
            authorName: entity.author?.displayName
                ?? "Пользователь",
            authorAvatarName: entity.author?.avatarName,
            text: entity.text ?? "",
            imageName: normalizedValue(
                entity.imageName
            ),
            videoName: normalizedValue(
                entity.videoName
            ),
            mediaType: mediaType,
            createdAt: entity.createdAt ?? Date(),
            likesCount: Int(entity.likesCount),
            commentsCount: Int(entity.commentsCount),
            sharesCount: Int(entity.sharesCount),
            viewsCount: Int(entity.viewsCount),
            isLiked: entity.isLiked,
            externalID: normalizedValue(
                entity.externalID
            ),
            externalTitle: normalizedValue(
                entity.externalTitle
            ),
            externalSubtitle: normalizedValue(
                entity.externalSubtitle
            ),
            externalImageURL: normalizedValue(
                entity.externalImageURL
            ),
            externalMediaURL: normalizedValue(
                entity.externalMediaURL
            ),
            externalStoreURL: normalizedValue(
                entity.externalStoreURL
            )
        )

        print("Получен пост из Core Data:")
        print("mediaType:", mediaType.rawValue)
        print("externalTitle:", post.externalTitle ?? "nil")
        print("externalImageURL:", post.externalImageURL ?? "nil")
        print("externalMediaURL:", post.externalMediaURL ?? "nil")

        return post
    }



//    private func makeFeedPost(
//        from entity: PostEntity
//    ) -> FeedPost {
//        FeedPost(
//            id: entity.id ?? UUID(),
//            authorID: entity.author?.id ?? UUID(),
//            authorName: entity.author?.displayName
//                ?? "Пользователь",
//            authorAvatarName: entity.author?.avatarName,
//            text: entity.text ?? "",
//            imageName: entity.imageName,
//            videoName: entity.videoName,
//            mediaType: makeMediaType(from: entity),
//            createdAt: entity.createdAt ?? Date(),
//            likesCount: Int(entity.likesCount),
//            commentsCount: Int(entity.commentsCount),
//            sharesCount: Int(entity.sharesCount),
//            viewsCount: Int(entity.viewsCount),
//            isLiked: entity.isLiked
//        )
//    }
    
    private func normalizedMediaName(
        _ value: String?
    ) -> String? {
        guard let value else {
            return nil
        }

        let trimmedValue = value.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        /*
         Исправляем старые значения:
         ""
         ''
         */
        if trimmedValue.isEmpty ||
            trimmedValue == "\"\"" ||
            trimmedValue == "''" {
            return nil
        }

        return trimmedValue
    }
    
    
    private func normalizedValue(
        _ value: String?
    ) -> String? {
        guard let value else {
            return nil
        }

        let result = value.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        return result.isEmpty ? nil : result
    }


    
//    private func normalizedValue(
//        _ value: String?
//    ) -> String? {
//        guard let value else {
//            return nil
//        }
//
//        let result = value.trimmingCharacters(
//            in: .whitespacesAndNewlines
//        )
//
//        return result.isEmpty ? nil : result
//    }







    
    
    




}
