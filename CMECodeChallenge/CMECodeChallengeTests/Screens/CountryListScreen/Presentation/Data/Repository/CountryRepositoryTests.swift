//
//  CountryRepositoryTests.swift
//  CMECodeChallengeTests
//
//  Created by Amr Moheb on 16/01/2025.
//

import XCTest
import Foundation
import Combine
@testable import CMECodeChallenge

final class CountryRepositoryTests: XCTestCase {
    var repository: CountryRepository!
    var mockLocalDataSource: MockLocalDataSource!
    var mockRemoteDataSource: MockRemoteDataSource!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockLocalDataSource = MockLocalDataSource()
        mockRemoteDataSource = MockRemoteDataSource()
        repository = CountryRepository(localDataSource: mockLocalDataSource, remoteDataSource: mockRemoteDataSource)
        cancellables = []
    }

    override func tearDown() {
        repository = nil
        mockLocalDataSource = nil
        mockRemoteDataSource = nil
        cancellables = nil
        super.tearDown()
    }

    func testFetchCountriesFromRemote() {
        mockRemoteDataSource.response = .success([Country(name: "Egypt")])
        let expectation = XCTestExpectation(description: "Fetch countries from remote successfully")

        repository.getCountries(forceRefresh: true)
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    XCTFail("Request should succeed")
                }
            }, receiveValue: { countries in
                XCTAssertEqual(countries.first?.name, "Egypt", "Country name should match")
                expectation.fulfill()
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 5.0)
    }
}

