//
//  Type.swift
//  PetFinder
//
//  Created by Kotya on 02/09/2025.
//

struct Types: Codable {
    let types: [Type]
}

struct Type: Codable {
    let name: String
    let colors: [String]
    let coats: [String]
    let genders: [String]
    
    var propertiesCount: Int {
        return 4
    }
}

