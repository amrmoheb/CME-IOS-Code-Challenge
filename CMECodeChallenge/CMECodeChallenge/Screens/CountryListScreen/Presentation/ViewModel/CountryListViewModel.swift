//
//  ViewModel.swift
//  CMECodeChallenge
//
//  Created by Amr Moheb on 16/01/2025.
//
// CountryListViewModel.swift

import Foundation
import Combine
import CoreLocation

final class CountryListViewModel: NSObject, ObservableObject {
    @Published var countries: [Country] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var userCountry: String = "Egypt" // Default country

    private let fetchCountriesUseCase: FetchCountriesUseCaseProtocol
    private let locationManager: CLLocationManager
    private var cancellables = Set<AnyCancellable>()

    init(fetchCountriesUseCase: FetchCountriesUseCaseProtocol = FetchCountriesUseCase()) {
        self.fetchCountriesUseCase = fetchCountriesUseCase
        self.locationManager = CLLocationManager()
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func fetchCountries(forceRefresh: Bool = false) {
        isLoading = true
        errorMessage = nil

        fetchCountriesUseCase.execute(forceRefresh: forceRefresh)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }, receiveValue: { [weak self] countries in
                self?.countries = countries
            })
            .store(in: &cancellables)
    }

    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func getCountryByName(_ name: String) -> Country? {
        countries.first(where: { $0.name.lowercased() == name.lowercased() })
    }
    func getCountryByISOCode(_ isoCode: String) -> Country? {
        
        if let country = countries.first(where: { $0.alpha2Code?.lowercased() == isoCode.lowercased() }) {
            return country
        } else {
            return countries.first(where: { $0.alpha2Code?.lowercased() == "eg" })
        }
    }
}

