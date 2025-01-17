//
//  NetworkManager.swift
//  CMECodeChallenge
//
//  Created by Amr Moheb on 16/01/2025.
//
// NetworkManager.swift

import Foundation
import Combine
// MARK: - Network Manager
final class NetworkManager: NetworkManagerProtocol {
    static let shared = NetworkManager()
    let baseURL: String = "https://restcountries.com"
    private init() {}

    func request<T: Decodable>(endpoint: EndpointProtocol, responseType: T.Type) -> AnyPublisher<T, Error> {
        
        guard let url = URL(string: (baseURL + (endpoint.url ?? "")) ?? "") else {
              return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
          }
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method
        request.allHTTPHeaderFields = endpoint.headers

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let httpResponse = output.response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw NetworkError.customError("Invalid server response")
                }
                return output.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                if let networkError = error as? NetworkError {
                    return networkError
                } else if let decodingError = error as? DecodingError {
                    return NetworkError.decodingError(decodingError)
                } else {
                    return NetworkError.customError(error.localizedDescription)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
