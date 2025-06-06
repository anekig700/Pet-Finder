//
//  AnimalListViewModel.swift
//  PetFinder
//
//  Created by Kotya on 23/04/2025.
//

import Combine
import Foundation

final class AnimalListViewModel: ObservableObject {

    @Published private(set) var animals: [Animal] = []

    private let service: AnimalServiceProtocol

    init(service: AnimalServiceProtocol = AnimalService(), query: String? = nil) {
        self.service = service

        retrieveAnimals(with: query)
    }

    func retrieveAnimals(with query: String? = nil) {
        service.fetchInfo(path: Endpoint.animals.rawValue) { [weak self] (result: Result<Animals, Error>) in
            switch result {
            case .success(let animals):
                self?.animals = animals.animals
            case .failure(let error):
                self?.animals = []
                print("Error retrieving animals: \(error)")
            }
        }
    }
    
    func numberOfAnimals() -> Int {
        animals.count
    }
    
    func animal(at index: Int) -> Animal? {
        guard animals.indices.contains(index) else { return nil }
        return animals[index]
    }
    
}


