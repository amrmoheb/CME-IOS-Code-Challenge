//
//  CountryListView.swift
//  CMECodeChallenge
//
//  Created by Amr Moheb on 16/01/2025.
//

import Foundation
import SwiftUI

struct CountryListView: View {
    @StateObject private var viewModel: CountryListViewModel = .init()
    @State private var isSheetPresented: Bool = false

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
                CountrySelectionSheet(filteredCountries: $viewModel.filteredCountries, selectedCountries: $viewModel.selectedCountries, isSheetPresented: $isSheetPresented, viewState: $viewModel.viewState,searchText: $viewModel.searchText)
            }
            .navigationTitle("Countries")
        }
    }
//    var selectedCountries: some View {
//        
//    }
    private func removeFromSelected(_ country: Country) {
        viewModel.selectedCountries.removeAll(where: { $0.name == country.name })
        viewModel.viewState = .success(message: "Country is removed Successfully.")
    }
}

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
