//
//  CoreDataStack.swift
//  TestAppUIKit+Combine
//
//  Created by Mykhailo Tseitlin on 27.06.2023.
//

import Foundation
import CoreData

final class CoreDataStack: CoreDataStackProtocol {
    
    let persistentContainer: NSPersistentContainer
    let context: NSManagedObjectContext
    
    init() {
        let container = NSPersistentContainer(name: "TestAppUIKit_Combine")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        self.persistentContainer = container
        self.context = persistentContainer.viewContext
    }
    
}
