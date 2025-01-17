//
//  MockLocalDataSource.swift
//  CMECodeChallengeTests
//
//  Created by Amr Moheb on 16/01/2025.
//

import Foundation
import Combine
@testable import CMECodeChallenge

final class MockLocalDataSource: LocalDataSourceProtocol {
    private var storage: [String: Data] = [:]

    func saveData<T: Codable>(_ data: [T], forKey key: String) throws {
        let encodedData = try JSONEncoder().encode(data)
        storage[key] = encodedData
    }

    func fetchData<T: Codable>(forKey key: String) -> [T]? {
        guard let data = storage[key] else { return nil }
        return try? JSONDecoder().decode([T].self, from: data)
    }
}
