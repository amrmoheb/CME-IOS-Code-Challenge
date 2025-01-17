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
                    selectedCountries
                    VStack{
                        addCountryBtn
                        statusMessage
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
    
    var selectedCountries: some View {
        VStack {
            ForEach(viewModel.selectedCountries, id: \ .name) { country in
                HStack {
                    NavigationLink(destination: CountryDetailView(country: country)) {
                        Text(country.name)
                        Spacer()
                        Button(action: {
                            viewModel.removeFromSelected(country)
                        }) {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.red)
                        }
                    }.padding()
                }
            }
        }
    }
    
    var addCountryBtn: some View {
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
    }
    
    @ViewBuilder
    var statusMessage: some View {
        if let state = viewModel.viewState {
            Text(state.message)
            .foregroundColor(state.color)
        } else {
            EmptyView()
        }
    }
    
  
}
