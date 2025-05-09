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
}

struct Breed: Codable {
    let primary: String
}

struct Photo: Codable {
    let medium: String
}
