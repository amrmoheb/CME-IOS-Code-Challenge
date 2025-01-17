//
//  MockRemoteDataSource.swift
//  CMECodeChallengeTests
//
//  Created by Amr Moheb on 17/01/2025.
//

import Foundation
import Combine
@testable import CMECodeChallenge

final class MockRemoteDataSource: RemoteDataSourceProtocol {
    
    var response: Result<[Country], NetworkError>?

    func fetchRemoteData<T>(endpoint: EndpointProtocol, responseType: T.Type) -> AnyPublisher<T, Error> where T : Decodable {
        guard let response = response else {
            return Fail(error: NetworkError.noData).eraseToAnyPublisher()
        }

        switch response {
        case .success(let countries as T):
            return Just(countries)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        case .failure(let error):
            return Fail(error: error).eraseToAnyPublisher()
        default:
            return Fail(error: NetworkError.decodingError(NSError(domain: "MockRemoteDataSource", code: -1, userInfo: nil))).eraseToAnyPublisher()
        }
    }
}
