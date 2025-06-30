//
//  AnimalCellViewModel.swift
//  PetFinder
//
//  Created by Kotya on 19/06/2025.
//

import Foundation


struct AnimalCellViewModel {
    let name: String
    let age: String
    let size: String
    let gender: String
    let breeds: String
    let photo: String
}

extension AnimalCellViewModel {
    init(animal: Animal) {
        self.init(
            name: animal.name,
            age: animal.age,
            size: animal.size,
            gender: animal.gender,
            breeds: animal.breeds.primary,
            photo: animal.photos.first?.medium ?? ""
        )
        
//        self.name = animal.name
//        self.age = animal.age
//        self.size = animal.size
//        self.gender = animal.gender
//        self.breeds = animal.breeds.primary
//        self.photo = animal.photos.first?.medium ?? ""
    }
}
