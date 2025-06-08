//
//  MKMapView+Map.swift
//  PetFinder
//
//  Created by Kotya on 08/06/2025.
//

import MapKit

extension MKMapView {
    func showAddressOnMap(_ address: String?) {
        guard let address = address else { return }
        let geocoder = CLGeocoder()
            
        geocoder.geocodeAddressString(address) { [weak self] placemarks, error in
            guard let self = self else { return }
                
            if let error = error {
                print("Geocoding failed: \(error.localizedDescription)")
                return
            }
                
            guard let placemark = placemarks?.first,
                let location = placemark.location else {
                print("No matching location found")
                return
            }
                
            let coordinate = location.coordinate
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = address
                
            DispatchQueue.main.async {
                self.addAnnotation(annotation)
                self.setRegion(
                MKCoordinateRegion(
                    center: coordinate,
                    latitudinalMeters: 1000,
                    longitudinalMeters: 1000
                ),
                animated: true
                )
            }
        }
    }
}
