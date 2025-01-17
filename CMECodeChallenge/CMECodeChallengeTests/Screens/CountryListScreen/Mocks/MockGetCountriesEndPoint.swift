//
//  MockEndPoint.swift
//  CMECodeChallengeTests
//
//  Created by Amr Moheb on 17/01/2025.
//
import Foundation
import Combine
@testable import CMECodeChallenge
import Foundation

enum MockCountriesEndpoint: EndpointProtocol {    
    case allCountries

    var url: String? {
        switch self {
        case .allCountries:
            return "CountriesListSuccessResponse" // JSON file name for all countries
        }
    }

    var method: String {
        return ""
    }

    var headers: [String: String] {
        return [:]
    }
}

enum MockCountriesFailureEndpoint: EndpointProtocol {
    case allCountries

    var url: String? {
        switch self {
        case .allCountries:
            return "CountriesListFailureResponse" // JSON file name for all countries
        }
    }

    var method: String {
        return ""
    }

    var headers: [String: String] {
        return [:]
    }
}
