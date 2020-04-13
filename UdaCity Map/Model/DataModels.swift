//
//  DataModels.swift
//  UdaCity Map
//
//  Created by Abdalfattah Altaeb on 4/13/20.
//  Copyright © 2020 Abdalfattah Altaeb. All rights reserved.
//

import Foundation

struct Credentials: Codable {
    let username: String
    let password: String

    init(username: String, password: String) {
        self.username = username
        self.password = password
    }
}

struct LoginData: Codable {
    let udacity: Credentials

    init(credentials: Credentials) {

        self.udacity = credentials
    }
}

struct UserSession : Codable {
    let account: Account
    let session: Session
}

struct UserResponse: Codable {
    let user:User
}
struct User: Codable {
    let lastName: String
    let firstName: String

    enum CodingKeys : String, CodingKey {
        case lastName = "last_name"
        case firstName = "first_name"
    }

    init(firstName: String, lastName: String) {
        self.firstName = firstName
        self.lastName = lastName
        print("fn",self.firstName)
        print("ln",self.lastName)
    }
}

struct DeleteSession: Codable {
    let session: Session
}

struct Account : Codable {
    let registered: Bool
    let key : String
}

struct Session : Codable {
    let id: String
    let expiration: String

    enum CodingKeys : String, CodingKey {
        case id = "id"
        case expiration = "expiration"
    }
}

struct StudentLocations: Codable {
    let results: [StudentInformation]
}

struct PostLocation: Codable {
    let createdAt: String
    let objectId: String
}

struct PutLocation: Codable {
    let updatedAt: String
}

struct StudentInformation: Codable {
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let updatedAt: String
    let latitude: Double
    let longitude: Double

    init (dictionary: [String:Any]) {
        self.uniqueKey = dictionary["key"] as? String ?? ""
        self.firstName = dictionary["firstName"] as? String ?? ""
        self.lastName = dictionary["lastName"] as? String ?? ""
        self.mapString = dictionary["mapString"] as? String ?? ""
        self.mediaURL = dictionary["mediaURL"] as? String ?? ""
        self.updatedAt = dictionary["updatedAt"] as? String ?? ""
        self.latitude = dictionary["latitude"] as? Double ?? 0.0
        self.longitude = dictionary["longitude"]as? Double ?? 0.0
    }

}
