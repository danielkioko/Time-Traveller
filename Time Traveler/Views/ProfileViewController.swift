//
//  ProfileViewController.swift
//  Time Traveler
//
//  Created by Daniel Nzioka on 12/3/19.
//  Copyright © 2019 Daniel Nzioka. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var dummyPosts = [UserPost]()
    let reuseIdentifier = "UserPostCell"
    
    var images = ["portugal", "miami", "erik", "portugal", "miami", "erik", "portugal", "miami", "erik", "portugal", "miami", "erik"]
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileUsername: UILabel!
    
    @IBOutlet var collectionView: UICollectionView!
    
    var posts = [UserPost]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cell = UINib(nibName: "UserPostCollectionViewCell", bundle: nil)
        collectionView.register(cell, forCellWithReuseIdentifier: reuseIdentifier)
        let width = UIScreen.main.bounds.width
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (width / 2) - 25, height: (width / 2) - 25)
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 8
        self.collectionView?.collectionViewLayout = layout
        
        //fetchUser()
        //fetchPosts()
        self.profileImage.image = UIImage(named: "erik")
    }
    
    func fetchPosts() {
        
        let postsRef = Database.database().reference().child("posts")
        
        postsRef.observe(.value, with: { snapshot in
            
            var tempPosts = [UserPost]()
            
            for child in snapshot.children {
                
                if let childSnapshot = child as? DataSnapshot,
                    
                    let dict = childSnapshot.value as? [String:Any],
                    let image = dict["postImageUrl"] as? String {
                    let post = UserPost(image: image)
                    tempPosts.append(post)
                }
            }
            self.posts = tempPosts
            self.collectionView.reloadData()
            
        })
        
    }
    
    func fetchUser() {
        
        let uid = Auth.auth().currentUser?.uid
        let userRef = Database.database().reference().child("users")
        
        userRef.observe(.value, with : { snapshot in
            
            for child in snapshot.children {
                
                if let childSnapshot = child as? DataSnapshot,
                
                    let dict = childSnapshot.value as? [String:Any],
                    let name = dict["name"] as? String,
                    let profilePhoto = dict["profileImageUrl"] as? String {
                    
                    if childSnapshot.key == uid {
                        let imgUrl = URL(string: profilePhoto)
                        
                        ImageService.getImage(withURL: imgUrl!) {
                            image in
                            self.profileImage.image = image
                        }
                        
                        self.profileName.text = name
                    }
                    
                }
                    
                
            }
            
            self.profileImage.image = UIImage(named: "erik")
            
        })
        
        self.profileImage.layer.cornerRadius = profileImage.bounds.height / 2
        self.profileImage.clipsToBounds = true
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! UserPostCollectionViewCell
        //cell.set(post: posts[indexPath.row])
        cell.postImage.image = UIImage(named: images[indexPath.row])
        return cell
    }

}
