//
//  FetchCountriesUseCaseTests.swift
//  CMECodeChallengeTests
//
//  Created by Amr Moheb on 16/01/2025.
//

import XCTest
import Foundation
import Combine
@testable import CMECodeChallenge

final class FetchCountriesUseCaseTests: XCTestCase {
    var useCase: FetchCountriesUseCase!
    var mockRepository: MockCountryRepository!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockRepository = MockCountryRepository()
        useCase = FetchCountriesUseCase(repository: mockRepository)
        cancellables = []
    }

    override func tearDown() {
        useCase = nil
        mockRepository = nil
        cancellables = nil
        super.tearDown()
    }

    func testExecute() {
        mockRepository.response = .success([Country(name: "Egypt")])
        let expectation = XCTestExpectation(description: "Fetch countries successfully")

        useCase.execute(forceRefresh: true)
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
    
    func testExecuteFailure() {
        mockRepository.response = .failure(NetworkError.customError("Failed to fetch countries"))
        let expectation = XCTestExpectation(description: "Handle failure when fetching countries")

        useCase.execute(forceRefresh: true)
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
}
