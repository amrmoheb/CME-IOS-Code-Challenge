//
//  CountriesResponse.swift
//  CMECodeChallenge
//
//  Created by Amr Moheb on 16/01/2025.
//

import Foundation

// MARK: - Country
struct Country: Codable {
    let name: String
    let topLevelDomain: [String]?
    let alpha2Code: String?
    let alpha3Code: String?
    let callingCodes: [String]?
    let capital: String?
    let altSpellings: [String]?
    let region: String?
    let subregion: String?
    let population: Int?
    let latlng: [Double]?
    let demonym: String?
    let area: Double?
    let gini: Double?
    let timezones: [String]?
    let borders: [String]?
    let nativeName: String?
    let numericCode: String?
    let currencies: [Currency]?
    let languages: [Language]?
    let translations: Translations?
    let flag: String?
    let regionalBlocs: [RegionalBloc]?
    let cioc: String?
}

// MARK: - Currency
struct Currency: Codable {
    let code: String?
    let name: String?
    let symbol: String?
}

// MARK: - Language
struct Language: Codable {
    let iso639_1: String?
    let iso639_2: String?
    let name: String?
    let nativeName: String?
}

// MARK: - RegionalBloc
struct RegionalBloc: Codable {
    let acronym: String?
    let name: String?
    let otherAcronyms: [String]?
    let otherNames: [String]?
}

// MARK: - Translations
struct Translations: Codable {
    let de, es, fr, ja, it, br, pt, nl, hr, fa: String?
}
