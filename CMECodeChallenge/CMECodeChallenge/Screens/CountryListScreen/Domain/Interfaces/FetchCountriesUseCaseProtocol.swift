//
//  FetchCountriesUseCaseProtocol.swift
//  CMECodeChallenge
//
//  Created by Amr Moheb on 16/01/2025.
//

import Foundation
import Combine

protocol FetchCountriesUseCaseProtocol {
    func execute(forceRefresh: Bool) -> AnyPublisher<[Country], NetworkError>
}
