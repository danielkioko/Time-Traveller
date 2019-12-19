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
    var acquiredImageUrls:[String] = []
    
    @IBOutlet var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cell = UINib(nibName: "PlaceTableCell", bundle: nil)
        collectionView.register(cell, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 180, height: 275)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        self.collectionView?.collectionViewLayout = layout
        
        observeEvents()
        getImages()
        
    }

    func getImages() {

        let imagesRef = Database.database().reference().child("events")
        imagesRef.observe(.value, with: { (snapshot) in

            for child in snapshot.children {

                if let childSnapshot = child as? DataSnapshot,
                
                    let dict = childSnapshot.value as? [String:Any],
                    let image = dict["eventImages"] as? [String] {
                    self.acquiredImageUrls = image
                }
                print(self.acquiredImageUrls)
                
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
                    
                    let author = dict["author"] as? [String:Any],
                    let name = author["name"] as? String,
                    
                    let eventImage = dict["thumbnail"] as? String,
                    let eventName = dict["eventName"] as? String,
                    let eventLocation = dict["eventLocation"] as? String {
                    let event = Place(eventImage: eventImage, eventName: eventName, eventLocation: eventLocation)
                    tempEvents.append(event)
                    self.collectionView.reloadData()
                    
                }
                
            }
            
            
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        places.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PlaceTableCell
        cell.set(place: places[indexPath.row])
        return cell
    }
    
}
