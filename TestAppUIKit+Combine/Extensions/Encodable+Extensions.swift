//
//  Encodable+Extensions.swift
//  TestAppUIKit+Combine
//
//  Created by Mykhailo Tseitlin on 27.06.2023.
//

import Foundation

extension Encodable {
    
    func encodableModel() -> [[String: Any]] {
        if let data = try? JSONEncoder().encode(self),
           let json = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] {
            return json
        } else {
            return []
        }
    }
    
}

