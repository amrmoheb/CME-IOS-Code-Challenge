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
    @Published var selectedCountries: [Country] = []
    @Published var filteredCountries: [Country] = []
    @Published var searchText: String = "" {
        didSet {
            filterCountries()
        }
    }
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var viewState: ViewState? = nil

    private let fetchCountriesUseCase: FetchCountriesUseCaseProtocol
    private let locationManager: CLLocationManager
    private var cancellables = Set<AnyCancellable>()

    init(fetchCountriesUseCase: FetchCountriesUseCaseProtocol = FetchCountriesUseCase()) {
        self.fetchCountriesUseCase = fetchCountriesUseCase
        self.locationManager = CLLocationManager()
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        fetchCountries()
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
                self?.filteredCountries = countries
                self?.requestLocation()
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
    private func filterCountries() {
        if searchText.isEmpty {
            filteredCountries = countries
        } else {
            filteredCountries = countries.filter {
                $0.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
}

