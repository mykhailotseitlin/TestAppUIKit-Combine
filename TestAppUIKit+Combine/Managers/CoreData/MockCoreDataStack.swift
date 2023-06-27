//
//  MockCoreDataStack.swift
//  TestAppUIKit+Combine
//
//  Created by Mykhailo Tseitlin on 27.06.2023.
//

import Foundation
import CoreData

final class MockCoreDataStack: CoreDataStackProtocol {
    
    let persistentContainer: NSPersistentContainer
    let context: NSManagedObjectContext
    
    init() {
        let description = NSPersistentStoreDescription()
        description.url = URL(fileURLWithPath: "dev/null")
        let container = NSPersistentContainer(name: "TestAppUIKit_Combine")
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        self.persistentContainer = container
        self.context = persistentContainer.viewContext
    }
    
}
