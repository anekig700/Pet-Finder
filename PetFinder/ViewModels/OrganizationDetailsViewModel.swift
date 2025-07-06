//
//  OrganizationDetailsViewModel.swift
//  PetFinder
//
//  Created by Kotya on 06/07/2025.
//

import Foundation

final class OrganizationDetailsViewModel {
    
    private(set) var animalListVM: AnimalListViewModel
    private(set) var state: OrganizationDetailsViewState

    init(organization: Organization) {
        self.state = .init(organization: organization)
        self.animalListVM = AnimalListViewModel(query: "?organization=\(organization.id)")
    }
}
