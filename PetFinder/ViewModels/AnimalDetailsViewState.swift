//
//  AnimalDetailsViewState.swift
//  PetFinder
//
//  Created by Kotya on 30/06/2025.
//

import Foundation

struct AnimalDetailsViewState {
    let name: String
    let description: String?
    let address: String?
    let photos: [Photo]
    let email: String?
    let phone: String?
    
    var shouldShowDescription: Bool {
        guard let _ = description else { return false }
        return true
    }
    
    var shouldShowContactButton: Bool {
        if email != nil || phone != nil {
            return true
        }
        return false
    }
    
    var photosCount: Int {
        return photos.count
    }
    
}

extension AnimalDetailsViewState {
    init(animal: Animal) {
        self.name = animal.name
        self.description = animal.description
        self.address = animal.contact.address.fullAddress
        self.photos = animal.photos
        self.email = animal.contact.email
        self.phone = animal.contact.phone
    }
}

struct OrganizationBasicInfoViewState {
    var organizationName: String
    var organizationLogo: String
            
//    var shouldShowOrganizationDetails: Bool {
//        guard let _ = organizationName else { return false }
//        return true
//    }
}
