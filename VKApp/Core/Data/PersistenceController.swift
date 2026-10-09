//
//  PersistenceController.swift
//  VKApp
//
//  Created by Timur Zakirov on 14/09/26.
//
import Foundation
import CoreData

final class PersistenceController {

    static let shared = PersistenceController()

    let container: NSPersistentContainer

    var viewContext: NSManagedObjectContext {
        container.viewContext
    }

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "VKApp")
        
        if let description = container.persistentStoreDescriptions.first{
            description.shouldMigrateStoreAutomatically = true
            description.shouldInferMappingModelAutomatically = true
        }

        if inMemory {
            container.persistentStoreDescriptions.first?.url =
                URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { _, error in
            if let error {
                assertionFailure(
                    "Core Data error: \(error.localizedDescription)"
                )
            }
        }

        configureViewContext()
    }

    private func configureViewContext() {
        viewContext.automaticallyMergesChangesFromParent = true
        viewContext.mergePolicy =
            NSMergeByPropertyObjectTrumpMergePolicy
    }

    func saveViewContext() {
        guard viewContext.hasChanges else {
            return
        }

        do {
            try viewContext.save()
        } catch {
            assertionFailure(
                "Core Data save error: \(error.localizedDescription)"
            )
        }
    }

    func performBackgroundTask(
        _ task: @escaping (NSManagedObjectContext) throws -> Void
    ) {
        container.performBackgroundTask { context in
            context.mergePolicy =
                NSMergeByPropertyObjectTrumpMergePolicy

            do {
                try task(context)

                if context.hasChanges {
                    try context.save()
                }
            } catch {
                assertionFailure(
                    "Core Data background task error: \(error.localizedDescription)"
                )
            }
        }
    }
}

