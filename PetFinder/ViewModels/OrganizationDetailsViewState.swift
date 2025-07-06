//
//  OrganizationDetailsViewState.swift
//  PetFinder
//
//  Created by Kotya on 06/07/2025.
//

import Foundation

struct OrganizationDetailsViewState {
    let name: String
    let description: String?
    let address: String?
    let photo: String
    let email: String?
    let phone: String?
    let website: String?
    
    var shouldShowContactButton: Bool {
        if email != nil || phone != nil {
            return true
        }
        return false
    }
}

extension OrganizationDetailsViewState {
    init(organization: Organization) {
        self.name = organization.name
        self.description = organization.mission_statement
        self.address = organization.address.fullAddress
        self.photo = organization.photos.first?.medium ?? ""
        self.email = organization.email
        self.phone = organization.phone
        self.website = organization.website
    }
}



