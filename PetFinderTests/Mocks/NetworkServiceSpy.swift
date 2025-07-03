//
//  NetworkServiceSpy.swift
//  PetFinder
//
//  Created by Kotya on 01/07/2025.
//

import Foundation
@testable import PetFinder

class NetworkServiceSpy: AnimalServiceProtocol {
    enum MethodCall: Equatable {
        case retrieveAnimals(path: String)
    }
    
    var calls: [MethodCall] = []
    
    func fetchInfo<T>(path: String, completion: @escaping (Result<T, any Error>) -> Void) where T : Decodable {
        calls.append(.retrieveAnimals(path: path))
    }
}
