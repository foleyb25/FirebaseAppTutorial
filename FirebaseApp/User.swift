//
//  User.swift
//  FirebaseApp
//
//  Created by Brian Foley on 5/15/20.
//  Copyright © 2020 Brian Foley. All rights reserved.
//

import UIKit

class User: NSObject {
    var userId: String?
    var username: String?
    var email: String?
    var profileURL: String?
    
    init(dictionary: [String: Any]) {
        self.username = dictionary["username"] as? String
        self.email = dictionary["email"] as? String
        self.profileURL = dictionary["profileImage"] as? String
        self.userId = dictionary["userId"] as? String
    }
}
