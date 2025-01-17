//
//  MockCountryService.swift
//  CMECodeChallengeTests
//
//  Created by Amr Moheb on 16/01/2025.
//

import Foundation
import Combine
@testable import CMECodeChallenge

final class MockCountryService: CountryServiceProtocol {
    
    var response: Result<[Country], NetworkError>?

    func getCountries() -> AnyPublisher<[Country], Error> {
        guard let response = response else {
            return Fail(error: NetworkError.noData).eraseToAnyPublisher()
        }
        switch response {
                case .success(let countries):
                    return Just(countries)
                            .mapError { $0 as Error } // Convert NetworkError to Error
                            .eraseToAnyPublisher()
                case .failure(let error):
                    return Fail(error: error).eraseToAnyPublisher()
                }
    }
}
/*final class MockCountryService: CountryServiceProtocol {
    private let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol = MockNetworkManager()) {
        self.networkManager = networkManager
    }

    func getCountries() -> AnyPublisher<[Country], Error> {
        return networkManager.request(endpoint: MockCountriesEndpoint.allCountries, responseType: [Country].self)
    }
}*/

