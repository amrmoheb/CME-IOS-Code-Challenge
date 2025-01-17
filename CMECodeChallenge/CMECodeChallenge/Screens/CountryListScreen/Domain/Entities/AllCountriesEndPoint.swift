//
//  AllCountriesEndPoint.swift
//  CMECodeChallenge
//
//  Created by Amr Moheb on 16/01/2025.
//

import Foundation
enum AllCountriesEndPoint: EndpointProtocol {
    case allCountries

    var url: String? {
        switch self {
        case .allCountries:
            return "/v2/all"
        }
    }

    var method: String {
        switch self {
        case .allCountries:
            return "GET"
        }
    }

    var headers: [String: String] {
        return ["Content-Type": "application/json"]
    }
}
