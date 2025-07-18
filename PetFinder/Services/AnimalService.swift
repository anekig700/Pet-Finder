//
//  AnimalService.swift
//  PetFinder
//
//  Created by Kotya on 23/04/2025.
//

import Foundation

protocol AnimalServiceProtocol {
    func fetchInfo<T: Decodable>(path: String, completion: @escaping (Result<T, Error>) -> Void)
}

class MockNetworkService: AnimalServiceProtocol {
    var result: Any?

    func fetchInfo<T: Decodable>(path: String, completion: @escaping (Result<T, Error>) -> Void) {
        if let result = result as? T {
            completion(.success(result))
        } else {
            completion(.failure(MockError.decodingFailed))
        }
    }

    enum MockError: Error {
        case decodingFailed
    }
}

enum Endpoint: String {
    case animals = "/v2/animals"
    case organizations = "/v2/organizations"
}

final class AnimalService: AnimalServiceProtocol {
    

    private let baseUrlString = "https://api.petfinder.com"

    private let urlSession: URLSession

    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }

    func fetchInfo<T>(path: String, completion: @escaping (Result<T, any Error>) -> Void) where T : Decodable {
        TokenService.shared.getToken { [weak self] token in
            guard let token = token, let self = self else { return }
            
            guard let url = URL(string: baseUrlString + path) else { return }
            
            var request = URLRequest(url: url)
//            request.setValue("Bearer \(authTokenString)", forHTTPHeaderField: "Authorization")
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

            urlSession.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    completion(.failure(error))
                    print(error)
                }

                do {
                    let returnType = try JSONDecoder().decode(T.self, from: data!)
                    completion(.success(returnType))
                } catch let error {
                    completion(.failure(error))
                }
            }.resume()
        }
    }
}
