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

    init(service: AnimalServiceProtocol = AnimalService(), query: String? = nil) {
        self.service = service

        retrieveAnimals(with: query)
    }

    private func retrieveAnimals(with query: String? = nil) {
        service.fetchInfo(path: Endpoint.animals.rawValue) { [weak self] (result: Result<Animals, Error>) in
            switch result {
            case .success(let animals):
                self?.animals = animals.animals
            case .failure(let error):
                print("Error retrieving animals: \(error)")
            }
        }
    }
}


