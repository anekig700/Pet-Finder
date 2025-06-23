//
//  AnimalDetailsVM.swift
//  PetFinder
//
//  Created by Kotya on 23/06/2025.
//

import Foundation

final class AnimalDetailsVM {

    private(set) var organizationDetails: OrganizationDetails?
    private(set) var animal: Animal

    private let service: AnimalServiceProtocol

    init(service: AnimalServiceProtocol = AnimalService(), animal: Animal) {
        self.service = service
        self.animal = animal
    }
    
    var viewModelDidChange: (() -> Void)?

    private func retrieveOrganization(id: String) {
        service.fetchInfo(path: Endpoint.organizations.rawValue + "/\(id)") { [weak self] (result: Result<OrganizationDetails, Error>) in
            switch result {
            case .success(let organization):
                self?.organizationDetails = organization
                DispatchQueue.main.async {
                    self?.viewModelDidChange?()
                }
            case .failure(let error):
                print("Error retrieving organization: \(error)")
            }
        }
    }
    
    func organization() -> Organization? {
        guard let organizationDetails = organizationDetails else { return nil }
        return organizationDetails.organization
    }
    
    func viewDidLoad() {
        retrieveOrganization(id: animal.organization_id)
    }
}
