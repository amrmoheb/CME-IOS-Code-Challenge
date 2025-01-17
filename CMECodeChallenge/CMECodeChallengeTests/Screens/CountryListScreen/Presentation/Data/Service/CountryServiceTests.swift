//
//  CountryServiceTests.swift
//  CMECodeChallengeTests
//
//  Created by Amr Moheb on 16/01/2025.
//

import XCTest
import Foundation
import Combine
@testable import CMECodeChallenge

final class CountryServiceTests: XCTestCase {
    var service: CountryService!
    var mockNetworkManager: MockNetworkManager!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager()
        service = CountryService(networkManager: mockNetworkManager)
        cancellables = []
    }

    override func tearDown() {
        service = nil
        mockNetworkManager = nil
        cancellables = nil
        super.tearDown()
    }

    func testGetCountries() {
        let expectation = XCTestExpectation(description: "Fetch countries successfully")
        service.endPoint = MockCountriesEndpoint.allCountries
        service.getCountries()
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
    
    func testGetCountriesFailure() {
        let expectation = XCTestExpectation(description: "Handle failure when fetching countries")
        service.endPoint = MockCountriesFailureEndpoint.allCountries
        service.getCountries()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTAssertNotNil(error)
                    expectation.fulfill()
                }
            }, receiveValue: { _ in
                XCTFail("Request should fail")
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 5.0)
    }
}
