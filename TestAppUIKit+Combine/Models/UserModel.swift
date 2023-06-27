//
//  UserModel.swift
//  TestAppUIKit+Combine
//
//  Created by Mykhailo Tseitlin on 27.06.2023.
//

import Foundation

struct UserModel: Codable {
    
    let id: Int16
    let firstName: String
    let lastName: String
    let avatar: String
    
}

extension UserModel {
    
    init(entity: UserEntity) {
        self.init(id: entity.id,
                  firstName: entity.firstName ?? "",
                  lastName: entity.lastName ?? "",
                  avatar: entity.avatar ?? "")
    }
    
}

extension UserModel: Equatable {}
extension UserModel: Hashable {}
