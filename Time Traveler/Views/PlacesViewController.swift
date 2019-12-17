//
//  PlacesViewController.swift
//  Time Traveler
//
//  Created by Daniel Nzioka on 12/9/19.
//  Copyright © 2019 Daniel Nzioka. All rights reserved.
//

import UIKit
import Firebase

class PlacesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
        
    let reuseIdentifier = "PlaceCell"
    var places = [Place]()
    var acquiredImageUrls:[String:Any] = [:]
    
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
        layout.itemSize = CGSize(width: 180, height: 275)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        self.collectionView?.collectionViewLayout = layout
        
        
        
        //observeEvents()
        getImages()
        
    }

    func getImages() {

        let imagesRef = Database.database().reference().child("events")
        imagesRef.observe(.value, with: { (snapshot) in

//            var tempImgUrls:[String:Any] = [:]
            for child in snapshot.children {

                let childSnapshot = child as? DataSnapshot
                let dict = childSnapshot?.value as? [String:Any]
                
                let image = dict!["eventImages"] as? [String: AnyObject]
                
//                print(self.acquiredImageUrls)
                
            }

        })

    }
    
    func observeEvents() {
        
        let eventsRef = Database.database().reference().child("events")
        
        eventsRef.observe(.value) { (snapshot) in
            
            var tempEvents = [Place]()
            
            for child in snapshot.children {
                
                if let childSnapshot = child as? DataSnapshot,
                
                    let dict = childSnapshot.value as? [String:Any],
                    let images = dict["eventImages"] as? [String:Any],
                    
                    let eventLocation = dict["eventLocation"] as? String {
                    
                    let event = Place(placeImage: "",
                                      placeName: eventLocation)
                    tempEvents.append(event)
                    self.collectionView.reloadData()
                    
                }
                
            }
            
        }
        
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
