//
//  CoreDataUserRepository.swift
//  VKApp
//
//  Created by Timur Zakirov on 01/10/26.
//

import CoreData
import Foundation

final class CoreDataUserRepository: UserRepository {

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func fetchFriends() throws -> [FriendListItem] {
        let request = NSFetchRequest<UserEntity>(
            entityName: "UserEntity"
        )

        request.predicate = NSPredicate(
            format: "isFriend == YES"
        )

        request.sortDescriptors = [
            NSSortDescriptor(
                key: "isOnline",
                ascending: false
            ),
            NSSortDescriptor(
                key: "firstName",
                ascending: true
            ),
            NSSortDescriptor(
                key: "lastName",
                ascending: true
            )
        ]

        do {
            return try context.fetch(request).compactMap {
                user in

                guard let id = user.id else {
                    return nil
                }

                return FriendListItem(
                    id: id,
                    fullName: user.displayName,
                    avatarName: user.avatarName,
                    statusText: user.statusText,
                    isOnline: user.isOnline
                )
            }
        } catch {
            throw UserRepositoryError.fetchFailed(error)
        }
    }

    func fetchUser(id: UUID) throws -> AppUser? {
        let request = NSFetchRequest<UserEntity>(
            entityName: "UserEntity"
        )

        request.fetchLimit = 1
        request.predicate = NSPredicate(
            format: "id == %@",
            id as NSUUID
        )

        do {
            return try context.fetch(request).first?.toModel()
        } catch {
            throw UserRepositoryError.fetchFailed(error)
        }
    }
    
    
    func fetchUsers() throws -> [FriendListItem] {
        let request = NSFetchRequest<UserEntity>(
            entityName: "UserEntity"
        )

        request.sortDescriptors = [
            NSSortDescriptor(
                key: "firstName",
                ascending: true
            ),
            NSSortDescriptor(
                key: "lastName",
                ascending: true
            )
        ]

        do {
            return try context.fetch(request).compactMap {
                user in

                guard let id = user.id else {
                    return nil
                }

                return FriendListItem(
                    id: id,
                    fullName: user.displayName,
                    avatarName: user.avatarName,
                    statusText: user.statusText,
                    isOnline: user.isOnline
                )
            }
        } catch {
            throw UserRepositoryError.fetchFailed(error)
        }
    }

    
}
