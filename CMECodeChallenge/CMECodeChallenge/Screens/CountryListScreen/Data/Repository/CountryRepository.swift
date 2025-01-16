//
//  File.swift
//  CMECodeChallenge
//
//  Created by Amr Moheb on 16/01/2025.
//

import Foundation
import Combine

final class CountryRepository: CountryRepositoryProtocol {
    private let localDataSource: LocalDataSourceProtocol
    private let remoteDataSource: RemoteDataSourceProtocol
    private let cacheKey = "countriesCache"

    init(localDataSource: LocalDataSourceProtocol = LocalDataSource(), remoteDataSource: RemoteDataSourceProtocol = RemoteDataSource()) {
        self.localDataSource = localDataSource
        self.remoteDataSource = remoteDataSource
    }

    func getCountries(forceRefresh: Bool = false) -> AnyPublisher<[Country], Error> {
        if forceRefresh {
            return fetchAndCacheCountries()
        } else if let cachedCountries: [Country] = localDataSource.fetchData(forKey: cacheKey) {
            return Just(cachedCountries)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } else {
            return fetchAndCacheCountries()
        }
    }

    private func fetchAndCacheCountries() -> AnyPublisher<[Country], Error> {
        remoteDataSource.fetchRemoteData(endpoint: AllCountriesEndPoint.allCountries, responseType: [Country].self)
            .handleEvents(receiveOutput: { [weak self] countries in
                try? self?.localDataSource.saveData(countries, forKey: self?.cacheKey ?? "")
            })
            .eraseToAnyPublisher()
    }
}
