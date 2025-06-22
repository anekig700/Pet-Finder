//
//  AnimalListVM.swift
//  PetFinder
//
//  Created by Kotya on 22/06/2025.
//

import Foundation

final class AnimalListVM {
    
    var viewModelDidChange: (() -> Void)?

    private var animals: [Animal] = []
    private let service: AnimalServiceProtocol

    init(service: AnimalServiceProtocol = AnimalService(), query: String? = nil) {
        self.service = service
        
        print("🐱 1) VM -> init")
        retrieveAnimals(with: query)
    }
    
    // alternative approach instead of assigning the body to `viewModelDidChange`
//    func bind(_ viewModelDidChange: @escaping (() -> Void)) {
//        self.viewModelDidChange = viewModelDidChange
//    }

    private func retrieveAnimals(with query: String? = nil) {
        service.fetchInfo(path: Endpoint.animals.rawValue + (query ?? "")) { [weak self] (result: Result<Animals, Error>) in
            switch result {
            case .success(let animals):
                self?.animals = animals.animals
            case .failure(let error):
                self?.animals = []
                print("Error retrieving animals: \(error)")
            }
            
            DispatchQueue.main.async {
                self?.viewModelDidChange?()
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
