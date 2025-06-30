//
//  AnimalListVM.swift
//  PetFinder
//
//  Created by Kotya on 22/06/2025.
//

import Foundation

final class AnimalListVM {
        
    private var animals: [Animal] = []
    private let service: AnimalServiceProtocol
    private let query: String?
    private let router: AnimalListRouting
    
    init(service: AnimalServiceProtocol = AnimalService(), query: String? = nil, router: AnimalListRouting) {
        self.service = service
        self.query = query
        self.router = router
    }
    
    // MARK: - Public
    var viewModelDidChange: (() -> Void)?
    
    // alternative approach instead of assigning the body to `viewModelDidChange`
//    func bind(_ viewModelDidChange: @escaping (() -> Void)) {
//        self.viewModelDidChange = viewModelDidChange
//    }
    
    var cellViewModels: [AnimalCellViewModel] {
//        animals.map { AnimalCellViewModel(animal: $0) }
        animals.map(AnimalCellViewModel.init(animal:))
    }
    
    func viewDidLoad() {
        retrieveAnimals(with: query)
    }
    
    func numberOfAnimals() -> Int {
        animals.count
    }
    
    func animalCellDidTap(at index: Int) {
        guard let selectedAnimal = animal(at: index) else {
            return
        }
        router.openAnimalDetails(with: selectedAnimal)
    }
    
    // MARK: - Private
    private func animal(at index: Int) -> Animal? {
        guard animals.indices.contains(index) else { return nil }
        return animals[index]
    }
    
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
    
}
