//
//  Animal.swift
//  PetFinder
//
//  Created by Kotya on 23/04/2025.
//

import Foundation

struct Animals: Codable {
    let animals: [Animal]
}

struct Animal: Codable {
    let id: Int
    let name: String
    let age: String
    let size: String
    let gender: String
    let breeds: Breed
    let photos: [Photo]
    let description: String?
    let contact: Contact
    let organization_id: String
}

struct Breed: Codable {
    let primary: String
}

struct Photo: Codable {
    let medium: String
}

struct Contact: Codable {
    let email: String?
    let phone: String?
    let address: Address
}

struct Address: Codable {
    let city: String?
    let state: String?
    let postcode: String?
    
    var fullAddress: String? {
        if let city = city,
           let state = state,
           let postcode = postcode
        {
            return "\(city), \(state), \(postcode)"
        } else {
            return nil
        }
    }
}
