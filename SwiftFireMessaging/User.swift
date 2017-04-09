//
//  User.swift
//  SwiftFireMessaging
//
//  Created by Sahil Gangele on 4/6/17.
//  Copyright © 2017 Sahil Gangele. All rights reserved.
//

import UIKit

struct User {
    let username: String
    let email: String
    let imageURL: URL?
    
    func JSONFormat() -> [String: Any] {
        var JSON = [UserKeys.username.rawValue : self.username,
                UserKeys.email.rawValue: self.email]
        if let imageURL = imageURL {
            JSON[UserKeys.imageURL.rawValue] = imageURL.absoluteString
        }
        return JSON
    }
}

enum UserKeys: String {
    case Users
    case email
    case username
    case imageURL
}
