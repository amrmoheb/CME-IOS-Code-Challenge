//
//  CountryRepositoryProtocol.swift
//  CMECodeChallenge
//
//  Created by Amr Moheb on 16/01/2025.
//

import Foundation
import Combine

protocol CountryRepositoryProtocol {
    func getCountries(forceRefresh: Bool) -> AnyPublisher<[Country], Error>
}
