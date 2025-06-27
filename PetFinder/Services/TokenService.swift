//
//  TokenService.swift
//  PetFinder
//
//  Created by Kotya on 25/06/2025.
//

import Foundation

final class TokenService {
    static let shared = TokenService()
    
    private init() {}
    
    private var token: String?
    private var expirationDate: Date?
    private var refreshTimer: Timer?
    
    private let tokenURL = URL(string: "https://api.petfinder.com/v2/oauth2/token")!
    
    // MARK: - Public API
    
    func start() {
        fetchTokenAndScheduleRefresh()
    }
    
    func getToken(completion: @escaping (String?) -> Void) {
        if let token = token, !token.isEmpty, let expiration = expirationDate, Date() < expiration {
            completion(token)
        } else {
            fetchBearerToken { result in
                switch result {
                case .success(let token):
                    completion(token)
                case .failure(let error):
                    completion(nil)
                    print(error)
                }
            }
        }
    }
    
    // MARK: - Token Fetch
    
    private func fetchBearerToken(completion: @escaping (Result<String, Error>) -> Void) {
        var request = URLRequest(url: tokenURL)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let bodyString = "grant_type=client_credentials&client_id=\(clientID)&client_secret=\(clientSecret)"
        request.httpBody = bodyString.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            if let error = error {
                completion(.failure(error))
                print(error)
                return
            }

            do {
                let tokenResponse = try JSONDecoder().decode(Token.self, from: data!)
                self?.token = tokenResponse.accessToken
                let expiresIn = tokenResponse.expiresIn
                self?.expirationDate = Date().addingTimeInterval(TimeInterval(expiresIn))
                
                self?.scheduleRefresh(after: expiresIn)
                
                completion(.success(tokenResponse.accessToken))
            } catch let error {
                completion(.failure(error))
            }
        }.resume()
    }
    
    // MARK: - Refresh Mechanism
    
    private func fetchTokenAndScheduleRefresh() {
        fetchBearerToken{ _ in }
    }
    
    private func scheduleRefresh(after seconds: Int) {
        refreshTimer?.invalidate()
        
        let interval = max(30, seconds - 60)
        
        DispatchQueue.main.async {
            self.refreshTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(interval), repeats: false) { [weak self] _ in self?.fetchTokenAndScheduleRefresh()
            }
        }
    }
}
