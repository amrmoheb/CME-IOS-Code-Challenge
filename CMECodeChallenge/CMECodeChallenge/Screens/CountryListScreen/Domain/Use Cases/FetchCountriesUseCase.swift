//
//  FetchCountriesUseCase.swift
//  CMECodeChallenge
//
//  Created by Amr Moheb on 16/01/2025.
//

import Foundation
import Combine

final class FetchCountriesUseCase: FetchCountriesUseCaseProtocol {
    private let repository: CountryRepositoryProtocol

    init(repository: CountryRepositoryProtocol = CountryRepository()) {
        self.repository = repository
    }

    func execute(forceRefresh: Bool) -> AnyPublisher<[Country], NetworkError> {
        repository.getCountries(forceRefresh: forceRefresh)
            .mapError { error in
                error as? NetworkError ?? NetworkError.customError("An unknown error occurred: \(error.localizedDescription)")
            }
            .eraseToAnyPublisher()
    }
}
