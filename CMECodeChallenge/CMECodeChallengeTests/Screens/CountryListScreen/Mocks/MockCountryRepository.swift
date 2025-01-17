//
//  MockCountryRepository.swift
//  CMECodeChallengeTests
//
//  Created by Amr Moheb on 16/01/2025.
//

import Foundation
import Combine
@testable import CMECodeChallenge

final class MockCountryRepository: CountryRepositoryProtocol {
    
    var response: Result<[Country], Error>?

    func getCountries(forceRefresh: Bool) -> AnyPublisher<[Country], Error> {
        guard let response = response else {
            return Fail(error: NetworkError.noData).eraseToAnyPublisher()
        }

        return response.publisher.eraseToAnyPublisher()
    }
}
