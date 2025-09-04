//
//  AnimalSearchViewModel.swift
//  PetFinder
//
//  Created by Kotya on 02/09/2025.
//

import Combine

final class AnimalSearchViewModel: ObservableObject {
    
    @Published private(set) var types: [Type] = []
    @Published private(set) var breeds: [BreedName] = []
    
    private let service: AnimalServiceProtocol

    init(service: AnimalServiceProtocol = AnimalService()) {
        self.service = service
    }
    
    func didLoadView() {
        service.fetchInfo(path: Endpoint.types.rawValue) { [weak self] (result: Result<Types, Error>) in
            switch result {
            case .success(let types):
                self?.types = types.types
            case .failure(let error):
                print("Error retrieving types: \(error)")
            }
        }
    }
    
    func didSelectAnimalType(_ type: String) {
        service.fetchInfo(path: Endpoint.types.rawValue + "/\(type)/breeds") { [weak self] (result: Result<Breeds, Error>) in
            switch result {
            case .success(let breeds):
                self?.breeds = breeds.breeds
                print("Breeds: \(breeds)")
            case .failure(let error):
                print("Error retrieving breeds: \(error)")
            }
        }
    }
    
    func type(at index: Int) -> Type? {
        guard types.indices.contains(index) else { return nil }
        return types[index]
    }
    
}
