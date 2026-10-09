//
//  SeedDataService.swift
//  VKApp
//
//  Created by Timur Zakirov on 22/09/26.
//
import CoreData
import Foundation

private enum SeedDataError: LocalizedError {
    case userNotFound

    var errorDescription: String? {
        switch self {
        case .userNotFound:
            return "Не найден пользователь для Reels"
        }
    }
}


final class SeedDataService {

    private let persistenceController: PersistenceController

    init(persistenceController: PersistenceController) {
        self.persistenceController = persistenceController
    }

    func seedIfNeeded() {
        persistenceController.performBackgroundTask { context in
            if try self.databaseIsEmpty(context: context) {
                let users = self.createUsers(context: context)

                let posts = self.createPosts(
                    users: users,
                    context: context
                )

                self.createStories(
                    users: users,
                    context: context
                )

                self.createPhotos(
                    users: users,
                    context: context
                )

                self.createNotifications(
                    users: users,
                    posts: posts,
                    context: context
                )

                self.createConversation(
                    users: users,
                    context: context
                )

                self.createReels(
                    users: users,
                    context: context
                )

                print("Все тестовые данные созданы")
            
            } else {
                try self.createStoriesIfNeeded(
                    context: context
                )

                try self.createReelsIfNeeded(
                    context: context
                )
            }


        }
    }


    

    private func databaseIsEmpty(
        context: NSManagedObjectContext
    ) throws -> Bool {
        let request = NSFetchRequest<UserEntity>(
            entityName: "UserEntity"
        )

        request.fetchLimit = 1

        return try context.count(for: request) == 0
    }
}


private extension SeedDataService {

    struct SeedUsers {
        let current: UserEntity
        let sergey: UserEntity
        let dmitry: UserEntity
        let alexander: UserEntity
    }

    func createUsers(
        context: NSManagedObjectContext
    ) -> SeedUsers {
        let currentUser = makeUser(
            id: UUID(uuidString: "10000000-0000-0000-0000-000000000001")!,
            phone: "+998901234567",
            firstName: "Тимур",
            lastName: "Закиров",
            avatarName: "avatar_current",
            statusText: "Изучаю разработку под iOS",
            isCurrentUser: true,
            isFriend: false,
            isOnline: true,
            context: context
        )

        let sergey = makeUser(
            id: UUID(uuidString: "10000000-0000-0000-0000-000000000002")!,
            phone: nil,
            firstName: "Сергей",
            lastName: "Лукьяненко",
            avatarName: "avatar_sergey",
            statusText: "Писатель",
            isCurrentUser: false,
            isFriend: true,
            isOnline: true,
            context: context
        )

        let dmitry = makeUser(
            id: UUID(uuidString: "10000000-0000-0000-0000-000000000003")!,
            phone: nil,
            firstName: "Дмитрий",
            lastName: "Пучков",
            avatarName: "avatar_dmitry",
            statusText: "Новые публикации каждый день",
            isCurrentUser: false,
            isFriend: true,
            isOnline: false,
            context: context
        )

        let alexander = makeUser(
            id: UUID(uuidString: "10000000-0000-0000-0000-000000000004")!,
            phone: nil,
            firstName: "Александр",
            lastName: "Конторович",
            avatarName: "avatar_alexander",
            statusText: "На связи",
            isCurrentUser: false,
            isFriend: true,
            isOnline: true,
            context: context
        )

        return SeedUsers(
            current: currentUser,
            sergey: sergey,
            dmitry: dmitry,
            alexander: alexander
        )
    }

    func makeUser(
        id: UUID,
        phone: String?,
        firstName: String,
        lastName: String,
        avatarName: String?,
        statusText: String?,
        isCurrentUser: Bool,
        isFriend: Bool,
        isOnline: Bool,
        context: NSManagedObjectContext
    ) -> UserEntity {
        let user = UserEntity(context: context)

        user.id = id
        user.phone = phone
        user.firstName = firstName
        user.lastName = lastName
        user.avatarName = avatarName
        user.statusText = statusText
        user.isCurrentUser = isCurrentUser
        user.isFriend = isFriend
        user.isOnline = isOnline

        return user
    }
}



private extension SeedDataService {

    struct SeedPosts {
        let first: PostEntity
        let second: PostEntity
    }

    func createPosts(
        users: SeedUsers,
        context: NSManagedObjectContext
    ) -> SeedPosts {
        let firstPost = makePost(
            id: UUID(uuidString: "20000000-0000-0000-0000-000000000001")!,
            author: users.sergey,
            text: """
            Сегодня хочу поделиться новой фотографией. \
            Это краткое описание публикации, которое позже \
            можно будет раскрыть кнопкой «Читать далее».
            """,
            imageName: "post_sergey_1",
            likesCount: 2_000,
            viewsCount: 14_800,
            commentsCount: 74,
            sharesCount: 120,
            hoursAgo: 4,
            context: context
        )

        let secondPost = makePost(
            id: UUID(uuidString: "20000000-0000-0000-0000-000000000002")!,
            author: users.dmitry,
            text: """
            Новый видеоматериал уже доступен. В публикации \
            рассказывается о последних событиях и новостях.
            """,
            imageName: "post_dmitry_1",
            likesCount: 82,
            viewsCount: 3_700,
            commentsCount: 21,
            sharesCount: 7,
            hoursAgo: 8,
            context: context
        )
        print(
            "Первый пост imageName:",
            firstPost.imageName ?? "nil"
        )

        print(
            "Второй пост imageName:",
            secondPost.imageName ?? "nil"
        )



        return SeedPosts(
            first: firstPost,
            second: secondPost
        )
    }

    func makePost(
        id: UUID,
        author: UserEntity,
        text: String,
        imageName: String?,
        likesCount: Int64,
        viewsCount: Int64,
        commentsCount: Int64,
        sharesCount: Int64,
        hoursAgo: TimeInterval,
        context: NSManagedObjectContext
    ) -> PostEntity {
        let post = PostEntity(context: context)

        post.id = id
        post.author = author
        post.text = text
        post.imageName = imageName
        post.videoName = nil
        post.mediaType = PostMediaType.image.rawValue
        post.likesCount = likesCount
        post.viewsCount = viewsCount
        post.commentsCount = commentsCount
        post.sharesCount = sharesCount
        post.isLiked = false
        post.createdAt = Date().addingTimeInterval(
            -hoursAgo * 3_600
        )

        return post
    }
}


// Stories
private extension SeedDataService {

    func createStories(
        users: SeedUsers,
        context: NSManagedObjectContext
    ) {
        makeStory(
            author: users.current,
            imageName: "story_current",
            hoursAgo: 1,
            context: context
        )

        makeStory(
            author: users.sergey,
            imageName: "story_sergey",
            hoursAgo: 2,
            context: context
        )

        makeStory(
            author: users.dmitry,
            imageName: "story_dmitry",
            hoursAgo: 3,
            context: context
        )

        makeStory(
            author: users.alexander,
            imageName: "story_alexander",
            hoursAgo: 5,
            context: context
        )
    }

    func makeStory(
        author: UserEntity,
        imageName: String,
        hoursAgo: TimeInterval,
        context: NSManagedObjectContext
    ) {
        let story = StoryEntity(context: context)

        story.id = UUID()
        story.author = author
        story.imageName = imageName
        story.createdAt = Date().addingTimeInterval(
            -hoursAgo * 3_600
        )
        story.isViewed = false
    }
}


// Photos
private extension SeedDataService {

    func createPhotos(
        users: SeedUsers,
        context: NSManagedObjectContext
    ) {
        for index in 1...6 {
            let photo = PhotoEntity(context: context)

            photo.id = UUID()
            photo.author = users.sergey
            photo.imageName = "photo_sergey_\(index)"
            photo.createdAt = Date().addingTimeInterval(
                -Double(index) * 86_400
            )
            photo.likesCount = Int64(index * 12)
            photo.isLiked = false
        }
    }
}


// Notifications
private extension SeedDataService {

    func createNotifications(
        users: SeedUsers,
        posts: SeedPosts,
        context: NSManagedObjectContext
    ) {
        let likeNotification = NotificationEntity(
            context: context
        )

        likeNotification.id = UUID()
        likeNotification.notificationKind = .like
        likeNotification.message =
            "\(users.sergey.displayName) оценил вашу запись"
        likeNotification.createdAt =
            Date().addingTimeInterval(-1_800)
        likeNotification.isRead = false
        likeNotification.sender = users.sergey
        likeNotification.post = posts.first

        let friendNotification = NotificationEntity(
            context: context
        )

        friendNotification.id = UUID()
        friendNotification.notificationKind = .friendRequest
        friendNotification.message =
            "\(users.alexander.displayName) хочет добавить вас в друзья"
        friendNotification.createdAt =
            Date().addingTimeInterval(-7_200)
        friendNotification.isRead = false
        friendNotification.sender = users.alexander
        friendNotification.post = nil
    }
}



private extension SeedDataService {

    func createConversation(
        users: SeedUsers,
        context: NSManagedObjectContext
    ) {
        let conversation = ConversationEntity(
            context: context
        )

        conversation.id = UUID(
            uuidString: "30000000-0000-0000-0000-000000000001"
        )!
        conversation.title = users.sergey.displayName
        conversation.avatarName = users.sergey.avatarName
        conversation.updatedAt = Date()
        conversation.unreadCount = 1
        conversation.isGroup = false

        conversation.participants = NSSet(
            array: [
                users.current,
                users.sergey
            ]
        )

        makeMessage(
            text: "Здравствуйте!",
            sender: users.sergey,
            conversation: conversation,
            minutesAgo: 15,
            isRead: true,
            context: context
        )

        makeMessage(
            text: "Добрый день! Как ваши дела?",
            sender: users.current,
            conversation: conversation,
            minutesAgo: 10,
            isRead: true,
            context: context
        )

        makeMessage(
            text: "Спасибо, всё отлично.",
            sender: users.sergey,
            conversation: conversation,
            minutesAgo: 5,
            isRead: false,
            context: context
        )
    }

    func makeMessage(
        text: String,
        sender: UserEntity,
        conversation: ConversationEntity,
        minutesAgo: TimeInterval,
        isRead: Bool,
        context: NSManagedObjectContext
    ) {
        let message = MessageEntity(context: context)

        message.id = UUID()
        message.text = text
        message.sender = sender
        message.conversation = conversation
        message.sentAt = Date().addingTimeInterval(
            -minutesAgo * 60
        )
        message.isRead = isRead
    }
}


// Reels

private extension SeedDataService {

    func createReels(
        users: SeedUsers,
        context: NSManagedObjectContext
    ) {
        makeReel(
            id: UUID(
                uuidString:
                    "40000000-0000-0000-0000-000000000001"
            )!,
            author: users.sergey,
            videoName: "reel_1",
            captionText:
                "Неожиданная встреча",
            likesCount: 15_600,
            commentsCount: 234,
            sharesCount: 2_900,
            context: context
        )

        makeReel(
            id: UUID(
                uuidString:
                    "40000000-0000-0000-0000-000000000002"
            )!,
            author: users.dmitry,
            videoName: "reel_2",
            captionText:
                "Чудесные горы",
            likesCount: 4_200,
            commentsCount: 87,
            sharesCount: 310,
            context: context
        )
    }

    func makeReel(
        id: UUID,
        author: UserEntity,
        videoName: String,
        captionText: String,
        likesCount: Int64,
        commentsCount: Int64,
        sharesCount: Int64,
        context: NSManagedObjectContext
    ) {
        let reel = ReelEntity(context: context)

        reel.id = id
        reel.author = author
        reel.videoName = videoName
        reel.captionText = captionText
        reel.createdAt = Date()
        reel.likesCount = likesCount
        reel.commentsCount = commentsCount
        reel.sharesCount = sharesCount
        reel.isLiked = false
        reel.isSaved = false
    }
}

private extension SeedDataService {

    func createReelsIfNeeded(
        context: NSManagedObjectContext
    ) throws {
        let reelRequest = NSFetchRequest<ReelEntity>(
            entityName: "ReelEntity"
        )

        reelRequest.fetchLimit = 1

        guard try context.count(for: reelRequest) == 0 else {
            print("Reels уже находятся в Core Data")
            return
        }

        let sergey = try findSeedUser(
            id: UUID(
                uuidString:
                    "10000000-0000-0000-0000-000000000002"
            )!,
            context: context
        )

        let dmitry = try findSeedUser(
            id: UUID(
                uuidString:
                    "10000000-0000-0000-0000-000000000003"
            )!,
            context: context
        )

        makeReel(
            id: UUID(
                uuidString:
                    "40000000-0000-0000-0000-000000000001"
            )!,
            author: sergey,
            videoName: "reel_1",
            captionText:
                "Интересный момент из нового видео",
            likesCount: 15_600,
            commentsCount: 234,
            sharesCount: 2_900,
            context: context
        )

        makeReel(
            id: UUID(
                uuidString:
                    "40000000-0000-0000-0000-000000000002"
            )!,
            author: dmitry,
            videoName: "reel_2",
            captionText:
                "Короткий клип для нашей ленты",
            likesCount: 4_200,
            commentsCount: 87,
            sharesCount: 310,
            context: context
        )

        print("Reels добавлены в Core Data")
    }

    func findSeedUser(
        id: UUID,
        context: NSManagedObjectContext
    ) throws -> UserEntity {
        let request = NSFetchRequest<UserEntity>(
            entityName: "UserEntity"
        )

        request.fetchLimit = 1
        request.predicate = NSPredicate(
            format: "id == %@",
            id as NSUUID
        )

        guard let user = try context.fetch(request).first else {
            throw SeedDataError.userNotFound
        }

        return user
    }
    
    
    func createStoriesIfNeeded(
            context: NSManagedObjectContext
        ) throws {
            let request = NSFetchRequest<StoryEntity>(
                entityName: "StoryEntity"
            )

            request.fetchLimit = 1

            guard try context.count(for: request) == 0 else {
                print("Stories уже находятся в Core Data")
                return
            }

            let currentUser = try findSeedUser(
                id: UUID(
                    uuidString:
                        "10000000-0000-0000-0000-000000000001"
                )!,
                context: context
            )

            let sergey = try findSeedUser(
                id: UUID(
                    uuidString:
                        "10000000-0000-0000-0000-000000000002"
                )!,
                context: context
            )

            let dmitry = try findSeedUser(
                id: UUID(
                    uuidString:
                        "10000000-0000-0000-0000-000000000003"
                )!,
                context: context
            )

            let alexander = try findSeedUser(
                id: UUID(
                    uuidString:
                        "10000000-0000-0000-0000-000000000004"
                )!,
                context: context
            )

            makeStory(
                author: currentUser,
                imageName: "story_current",
                hoursAgo: 1,
                context: context
            )

            makeStory(
                author: sergey,
                imageName: "story_sergey",
                hoursAgo: 2,
                context: context
            )

            makeStory(
                author: dmitry,
                imageName: "story_dmitry",
                hoursAgo: 3,
                context: context
            )

            makeStory(
                author: alexander,
                imageName: "story_alexander",
                hoursAgo: 4,
                context: context
            )

            print("Stories добавлены в Core Data")
        }

}





//import CoreData
//
//final class SeedDataService {
//
//    private let persistenceController: PersistenceController
//
//    init(persistenceController: PersistenceController) {
//        self.persistenceController = persistenceController
//    }
//
//    func createLikeNotification(
//        sender: UserEntity,
//        post: PostEntity,
//        context: NSManagedObjectContext
//    ) {
//        let notification = NotificationEntity(context: context)
//
//        notification.id = UUID()
//        //notification.kind = NotificationKind.like.rawValue
//        notification.message = "\(sender.displayName) оценил вашу запись"
//        notification.createAt = Date()
//        notification.isRead = false
//        notification.sender = sender
//        notification.post = post
//        notification.notificationKind = .like
//    }
//}


