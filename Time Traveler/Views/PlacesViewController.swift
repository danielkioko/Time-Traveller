//
//  PlacesViewController.swift
//  Time Traveler
//
//  Created by Daniel Nzioka on 12/9/19.
//  Copyright © 2019 Daniel Nzioka. All rights reserved.
//

import UIKit

class PlacesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
        
    let reuseIdentifier = "PlaceCell"
    var places = [Place]()
    
    var images = ["portugal", "miami", "erik", "portugal", "miami", "erik", "portugal", "miami", "erik", "portugal", "miami", "erik"]
    var names = ["Daniel", "Nicholas", "Moulinette", "Daniel", "Nicholas", "Moulinette","Daniel", "Nicholas", "Moulinette", "Daniel", "Nicholas", "Moulinette"]
    
    @IBOutlet var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cell = UINib(nibName: "PlaceTableCell", bundle: nil)
        collectionView.register(cell, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 180, height: 90)
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 8
        self.collectionView?.collectionViewLayout = layout
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PlaceTableCell
        cell.placeImage.image = UIImage(named: images[indexPath.row])
        cell.placeName.text = names[indexPath.row]
        return cell
    }
    
}
