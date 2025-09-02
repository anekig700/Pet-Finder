//
//  AnimalSearchViewModel.swift
//  PetFinder
//
//  Created by Kotya on 02/09/2025.
//

import Combine

final class AnimalSearchViewModel: ObservableObject {
    
    @Published private(set) var types: [Type] = []
    
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
    
}
