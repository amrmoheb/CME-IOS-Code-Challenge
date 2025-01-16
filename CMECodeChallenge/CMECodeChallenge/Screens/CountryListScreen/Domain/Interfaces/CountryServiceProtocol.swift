//
//  File.swift
//  CMECodeChallenge
//
//  Created by Amr Moheb on 16/01/2025.
//

import Foundation
import Combine

protocol CountryServiceProtocol {
    func getCountries() -> AnyPublisher<[Country], Error>
}
