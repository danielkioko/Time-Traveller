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
    let headerIdentifier = "Header"
    var emailString = ""
    
    var images = ["portugal", "miami", "erik", "portugal", "miami", "erik", "portugal", "miami", "erik", "portugal", "miami", "erik"]
    
    var importedImages:[String] = []
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileUsername: UILabel!
    
    @IBOutlet var collectionView: UICollectionView!
    
    var posts = [UserPost]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchImages()
        
        let headerCell = UINib(nibName: "HeaderViewCell", bundle: nil)
        collectionView.register(headerCell, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        
        //Post Cells
        let cell = UINib(nibName: "UserPostCollectionViewCell", bundle: nil)
        collectionView.register(cell, forCellWithReuseIdentifier: reuseIdentifier)
        
        let width = UIScreen.main.bounds.width
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (width / 2) - 25, height: (width / 2) - 25)
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 8
        layout.headerReferenceSize = CGSize(width: 340, height: 180)
        self.collectionView?.collectionViewLayout = layout
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        
        //fetchUser()
        //self.profileImage.image = UIImage(named: "erik")
    }
    
    func fetchImages() {
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let userRef = Database.database().reference().child("users").child(uid).child("email")
        
        let postRef = Database.database().reference().child("posts")
        
        var tempPosts = [UserPost]()
        
        var leMail:String?
        
        let profileRef = Database.database().reference().child("users")
        profileRef.observe(.value) { (snapshot) in
            
            for child in snapshot.children {
                
                if let childSnapshot = child as? DataSnapshot,
                let dict = childSnapshot.value as? [String:Any],

                let email = dict["email"] as? String {
                    leMail = email
                    //print(leMail)
                }
                
                print(leMail ?? "")
            }
        }
        
        postRef.observe(.value, with: { (snapshot) in
                        
            for child in snapshot.children {
                
                if let childSnapshot = child as? DataSnapshot,
                                        
                    let dict = childSnapshot.value as? [String:Any],
                    let author = dict["author"] as? [String:Any],
                    let email = author["email"] as? String,
                    
                    let image = dict["postImageUrl"] as? String  {
                    
                    if (email != leMail) {
                        let post = UserPost(image: image)
                        tempPosts.append(post)
//                        print("POSTS HERE")
//                        print(tempPosts)
                    }
                    
                }
                
                self.posts = tempPosts
                self.collectionView.reloadData()
                
            }
            
        })
        
        //print(self.importedImages)
        
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
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let supplementary = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier, for: indexPath) as? HeaderViewCell {
            supplementary.backgroundColor = UIColor.white
            supplementary.name.text = "Daniel Kioko"
            supplementary.location.text = "Elk Grove, CA"
            
            return supplementary
        }
        fatalError("Unable to Deque Reusable Supplementary View")
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! UserPostCollectionViewCell
        cell.set(post: posts[indexPath.row])
//        cell.postImage.image = UIImage(named: importedImages[indexPath.row])
        return cell
    }

}
