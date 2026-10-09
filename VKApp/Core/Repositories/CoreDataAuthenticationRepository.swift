//
//  CoreDataAuthenticationRepository.swift
//  VKApp
//
//  Created by Timur Zakirov on 22/09/26.
//

import Foundation
import CoreData


final class CoreDataAuthenticationRepository:
    AuthenticationRepository {

    private let context: NSManagedObjectContext
    
    private let sessionStore: SessionStore

    init(
        context: NSManagedObjectContext,
        sessionStore: SessionStore
    ) {
        self.context = context
        self.sessionStore = sessionStore
    }

    func login(phone: String) throws -> AppUser {
        let normalizedPhone = normalize(phone)

        guard isValid(normalizedPhone) else {
            throw AuthenticationError.invalidPhone
        }

        guard let user = try findUser(
            normalizedPhone: normalizedPhone
        ) else {
            throw AuthenticationError.userNotFound
        }

        try setCurrentUser(user)
        
        
        guard let userID = user.id else {
            throw AuthenticationError.storageError(
                NSError(
                    domain: "VKApp.Authentication",
                    code: 1,
                    userInfo: [
                        NSLocalizedDescriptionKey:
                            "У пользователя отсутствует ID"
                    ]
                )
            )
        }

        sessionStore.save(userID: userID)

        return user.toModel()


        
//        sessionStore.save(userID: user.id ?? UUID())
//
//        return user.toModel()
    }

    func register(phone: String) throws -> AppUser {
        let normalizedPhone = normalize(phone)

        guard isValid(normalizedPhone) else {
            throw AuthenticationError.invalidPhone
        }

        if try findUser(normalizedPhone: normalizedPhone) != nil {
            throw AuthenticationError.phoneAlreadyRegistered
        }

        do {
            try resetCurrentUsers()

            let user = UserEntity(context: context)
            user.id = UUID()
            user.phone = normalizedPhone
            user.firstName = "Новый"
            user.lastName = "Пользователь"
            user.avatarName = nil
            user.statusText = "Здесь пока ничего нет"
            user.isCurrentUser = true
            user.isFriend = false
            user.isOnline = true

            try context.save()
            
            guard let userID = user.id else {
                throw AuthenticationError.storageError(
                    NSError(
                        domain: "VKApp.Authentication",
                        code: 2
                    )
                )
            }

            sessionStore.save(userID: userID)

            return user.toModel()
        } catch let error as AuthenticationError {
            throw error
        } catch {
            context.rollback()
            throw AuthenticationError.storageError(error)
        }
    }

    

    private func findUser(
        normalizedPhone: String
    ) throws -> UserEntity? {
        let request = NSFetchRequest<UserEntity>(
            entityName: "UserEntity"
        )

        request.predicate = NSPredicate(
            format: "phone != nil"
        )

        do {
            let users = try context.fetch(request)

            return users.first {
                normalize($0.phone ?? "") == normalizedPhone
            }
        } catch {
            throw AuthenticationError.storageError(error)
        }
    }

    private func setCurrentUser(
        _ selectedUser: UserEntity
    ) throws {
        do {
            try resetCurrentUsers()
            selectedUser.isCurrentUser = true
            try context.save()
        } catch {
            context.rollback()
            throw AuthenticationError.storageError(error)
        }
    }

    private func resetCurrentUsers() throws {
        let request = NSFetchRequest<UserEntity>(
            entityName: "UserEntity"
        )

        request.predicate = NSPredicate(
            format: "isCurrentUser == YES"
        )

        let currentUsers = try context.fetch(request)

        currentUsers.forEach {
            $0.isCurrentUser = false
        }
    }

    private func normalize(_ phone: String) -> String {
        phone.filter(\.isNumber)
    }

    private func isValid(_ phone: String) -> Bool {
        (10...15).contains(phone.count)
    }
    
    
    func currentUser() throws -> AppUser? {
        guard let userID = sessionStore.currentUserID else {
            return nil
        }

        let request = NSFetchRequest<UserEntity>(
            entityName: "UserEntity"
        )

        request.fetchLimit = 1
        request.predicate = NSPredicate(
            format: "id == %@",
            userID as NSUUID
        )

        do {
            guard let user = try context.fetch(request).first else {
                sessionStore.clear()
                return nil
            }

            return user.toModel()
        } catch {
            throw AuthenticationError.storageError(error)
        }
    }

    func logout() {
        sessionStore.clear()
    }


}
