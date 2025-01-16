//
//  File.swift
//  CMECodeChallenge
//
//  Created by Amr Moheb on 16/01/2025.
//

import Foundation
import Combine

final class RemoteDataSource: RemoteDataSourceProtocol {
    private let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }

    func fetchRemoteData<T: Decodable>(endpoint: EndpointProtocol, responseType: T.Type) -> AnyPublisher<T, Error> {
        networkManager.request(endpoint: endpoint, responseType: responseType)
    }
}
