//
//  AnimalDetailsViewModel.swift
//  PetFinder
//
//  Created by Kotya on 20/05/2025.
//

import Combine
import Foundation

final class AnimalDetailsViewModel: ObservableObject {

    @Published var organization: OrganizationDetails?

    private let service: AnimalServiceProtocol

    init(service: AnimalServiceProtocol = AnimalService(), id: String) {
        self.service = service

        retrieveOrganization(id: id)
    }

    private func retrieveOrganization(id: String) {
        service.fetchOrganizationInfo(with: id) { [weak self] result in
            switch result {
            case .success(let organization):
                self?.organization = organization
            case .failure(let error):
                print("Error retrieving organization: \(error)")
            }
        }
    }
}


