//
//  User.swift
//  Time Traveler
//
//  Created by Daniel Nzioka on 12/4/19.
//  Copyright © 2019 Daniel Nzioka. All rights reserved.
//

import Foundation

class UserProfile {
    
    var name: String
    var email: String
    var profileImageUrl: String
    
    init(name: String, email: String, profileImageUrl: String) {
        self.name = name
        self.email = email
        self.profileImageUrl = profileImageUrl
    }
    
}
