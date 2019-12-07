//
//  UserPostCollectionViewCell.swift
//  Time Traveler
//
//  Created by Daniel Nzioka on 12/7/19.
//  Copyright © 2019 Daniel Nzioka. All rights reserved.
//

import UIKit

class UserPostCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var postImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        postImage.layer.cornerRadius = 8
        postImage.clipsToBounds = true
    }
    
    func set(post: UserPost) {
        let imgUrl = URL(string: post.image)
        let imgData = try? Data(contentsOf: imgUrl!)
        postImage.image = UIImage(data: imgData!)
    }

}
