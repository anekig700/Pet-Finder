//
//  AnimalViewControllerViewModel.swift
//  PetFinder
//
//  Created by Kotya on 23/04/2025.
//

import Combine
import Foundation

final class AnimalViewControllerViewModel: ObservableObject {

    @Published var animals: [Animal] = []

    private let service: AnimalServiceProtocol

    init(service: AnimalServiceProtocol = AnimalService()) {
        self.service = service

        retrieveAnimals()
    }

    private func retrieveAnimals() {
        service.fetchAnimals { [weak self] result in
            switch result {
            case .success(let animals):
                self?.animals = animals
            case .failure(let error):
                print("Error retrieving animals: \(error.localizedDescription)")
            }
        }
    }
}


