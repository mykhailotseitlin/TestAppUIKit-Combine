//
//  NetworkManager.swift
//  TestAppUIKit+Combine
//
//  Created by Mykhailo Tseitlin on 27.06.2023.
//

import Foundation
import Combine

final class NetworkManager: DataManageable {
    
    func loadData() -> AnyPublisher<DataModel, Error> {
        guard let firstURL = URL(string: "https://reqres.in/api/users"),
              let secondURL = URL(string: "https://reqres.in/api/unknown") else {
            return Empty<DataModel, Error>().eraseToAnyPublisher()
        }
        let userRequest: AnyPublisher<APIResponse<UserModel>, Error> = fetchDataCombine(from: firstURL)
        let postRequest: AnyPublisher<APIResponse<PostModel>, Error> = fetchDataCombine(from: secondURL)
        let combinedRequests = userRequest.zip(postRequest)
        return combinedRequests
            .map { DataModel(stories: $0.0.data, posts: $0.1.data) }
            .eraseToAnyPublisher()
    }
    
}

private typealias PrivateHelper = NetworkManager
private extension PrivateHelper {
    
    var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
    
    func fetchDataCombine<T: Decodable>(from url: URL) -> AnyPublisher<T, Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .compactMap { $0.data }
            .decode(type: T.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
}

