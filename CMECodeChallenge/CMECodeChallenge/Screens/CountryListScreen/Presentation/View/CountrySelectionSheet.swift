//
//  CountrySelectionSheet.swift
//  CMECodeChallenge
//
//  Created by Amr Moheb on 17/01/2025.
//

import Foundation
import SwiftUI

struct CountrySelectionSheet: View {
    @Binding var filteredCountries: [Country]
    @Binding var selectedCountries: [Country]
    @Binding var isSheetPresented: Bool
    @Binding var viewState: ViewState?
    @Binding var searchText: String
    var body: some View {
        NavigationView {
            List(filteredCountries, id: \ .name) { country in
                Button(action: {
                    addCountry(country)
                }) {
                    Text(country.name)
                }
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
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
            viewState = .success(message: "Country added to the list.")
          
        } else {
            isSheetPresented = false
            viewState = .failure(message: "You can only add up to 5 countries.")
        }
    }
}

