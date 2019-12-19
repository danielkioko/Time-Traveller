//
//  HeaderViewCell.swift
//  Time Traveler
//
//  Created by Daniel Nzioka on 12/19/19.
//  Copyright © 2019 Daniel Nzioka. All rights reserved.
//

import UIKit

class HeaderViewCell: UICollectionViewCell {
    
    @IBOutlet var profilePhoto: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var location: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        profilePhoto.layer.cornerRadius = 8
        profilePhoto.clipsToBounds = true
        
    }

}
