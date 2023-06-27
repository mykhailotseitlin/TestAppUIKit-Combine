//
//  APIResponse.swift
//  TestAppUIKit+Combine
//
//  Created by Mykhailo Tseitlin on 27.06.2023.
//

import Foundation

struct APIResponse<T: Decodable>: Decodable {
    
    let page: Int
    let perPage: Int
    let total: Int
    let totalPages: Int
    let data: [T]
    
}

