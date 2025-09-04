//
//  Breed.swift
//  PetFinder
//
//  Created by Kotya on 02/09/2025.
//

struct Breeds: Codable {
    let breeds: [BreedName]
}

struct BreedName: Codable {
    let name: String
}
