//
//  MockNetworkService.swift
//  PetFinder
//
//  Created by Kotya on 25/06/2025.
//

import Foundation
@testable import PetFinder

class NetworkServiceMock: AnimalServiceProtocol {
    enum MockError: Error {
        case decodingFailed
    }
    
    var result: Any?
    
    func fetchInfo<T: Decodable>(path: String, completion: @escaping (Result<T, Error>) -> Void) {
        if let result = result as? T {
            completion(.success(result))
        } else {
            completion(.failure(MockError.decodingFailed))
        }
    }
}

//class NetworkServiceStub<R: Decodable>: AnimalServiceProtocol {
//    var fetchInfo_completion: ((Result<R, Error>) -> Void)?
//    
//    func fetchInfo<T: Decodable>(path: String, completion: @escaping (Result<T, Error>) -> Void) where T == R  {
//        fetchInfo_completion = completion
//    }
//}
