//
//  AnimalService.swift
//  PetFinder
//
//  Created by Kotya on 23/04/2025.
//

import Foundation

protocol AnimalServiceProtocol {
    func fetchAnimals(completion: @escaping (Result<[Animal], Error>) -> Void)
}

final class AnimalService: AnimalServiceProtocol {

    enum Endpoint: String {
        case animals = "/animals"
    }

    private let baseUrlString = "https://api.petfinder.com/v2"

    private let urlSession: URLSession

    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }

    func fetchAnimals(completion: @escaping (Result<[Animal], Error>) -> Void) {
        guard let url = URL(string: baseUrlString + Endpoint.animals.rawValue) else { return }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(authTokenString)", forHTTPHeaderField: "Authorization")

        urlSession.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                print(error)
            }

            do {
                let animals = try JSONDecoder.animalDecoder().decode(Animals.self, from: data!).animals
                print(animals)
            } catch let error {
                completion(.failure(error))
            }
        }.resume()
    }
}

extension JSONDecoder {
    static func animalDecoder() -> JSONDecoder {
        JSONDecoder()
    }
}
