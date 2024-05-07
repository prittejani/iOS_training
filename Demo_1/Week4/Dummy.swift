//
//  Dummy.swift
//  Webservices
//
//  Created by iMac on 16/04/24.
//

import Foundation

// MARK: - Dummy
struct Dummy: Codable {
    let data: [DataClasses]
    let support: Support
}

// MARK: - DataClass
struct DataClasses: Codable {
    let id: Int
    let email, firstName, lastName: String
    let avatar: String

    enum CodingKeys: String, CodingKey {
        case id, email
        case firstName = "first_name"
        case lastName = "last_name"
        case avatar
    }
}

// MARK: - Support
struct Support: Codable {
    let url: String
    let text: String
}
