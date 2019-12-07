//
//  Post.swift
//  Time Traveler
//
//  Created by Daniel Nzioka on 12/6/19.
//  Copyright © 2019 Daniel Nzioka. All rights reserved.
//

import UIKit

class Post {
    
    var userProfile: UserProfile
    var caption: String
    var location: String
    var image: String
    
    init(userProfile: UserProfile, caption: String, location: String, image: String) {
        self.userProfile = userProfile
        self.caption = caption
        self.location = location
        self.image = image
    }
    
}

