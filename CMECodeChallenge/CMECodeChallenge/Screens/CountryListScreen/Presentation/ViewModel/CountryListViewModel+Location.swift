//
//  File.swift
//  CMECodeChallenge
//
//  Created by Amr Moheb on 16/01/2025.
//

import Foundation
import CoreLocation
extension CountryListViewModel: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
        case .denied, .restricted: 
            setDefaultCountry(userCountry: "eg") // Default country
        default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        manager.stopUpdatingLocation()
        reverseGeocode(location: location)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let authorizationStatus: CLAuthorizationStatus
           
           // Check the authorization status based on the platform
           if #available(iOS 14.0, *) {
               authorizationStatus = manager.authorizationStatus
           } else {
               authorizationStatus = CLLocationManager.authorizationStatus()
           }
        if authorizationStatus != .notDetermined {
            setDefaultCountry(userCountry: "eg") // Default country
            }
    }

    private func reverseGeocode(location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            guard let self = self, error == nil, let placemark = placemarks?.first else {
                return
            }
            if let isoCode = placemark.isoCountryCode {
                DispatchQueue.main.async {
                    self.setDefaultCountry(userCountry: isoCode)
                }
            }
        }
    }
    private func setDefaultCountry(userCountry: String) {
        if let country = self.getCountryByISOCode(userCountry),
           !self.selectedCountries.contains(where: { $0.name == country.name }) {
            self.selectedCountries = [country]
        }
    }
}
