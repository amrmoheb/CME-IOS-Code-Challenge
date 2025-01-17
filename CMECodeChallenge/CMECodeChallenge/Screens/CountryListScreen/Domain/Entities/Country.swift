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
    
    init(name: String, topLevelDomain: [String]? = nil, alpha2Code: String? = nil, alpha3Code: String? = nil, callingCodes: [String]? = nil, capital: String? = nil, altSpellings: [String]? = nil, region: String? = nil, subregion: String? = nil, population: Int? = nil, latlng: [Double]? = nil, demonym: String? = nil, area: Double? = nil, gini: Double? = nil, timezones: [String]? = nil, borders: [String]? = nil, nativeName: String? = nil, numericCode: String? = nil, currencies: [Currency]? = nil, languages: [Language]? = nil, translations: Translations? = nil, flag: String? = nil, regionalBlocs: [RegionalBloc]? = nil, cioc: String? = nil) {
        self.name = name
        self.topLevelDomain = topLevelDomain
        self.alpha2Code = alpha2Code
        self.alpha3Code = alpha3Code
        self.callingCodes = callingCodes
        self.capital = capital
        self.altSpellings = altSpellings
        self.region = region
        self.subregion = subregion
        self.population = population
        self.latlng = latlng
        self.demonym = demonym
        self.area = area
        self.gini = gini
        self.timezones = timezones
        self.borders = borders
        self.nativeName = nativeName
        self.numericCode = numericCode
        self.currencies = currencies
        self.languages = languages
        self.translations = translations
        self.flag = flag
        self.regionalBlocs = regionalBlocs
        self.cioc = cioc
    }
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
