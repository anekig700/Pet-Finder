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
    
    var shouldShowDescription: Bool {
        guard let _ = description else { return false }
        return true
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
