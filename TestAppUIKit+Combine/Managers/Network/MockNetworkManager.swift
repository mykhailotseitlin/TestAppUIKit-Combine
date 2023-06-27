//
//  MockNetworkManager.swift
//  TestAppUIKit+Combine
//
//  Created by Mykhailo Tseitlin on 27.06.2023.
//

import Foundation
import Combine

final class MockNetworkManager: DataManageable {
    
    func loadData() -> AnyPublisher<DataModel, Error> {
        Just(DataModel(stories: [], posts: []))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
}

