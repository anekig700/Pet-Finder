//
//  Token.swift
//  PetFinder
//
//  Created by Kotya on 25/06/2025.
//

struct Token: Codable {
    let accessToken: String
    let expiresIn: Int
    let tokenType: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expiresIn = "expires_in"
        case tokenType = "token_type"
    }
}
