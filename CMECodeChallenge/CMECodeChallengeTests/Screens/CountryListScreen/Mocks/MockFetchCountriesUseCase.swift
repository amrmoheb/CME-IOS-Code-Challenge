//
//  MockFetchCountriesUseCase.swift
//  CMECodeChallengeTests
//
//  Created by Amr Moheb on 16/01/2025.
//

import Foundation
import Combine
@testable import CMECodeChallenge

final class MockFetchCountriesUseCase: FetchCountriesUseCaseProtocol {
    var response: Result<[Country], NetworkError>?

    func execute(forceRefresh: Bool) -> AnyPublisher<[Country], NetworkError> {
        guard let response = response else {
            return Fail(error: NetworkError.noData).eraseToAnyPublisher()
        }

        return response.publisher.eraseToAnyPublisher()
    }
}
