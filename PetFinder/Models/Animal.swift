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
}
