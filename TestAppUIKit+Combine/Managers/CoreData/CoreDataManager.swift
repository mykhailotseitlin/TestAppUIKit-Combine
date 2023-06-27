//
//  CoreDataManager.swift
//  TestAppUIKit+Combine
//
//  Created by Mykhailo Tseitlin on 27.06.2023.
//

import CoreData
import Combine

protocol CoreDataManageable: DataManageable {
    var coreDataStack: CoreDataStackProtocol { get }
    func save(userModels: [UserModel])
    func save(postModels: [PostModel])
}

final class CoreDataManager: CoreDataManageable {
    
    let coreDataStack: CoreDataStackProtocol
    
    init(coreDataStack: CoreDataStackProtocol) {
        self.coreDataStack = coreDataStack
    }
    
    func save(userModels: [UserModel]) {
        saveData(userModels, entity: UserEntity(context: coreDataStack.context))
    }
    
    func save(postModels: [PostModel]) {
        saveData(postModels, entity: PostEntity(context: coreDataStack.context))
    }
    
    func loadData() -> AnyPublisher<DataModel, Error> {
        return Future<DataModel, Error> { [weak self] promise in
            self?.coreDataStack.context.perform { [weak self] in
                guard let self = self else { return }
                let userEntities: [UserEntity] = self.fetchData()
                let postEntities: [PostEntity] = self.fetchData()
                promise(.success(DataModel(stories: userEntities.map { UserModel(entity: $0) },
                                           posts: postEntities.map { PostModel(entity: $0) })))
            }
        }.eraseToAnyPublisher()
    }
    
}

private typealias PrivateHelper = CoreDataManager
private extension PrivateHelper {
    
    func saveContext() {
        coreDataStack.context.perform { [weak self] in
            guard let self = self,
                  self.coreDataStack.context.hasChanges else { return }
            do {
                try self.coreDataStack.context.save()
            } catch {
                fatalError("Failed to save context: \(error)")
            }
        }
    }
    
    func saveData<T: Encodable, E: NSManagedObject>(_ model: T, entity: E) {
        let backgroundContext = coreDataStack.persistentContainer.newBackgroundContext()
        backgroundContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        backgroundContext.performAndWait {
            let objects = model.encodableModel()
            let insertRequest = NSBatchInsertRequest(entity: E.entity(), objects: objects)
            insertRequest.resultType = .objectIDs
            let result = try? backgroundContext.execute(insertRequest) as? NSBatchInsertResult
            if let objectsId = result?.result as? NSManagedObjectID, !objects.isEmpty {
                let save = [NSInsertedObjectsKey: objectsId]
                NSManagedObjectContext.mergeChanges(fromRemoteContextSave: save, into: [coreDataStack.context])
            }
        }
    }
    
    func fetchData<T: NSManagedObject>() -> [T] {
        let fetchRequest: NSFetchRequest<T> = NSFetchRequest<T>(entityName: String(describing: T.self))
        do {
            let resources = try coreDataStack.context.fetch(fetchRequest)
            return resources
        } catch {
            fatalError("Failed to fetch resources: \(error)")
        }
    }
}

