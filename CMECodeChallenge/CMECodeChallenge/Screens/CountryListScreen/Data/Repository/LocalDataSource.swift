//
//  File.swift
//  CMECodeChallenge
//
//  Created by Amr Moheb on 16/01/2025.
//

import Foundation

final class LocalDataSource: LocalDataSourceProtocol {
    private let fileManager = FileManager.default
    private let directory: URL

    init() {
        directory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
    }

    func saveData<T: Codable>(_ data: [T], forKey key: String) throws {
        let fileURL = directory.appendingPathComponent(key) // Use key as filename
        let encoder = JSONEncoder()
        let encodedData = try encoder.encode(data)
        try encodedData.write(to: fileURL)
    }

    func fetchData<T: Codable>(forKey key: String) -> [T]? {
        let fileURL = directory.appendingPathComponent(key)
        guard let data = try? Data(contentsOf: fileURL) else { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode([T].self, from: data)
    }
}


