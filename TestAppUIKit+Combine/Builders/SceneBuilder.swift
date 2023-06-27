//
//  SceneBuilder.swift
//  TestAppUIKit+Combine
//
//  Created by Mykhailo Tseitlin on 27.06.2023.
//

import Foundation

enum SceneBuilder {
    
    static func buildViewController(isMocking: Bool = false) -> (viewModel: ViewModel, vc: ViewController) {
        let coreDataStack: CoreDataStackProtocol = isMocking ? MockCoreDataStack() : CoreDataStack()
        let coreDataManager = CoreDataManager(coreDataStack: coreDataStack)
        let networkManager = NetworkManager()
        let dataManager = DataManager(coreDataManager: coreDataManager, networkManager: networkManager)
        let viewModel = ViewModel(dataManager: dataManager)
        let viewController = ViewController(viewModel: viewModel)
        return (viewModel, viewController)
    }
    
}
