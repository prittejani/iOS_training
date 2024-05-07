//
//  model.swift
//  Webservices
//
//  Created by iMac on 04/03/24.
//

import Foundation

struct User: Codable {
    let status: Bool
    let statusCode: Int
    let message: String
    let data: [Datum]
}

// MARK: - Datum
struct Datum: Codable {
    let userID: Int
    let name, email: String
    let profilePic: String
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case name, email
        case profilePic = "profile_pic"
        case createdAt = "created_at"
    }
    
}


