//
//  EndPointProtocol.swift
//  CMECodeChallenge
//
//  Created by Amr Moheb on 16/01/2025.
//

import Foundation

protocol EndpointProtocol {
    var url: URL? { get }
    var method: String { get }
    var headers: [String: String] { get }
}
