//
//  File.swift
//  CMECodeChallenge
//
//  Created by Amr Moheb on 17/01/2025.
//

import Foundation
import SwiftUI

struct CountryDetailView: View {
    let country: Country

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let capital = country.capital {
                    Text("Capital: \(capital)")
                        .font(.headline)
                }

                if let currency = country.currencies?.first {
                    Text("Currency: \(currency.name ?? "")")
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
