//
//  PostModel.swift
//  TestAppUIKit+Combine
//
//  Created by Mykhailo Tseitlin on 27.06.2023.
//

import Foundation

struct PostModel: Codable {
    
    let id: Int16
    let name: String
    let color: String
    
}

extension PostModel {
    
    init(entity: PostEntity) {
        self.init(id: entity.id,
                  name: entity.name ?? "",
                  color: entity.color ?? "")
    }
    
}

extension PostModel: Equatable {}
extension PostModel: Hashable {}
