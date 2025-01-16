//
//  File.swift
//  CMECodeChallenge
//
//  Created by Amr Moheb on 16/01/2025.
//

import Foundation
import Combine

protocol NetworkManagerProtocol {
    func request<T: Decodable>(endpoint: EndpointProtocol, responseType: T.Type) -> AnyPublisher<T, Error>
}
