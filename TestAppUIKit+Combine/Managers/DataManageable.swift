//
//  DataManageable.swift
//  TestAppUIKit+Combine
//
//  Created by Mykhailo Tseitlin on 27.06.2023.
//

import Foundation
import Combine

protocol DataManageable {
    func loadData() -> AnyPublisher<DataModel, Error>
}

