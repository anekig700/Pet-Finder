//
//  UIViewController+MapLauncher.swift
//  PetFinder
//
//  Created by Kotya on 16/06/2025.
//

import UIKit
import CoreLocation
import MapKit

extension UIViewController {
    func geocodeAndOpenInMaps(_ address: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { placemarks, error in
            guard
                let placemark = placemarks?.first,
                let location = placemark.location
            else {
                print("❌ Geocoding failed")
                return
            }

            let mapPlacemark = MKPlacemark(coordinate: location.coordinate, addressDictionary: nil)
            let mapItem = MKMapItem(placemark: mapPlacemark)
            mapItem.name = address

            mapItem.openInMaps(launchOptions: [
                MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
            ])
        }
    }
}
