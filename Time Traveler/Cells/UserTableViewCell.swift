//
//  UserTableViewCell.swift
//  Time Traveler
//
//  Created by Daniel Nzioka on 12/13/19.
//  Copyright © 2019 Daniel Nzioka. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var email: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImage.layer.cornerRadius = profileImage.bounds.height / 2
        profileImage.clipsToBounds = true
        
    }
    
    func set(user: UserProfile) {
        let imgUrl = URL(string: user.profileImageUrl)
        ImageService.getImage(withURL: imgUrl!) { (image) in
            self.profileImage.image = image
        }
        name.text = user.name
        email.text = user.email
    }
    
}
