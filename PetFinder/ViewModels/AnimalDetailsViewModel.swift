//
//  AnimalDetailsViewModel.swift
//  PetFinder
//
//  Created by Kotya on 20/05/2025.
//

import Combine
import Foundation

final class AnimalDetailsViewModel: ObservableObject {

    @Published private(set) var organizationViewModelState: OrganizationBasicInfoViewState?
    private(set) var organizationDetails: OrganizationDetails?
    private(set) var animalViewModelState: AnimalDetailsViewState

    private let service: AnimalServiceProtocol

    init(service: AnimalServiceProtocol = AnimalService(), animal: Animal) {
        self.service = service
        self.animalViewModelState = .init(animal: animal)
        retrieveOrganization(id: animal.organization_id)
    }

    private func retrieveOrganization(id: String) {
        service.fetchInfo(path: Endpoint.organizations.rawValue + "/\(id)") { [weak self] (result: Result<OrganizationDetails, Error>) in
            switch result {
            case .success(let organization):
                self?.organizationDetails = organization
                self?.organizationViewModelState = OrganizationBasicInfoViewState(
                    organizationName: self?.organization()?.name ?? "",
                    organizationLogo: self?.organization()?.photos.first?.medium ?? ""
                )
            case .failure(let error):
                print("Error retrieving organization: \(error)")
            }
        }
    }
    
    func organization() -> Organization? {
        guard let organizationDetails = organizationDetails else { return nil }
        return organizationDetails.organization
    }
}


