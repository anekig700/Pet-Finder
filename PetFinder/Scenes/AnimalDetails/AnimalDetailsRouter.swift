//
//  AnimalDetailsRouter.swift
//  PetFinder
//
//  Created by Kotya on 24/06/2025.
//

import UIKit

protocol AnimalDetailsRouting {
    func openOrganizationDetails(with organization: Organization)
}

class AnimalDetailsRouter: AnimalDetailsRouting {
    
    private weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func openOrganizationDetails(with organization: Organization) {
        let organizationDetailsVC = OrganizationDetailsViewController(organization: organization)
        navigationController?.pushViewController(organizationDetailsVC, animated: true)
    }
}
