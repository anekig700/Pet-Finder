//
//  AnimalListRouterSpy.swift
//  PetFinder
//
//  Created by Kotya on 25/06/2025.
//

import Foundation
@testable import PetFinder

class AnimalListRouterSpy: AnimalListRouting {
    enum MethodCall {
        case openAnimalDetails
    }
    
    var calls: [MethodCall] = []
    
    func openAnimalDetails(with animal: Animal) {
        calls.append(.openAnimalDetails)
    }
}
