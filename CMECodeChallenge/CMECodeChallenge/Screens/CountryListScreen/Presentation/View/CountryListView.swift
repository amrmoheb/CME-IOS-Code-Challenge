//
//  CountryListView.swift
//  CMECodeChallenge
//
//  Created by Amr Moheb on 16/01/2025.
//

import Foundation
import SwiftUI
/*
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
*/
import SwiftUI

struct CountryListView: View {
    @StateObject private var viewModel: CountryListViewModel = .init()
    
    @State private var isSheetPresented: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var errorMessage: String = ""

    var body: some View {
        NavigationView {
            VStack {
                Section(header: Text("Selected Countries")) {
                    VStack {
                        ForEach(viewModel.selectedCountries, id: \ .name) { country in
                            HStack {
                                NavigationLink(destination: CountryDetailView(country: country)) {
                                    
                                    Text(country.name)
                                    Spacer()
                                    Button(action: {
                                        removeFromSelected(country)
                                    }) {
                                        Image(systemName: "minus.circle.fill")
                                            .foregroundColor(.red)
                                    }
                                }
                            }
                        }
                    }.padding()
                  //  .frame(height: CGFloat(selectedCountries.count * 44))
                    VStack{
                        Button(action: {
                            isSheetPresented = true
                        }) {
                            HStack {
                                Image(systemName: "plus")
                                Text("Add Country")
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                        if let state = viewModel.viewState {
                                           Text(state.message)
                                               .foregroundColor(state.color)
                                               .padding()
                                       }
                    }
                    .padding()
                }
                Spacer()
            }
            .sheet(isPresented: $isSheetPresented) {
                CountrySelectionSheet(viewModel: viewModel, selectedCountries: $viewModel.selectedCountries, isSheetPresented: $isSheetPresented, showAlert: $showAlert, viewState: $viewModel.viewState)
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .onAppear {
               
            }
            .navigationTitle("Countries")
        }
    }

    private func removeFromSelected(_ country: Country) {
        viewModel.selectedCountries.removeAll(where: { $0.name == country.name })
        viewModel.viewState = .success(message: "Country is removed Successfully.")
    }
}

struct CountrySelectionSheet: View {
    @ObservedObject var viewModel: CountryListViewModel
    @Binding var selectedCountries: [Country]
    @Binding var isSheetPresented: Bool
    @Binding var showAlert: Bool
    @Binding var viewState: ViewState?
    var body: some View {
        NavigationView {
            List(viewModel.countries, id: \ .name) { country in
                Button(action: {
                    addCountry(country)
                }) {
                    Text(country.name)
                }
            }
            .navigationTitle("Select a Country")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        isSheetPresented = false
                    }
                }
            }
        }
    }

    private func addCountry(_ country: Country) {
        if selectedCountries.contains(where: { $0.name == country.name }) {
            isSheetPresented = false
            viewState = .failure(message: "Country is already added.")
        } else if selectedCountries.count < 5 {
            selectedCountries.append(country)
            isSheetPresented = false
            viewModel.viewState = .success(message: "Country added to the list.")
          
        } else {
            isSheetPresented = false
            viewModel.viewState = .failure(message: "You can only add up to 5 countries.")
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
