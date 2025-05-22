//
//  Organization.swift
//  PetFinder
//
//  Created by Kotya on 20/05/2025.
//

import Foundation

struct OrganizationDetails: Codable {
    let organization: Organization
}

struct Organization: Codable {
    let id: String
    let name: String
    let photos: [Photo]
    let email: String?
    let phone: String?
    let mission_statement: String?
    let website: String?
}
