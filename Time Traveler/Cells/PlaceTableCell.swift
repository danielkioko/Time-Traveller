//
//  PlaceTableCell.swift
//  Time Traveler
//
//  Created by Daniel Nzioka on 12/9/19.
//  Copyright © 2019 Daniel Nzioka. All rights reserved.
//

import UIKit

class PlaceTableCell: UICollectionViewCell {
    
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventLocation: UILabel!
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var lineSeparator: UIView!
    @IBOutlet weak var placeLayer: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        eventImage.layer.cornerRadius = 8
        eventName.layer.cornerRadius = eventName.bounds.height / 4
        eventImage.clipsToBounds = true
        eventName.clipsToBounds = true
        lineSeparator.layer.cornerRadius = 0.5
        lineSeparator.layer.backgroundColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
        placeLayer.layer.cornerRadius = 8
        placeLayer.layer.opacity = 0.95
        
    }
    
    func set(place: Place) {
        
        let thumbnailUrl = URL(string: place.eventImage)
        ImageService.getImage(withURL: thumbnailUrl!) {
            image in
            self.eventImage.image = image
        }
        
        eventName.text = place.eventName
        eventLocation.text = place.eventLocation
    }
    
}
