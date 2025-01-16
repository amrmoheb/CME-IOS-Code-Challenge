//
//  CountryListView.swift
//  CMECodeChallenge
//
//  Created by Amr Moheb on 16/01/2025.
//

import Foundation
import SwiftUI
// CountryListView.swift

import SwiftUI

struct CountryListView: View {
    @StateObject private var viewModel : CountryListViewModel = .init()

    var body: some View {
        NavigationView {
            VStack {
                Section(header: Text("Your Country")) {
                    if let userCountry = viewModel.getCountryByISOCode(viewModel.userCountry) {
                        NavigationLink(destination: CountryDetailView(country: userCountry)) {
                            HStack {
                                Text(userCountry.name)
                                    .font(.headline)
                                Spacer()
                                Text("(Detected)")
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding()
                    } else {
                        Text("No country detected.")
                            .foregroundColor(.secondary)
                            .padding()
                    }
                }

                Section(header: Text("All Countries")) {
                    if viewModel.isLoading {
                        ProgressView("Loading countries...")
                    } else if let errorMessage = viewModel.errorMessage {
                        VStack {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                            Button("Retry") {
                                viewModel.fetchCountries()
                            }
                            .padding()
                        }
                    } else {
                        List(viewModel.filteredCountries, id: \ .name) { country in
                            NavigationLink(destination: CountryDetailView(country: country)) {
                                Text(country.name)
                            }
                        }
                    }
                }
            }
            .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always))
            .onAppear {
                viewModel.requestLocation()
                viewModel.fetchCountries()
            }
            .navigationTitle("Countries")
        }
    }
}



struct CountryDetailView: View {
    let country: Country

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let flagURL = country.flag, let url = URL(string: flagURL) {
                    AsyncImage(url: url) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 200)
                }

                Text(country.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)

                if let capital = country.capital {
                    Text("Capital: \(capital)")
                        .font(.headline)
                }

                if let region = country.region {
                    Text("Region: \(region)")
                        .font(.headline)
                }

                if let population = country.population {
                    Text("Population: \(population.formattedWithSeparator())")
                        .font(.headline)
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle(country.name)
    }
}

// MARK: - Number Formatting Extension

extension Int {
    func formattedWithSeparator() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(for: self) ?? ""
    }
}
