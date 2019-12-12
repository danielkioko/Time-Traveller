//
//  PlaceTableCell.swift
//  Time Traveler
//
//  Created by Daniel Nzioka on 12/9/19.
//  Copyright © 2019 Daniel Nzioka. All rights reserved.
//

import UIKit

class PlaceTableCell: UICollectionViewCell {
    
    @IBOutlet weak var placeImage: UIImageView!
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var lineSeparator: UIView!
    @IBOutlet weak var placeLayer: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        placeImage.layer.cornerRadius = 8
        placeName.layer.cornerRadius = placeName.bounds.height / 4
        placeImage.clipsToBounds = true
        placeName.clipsToBounds = true
        lineSeparator.layer.cornerRadius = 0.5
        lineSeparator.layer.backgroundColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
        placeLayer.layer.cornerRadius = 8
        placeLayer.layer.opacity = 0.95
        
    }
    
    func set(place: Place) {
        let placeImgUrl = URL(string: place.placeImage)
        ImageService.getImage(withURL: placeImgUrl!) { image in
            self.placeImage.image = image
        }
        placeName.text = place.placeName
    }
    
}
