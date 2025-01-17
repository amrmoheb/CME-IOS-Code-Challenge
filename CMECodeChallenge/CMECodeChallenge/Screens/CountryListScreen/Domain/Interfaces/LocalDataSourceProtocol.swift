//
//  File.swift
//  CMECodeChallenge
//
//  Created by Amr Moheb on 16/01/2025.
//

import Foundation
protocol LocalDataSourceProtocol {
    func saveData<T: Codable>(_ data: [T], forKey key: String) throws
    func fetchData<T: Codable>(forKey key: String) -> [T]?
}
