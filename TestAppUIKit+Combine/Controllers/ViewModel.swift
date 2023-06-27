//
//  ViewModel.swift
//  TestAppUIKit+Combine
//
//  Created by Mykhailo Tseitlin on 27.06.2023.
//

import Foundation
import Combine

protocol ViewModelProtocol {
    var subject: PassthroughSubject<DataModel, Never> { get }
    func loadData()
}

class ViewModel: ViewModelProtocol {
    
    let subject: PassthroughSubject<DataModel, Never> = PassthroughSubject()
    
    private let dataManager: DataManageable
    private var subscriptions: Set<AnyCancellable> = []
    
    init(dataManager: DataManageable) {
        self.dataManager = dataManager
    }
    
    func loadData() {
        dataManager.loadData()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                print(#line, #function, completion)
            } receiveValue: { model in
                self.subject.send(model)
            }
            .store(in: &subscriptions)
    }
    
}

