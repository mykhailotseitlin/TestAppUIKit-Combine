//
//  DataManager.swift
//  TestAppUIKit+Combine
//
//  Created by Mykhailo Tseitlin on 27.06.2023.
//

import Foundation
import Combine

final class DataManager: DataManageable {
    
    private let coreDataManager: CoreDataManageable
    private let networkManager: DataManageable
    private var cancellable: Set<AnyCancellable> = []
    
    init(coreDataManager: CoreDataManageable, networkManager: DataManageable) {
        self.coreDataManager = coreDataManager
        self.networkManager = networkManager
    }
    
    func loadData() -> AnyPublisher<DataModel, Error> {
        coreDataManager.loadData()
            .flatMap { [weak self] (dataModel) -> AnyPublisher<DataModel, Error> in
                guard let self = self else { return Fail(error: URLError.badServerResponse as! Error).eraseToAnyPublisher() }
                return dataModel.isEmpty ? self.loadDataFromNetworkAndSaveInDataBase() : self.sendDataModelFromDataBase(dataModel)
            }
            .eraseToAnyPublisher()
    }
    
}

private extension DataManager {
    
    func loadDataFromNetworkAndSaveInDataBase() -> AnyPublisher<DataModel, Error> {
        networkManager.loadData()
            .handleEvents(receiveOutput: { [weak self] model in
                self?.coreDataManager.save(userModels: model.stories)
                self?.coreDataManager.save(postModels: model.posts)
            })
            .map { $0 }
            .eraseToAnyPublisher()
    }
    
    func sendDataModelFromDataBase(_ dataModel: DataModel) -> AnyPublisher<DataModel, Error> {
        Just<DataModel>(dataModel)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
}
