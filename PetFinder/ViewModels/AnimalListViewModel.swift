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
    @Published var isLoading: Bool = false

    private let service: AnimalServiceProtocol

    init(service: AnimalServiceProtocol = AnimalService(), query: String? = nil) {
        self.service = service

        retrieveAnimals(with: query)
    }

    func retrieveAnimals(with query: String? = nil) {
        
        isLoading = true
        
        service.fetchInfo(path: Endpoint.animals.rawValue + (query ?? "")) { [weak self] (result: Result<Animals, Error>) in
            
            self?.isLoading = false
            
            switch result {
            case .success(let animals):
                self?.animals = animals.animals
            case .failure(let error):
                self?.animals = []
                print("Error retrieving animals: \(error)")
            }
        }
    }
    
    var cellViewModels: [AnimalCellViewModel] {
        animals.map {
            AnimalCellViewModel(
                name: $0.name,
                age: $0.age,
                size: $0.size,
                gender: $0.gender,
                breeds: $0.breeds.primary,
                photo: $0.photos.first?.medium ?? ""
            )
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


