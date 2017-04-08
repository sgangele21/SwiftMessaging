//
//  User.swift
//  SwiftFireMessaging
//
//  Created by Sahil Gangele on 4/6/17.
//  Copyright © 2017 Sahil Gangele. All rights reserved.
//


struct User {
    let username: String
    let email: String
    
    func JSONFormat() -> [String: Any] {
        return ["username" : self.username, "email": self.email]
    }
}

enum UserKeys: String {
    case Users
    case email
    case username
}
