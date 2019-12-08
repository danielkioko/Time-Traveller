//
//  UserService.swift
//  Time Traveler
//
//  Created by Daniel Nzioka on 12/7/19.
//  Copyright © 2019 Daniel Nzioka. All rights reserved.
//

import Foundation
import Firebase

class UserService {
    
    static var currentUserProfile: UserProfile?

    static func observeUserProfile(_ uid:String, completion: @escaping ((_ userProfile: UserProfile?) ->())) {

        let userRef = Database.database().reference().child("users/\(uid)")

        userRef.observe(.value, with: { snapshot in
            var userProfile: UserProfile?

            if let dict = snapshot.value as? [String:Any],
                let name = dict["name"] as? String,
                let email = dict["email"] as? String,
                let imageUrl = dict["profileImageUrl"] as? String {
                userProfile = UserProfile(name: name, email: email, profileImageUrl: imageUrl)
            }
            completion(userProfile)
        })
    }
    
}
