//
//  PostTableViewCell.swift
//  Time Traveler
//
//  Created by Daniel Nzioka on 12/6/19.
//  Copyright © 2019 Daniel Nzioka. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var postImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        userImage.layer.cornerRadius = 6
        postImage.layer.cornerRadius = 6
        //Makes userImage Round
//        userImage.layer.cornerRadius = userImage.bounds.height / 2
        userImage.clipsToBounds = true
        postImage.clipsToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func set(post: Post) {
        
        usernameLabel.text = post.userProfile.name
        
        let profileImageUrl = URL(string: post.userProfile.profileImageUrl)
        ImageService.getImage(withURL: profileImageUrl!) {
            image in
            self.userImage.image = image
        }
        
        let url = URL(string: post.image)
        ImageService.getImage(withURL: url!) {
            image in
            self.postImage.image = image
        }
        
    }
    
}
