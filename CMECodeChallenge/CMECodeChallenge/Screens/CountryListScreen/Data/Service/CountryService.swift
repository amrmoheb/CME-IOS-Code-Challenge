//
//  File.swift
//  CMECodeChallenge
//
//  Created by Amr Moheb on 16/01/2025.
//

import Foundation
import Combine

final class CountryService: CountryServiceProtocol {
    private let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }

    func getCountries() -> AnyPublisher<[Country], Error> {
        networkManager.request(endpoint: AllCountriesEndPoint.allCountries, responseType: [Country].self)
    }
}
