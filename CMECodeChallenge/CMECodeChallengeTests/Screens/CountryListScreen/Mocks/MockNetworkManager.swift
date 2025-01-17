//
//  File.swift
//  CMECodeChallengeTests
//
//  Created by Amr Moheb on 16/01/2025.
//

import Foundation
import Combine
@testable import CMECodeChallenge
/*
final class MockNetworkManager: NetworkManagerProtocol {
    var response: Result<Data, NetworkError>?

    func request<T>(endpoint: EndpointProtocol, responseType: T.Type) -> AnyPublisher<T, Error> where T: Decodable {
        guard let response = response else {
            return Fail(error: NetworkError.noData).mapError { $0 as Error }.eraseToAnyPublisher()
        }

        return Future<T, Error> { promise in
            switch response {
            case .success(let data):
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    promise(.success(decodedData))
                } catch {
                    promise(.failure(NetworkError.decodingError(error)))
                }
            case .failure(let error):
                promise(.failure(error))
            }
        }
        .mapError { $0 as Error } // Convert NetworkError to Error
        .eraseToAnyPublisher()
    }
}*/
final class MockNetworkManager: NetworkManagerProtocol {
    func request<T>(endpoint: EndpointProtocol, responseType: T.Type) -> AnyPublisher<T, Error> where T: Decodable {
        do {
            // Load the JSON file based on the `url` property of the endpoint
            let data = try loadMockData(from: endpoint.url ?? "")
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return Just(decodedData)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
    }

    private func loadMockData(from fileName: String) throws -> Data {
        let testBundle = Bundle(for: type(of: self))
        guard let path = testBundle.path(forResource: fileName, ofType: "json") else {
            throw NetworkError.customError("Failed to load data from \(fileName)")

        }
        let fileURL = URL(fileURLWithPath: path)

        do {
            return try Data(contentsOf: fileURL)
        } catch {
            throw NetworkError.customError("Failed to load data from \(fileName).json: \(error.localizedDescription)")
        }
    }
}
