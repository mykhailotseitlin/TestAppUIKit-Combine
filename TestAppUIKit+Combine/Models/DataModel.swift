//
//  DataModel.swift
//  TestAppUIKit+Combine
//
//  Created by Mykhailo Tseitlin on 27.06.2023.
//

import Foundation

struct DataModel {
    
    let stories: [UserModel]
    let posts: [PostModel]
    
    var isEmpty: Bool {
        stories.isEmpty && posts.isEmpty
    }
    
}
