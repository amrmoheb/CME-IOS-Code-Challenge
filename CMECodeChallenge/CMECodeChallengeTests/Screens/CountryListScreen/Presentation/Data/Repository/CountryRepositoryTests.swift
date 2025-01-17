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
    
    func testFetchCountriesFromRemoteFailure() {
        mockRemoteDataSource.response = .failure(NetworkError.customError("Failed to fetch countries"))
        let expectation = XCTestExpectation(description: "Handle failure when fetching countries from remote")

        repository.getCountries(forceRefresh: true)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTAssertEqual(error.localizedDescription, "Failed to fetch countries", "Error message should match")
                    expectation.fulfill()
                }
            }, receiveValue: { _ in
                XCTFail("Request should fail")
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 5.0)
    }

    func testFetchCountriesFromLocalSuccess() {
            do {
                // Prepare local data
                let localCountries = [Country(name: "Egypt")]
                try mockLocalDataSource.saveData(localCountries, forKey: "countriesCache")

                // Fetch from repository
                let expectation = XCTestExpectation(description: "Fetch countries from local storage successfully")

                repository.getCountries(forceRefresh: false)
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
            } catch {
                XCTFail("Failed to set up mock local data: \(error)")
            }
        }

        func testFetchCountriesFromLocalFailure() {
            // Ensure no data is saved in local storage

            let expectation = XCTestExpectation(description: "Handle failure when no local data exists")

            repository.getCountries(forceRefresh: false)
                .sink(receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        XCTAssertEqual(error.localizedDescription, NetworkError.noData.localizedDescription, "Error message should match")
                        expectation.fulfill()
                    }
                }, receiveValue: { _ in
                    XCTFail("Request should fail")
                })
                .store(in: &cancellables)

            wait(for: [expectation], timeout: 5.0)
        }
}

