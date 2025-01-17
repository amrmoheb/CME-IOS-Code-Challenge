//
//  CountryListViewModelTests.swift
//  CMECodeChallengeTests
//
//  Created by Amr Moheb on 16/01/2025.
//
import XCTest
import Foundation
import Combine
@testable import CMECodeChallenge


final class CountryListViewModelTests: XCTestCase {
    var viewModel: CountryListViewModel!
    var mockUseCase: MockFetchCountriesUseCase!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockUseCase = MockFetchCountriesUseCase()
        viewModel = CountryListViewModel(fetchCountriesUseCase: mockUseCase)
        cancellables = []
    }

    override func tearDown() {
        viewModel = nil
        mockUseCase = nil
        cancellables = nil
        super.tearDown()
    }

    func testFetchCountries() {
        mockUseCase.response = .success([Country(name: "Egypt")])
        let expectation = XCTestExpectation(description: "Fetch countries successfully")

        viewModel.fetchCountries()

        viewModel.$countries
            .dropFirst()
            .sink { countries in
                XCTAssertEqual(countries.first?.name, "Egypt", "Country name should match")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 5.0)
    }
}
