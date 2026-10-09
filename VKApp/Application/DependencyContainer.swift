//
//  DependencyContainer.swift
//  VKApp
//
//  Created by Timur Zakirov on 14/09/26.
//


import CoreData

final class DependencyContainer {

    let persistenceController: PersistenceController
    let sessionStore: SessionStore
    let seedDataService: SeedDataService

    lazy var authenticationRepository:
        AuthenticationRepository = {
            CoreDataAuthenticationRepository(
                context: persistenceController.viewContext,
                sessionStore: sessionStore
            )
        }()

    lazy var feedRepository: FeedRepository = {
        CoreDataFeedRepository(
            context: persistenceController.viewContext,
            persistenceController: persistenceController
        )
    }()

    lazy var userRepository: UserRepository = {
        CoreDataUserRepository(
            context: persistenceController.viewContext
        )
    }()

    lazy var photoRepository: PhotoRepository = {
        CoreDataPhotoRepository(
            context: persistenceController.viewContext
        )
    }()

    lazy var notificationRepository:
        NotificationRepository = {
            CoreDataNotificationRepository(
                context: persistenceController.viewContext
            )
        }()

    lazy var messengerRepository:
        MessengerRepository = {
            CoreDataMessengerRepository(
                context: persistenceController.viewContext
            )
        }()

    lazy var reelRepository: ReelRepository = {
        CoreDataReelRepository(
            context: persistenceController.viewContext
        )
    }()

    init(
        persistenceController: PersistenceController = .shared,
        sessionStore: SessionStore = .shared
    ) {
        self.persistenceController =
            persistenceController

        self.sessionStore = sessionStore

        self.seedDataService = SeedDataService(
            persistenceController: persistenceController
        )
    }

    var viewContext: NSManagedObjectContext {
        persistenceController.viewContext
    }
}


//import CoreData
//
//final class DependencyContainer {
//
//    let persistenceController: PersistenceController
//    let seedDataService: SeedDataService
//    
//    let sessionStore: SessionStore
//
//    lazy var authenticationRepository:
//        AuthenticationRepository = {
//            CoreDataAuthenticationRepository(
//                context: persistenceController.viewContext,
//                sessionStore: sessionStore
//            )
//        }()
//
//    lazy var feedRepository: FeedRepository = {
//        CoreDataFeedRepository(
//            context: persistenceController.viewContext
//        )
//    }()
//
//
//    lazy var userRepository: UserRepository = {
//        CoreDataUserRepository(
//            context: persistenceController.viewContext
//        )
//    }()
//    
//    
//    lazy var photoRepository: PhotoRepository = {
//       CoreDataPhotoRepository(
//        context: persistenceController.viewContext
//       )
//    }()
//    
//    lazy var messengerRepository: MessengerRepository = {
//       CoreDataMessengerRepository(
//        context: persistenceController.viewContext
//       )
//    }()
//    
//    
//    lazy var notificationRepository: NotificationRepository = {
//       CoreDataNotificationRepository(
//        context: persistenceController.viewContext
//       )
//    }()
//    
//    lazy var reelRepository: ReelRepository = {
//        CoreDataReelRepository(
//            context: persistenceController.viewContext
//        )
//    }()
//    
//    
//    init(
//        persistenceController: PersistenceController = .shared,
//        sessionStore: SessionStore
//    ) {
//        self.persistenceController = persistenceController
//        self.seedDataService = SeedDataService(
//            persistenceController: persistenceController
//        )
//        self.sessionStore = sessionStore
//    }
//
//    var viewContext: NSManagedObjectContext {
//        persistenceController.viewContext
//    }
//}



//import Foundation
//import CoreData
//
//final class DependencyContainer {
//
//    let persistenceController: PersistenceController
//
//    init(
//        persistenceController: PersistenceController = .shared
//    ) {
//        self.persistenceController = persistenceController
//    }
//
//    var viewContext: NSManagedObjectContext {
//        persistenceController.viewContext
//    }
//}

