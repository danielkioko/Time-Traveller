//
//  PlaceTableCell.swift
//  Time Traveler
//
//  Created by Daniel Nzioka on 12/9/19.
//  Copyright © 2019 Daniel Nzioka. All rights reserved.
//

import UIKit

class PlaceTableCell: UICollectionViewCell {
    
    @IBOutlet var placeImage: UIImageView!
    @IBOutlet var placeName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        placeImage.layer.cornerRadius = 8
        placeName.layer.cornerRadius = placeName.bounds.height / 4
        placeImage.clipsToBounds = true
        placeName.clipsToBounds = true
        
    }
    
    func set(place: Place) {
        let placeImgUrl = URL(string: place.placeImage)
        ImageService.getImage(withURL: placeImgUrl!) { image in
            self.placeImage.image = image
        }
        placeName.text = place.placeName
    }
    
}
