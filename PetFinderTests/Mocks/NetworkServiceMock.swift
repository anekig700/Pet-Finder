//
//  MockNetworkService.swift
//  PetFinder
//
//  Created by Kotya on 25/06/2025.
//

import Foundation
@testable import PetFinder

class NetworkServiceMock: AnimalServiceProtocol {
    enum MethodCall: Equatable {
        case retrieveAnimals(path: String)
    }
    
    enum MockError: Error {
        case decodingFailed
    }
    
    var result: Any?
    var calls: [MethodCall] = []
    
    func fetchInfo<T: Decodable>(path: String, completion: @escaping (Result<T, Error>) -> Void) {
        calls.append(.retrieveAnimals(path: path))
        
        if let result = result as? T {
            completion(.success(result))
        } else {
            completion(.failure(MockError.decodingFailed))
        }
    }
}
