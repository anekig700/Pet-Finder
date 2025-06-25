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
        guard let url = URL(string: baseUrlString + path) else { return }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(authTokenString)", forHTTPHeaderField: "Authorization")

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
