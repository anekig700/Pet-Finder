//
//  AnimalListRouter.swift
//  PetFinder
//
//  Created by Kotya on 23/06/2025.
//

import Foundation
import UIKit

protocol AnimalListRouting {
    func openAnimalDetails(with animal: Animal)
}

class AnimalListRouter: AnimalListRouting {
    
    weak var navigationController: UINavigationController?
    
    func openAnimalDetails(with animal: Animal) {
        guard let navigationController else {
            return
        }
        
        let animalDetailsRouter = AnimalDetailsRouter(navigationController: navigationController)
        let animalDetailsVM = AnimalDetailsVM(animal: animal, router: animalDetailsRouter)
        let animalDetailsVC = AnimalDetailsVC(viewModel: animalDetailsVM)
        
        navigationController.pushViewController(animalDetailsVC, animated: true)
    }
}
