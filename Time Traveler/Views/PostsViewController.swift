//
//  PostsViewController.swift
//  Time Traveler
//
//  Created by Daniel Nzioka on 12/3/19.
//  Copyright © 2019 Daniel Nzioka. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "PostCell"

class PostsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var images = ["portugal", "miami", "erik", "portugal", "miami", "erik", "portugal", "miami", "erik", "portugal", "miami", "erik"]
    var names = ["Daniel", "Nicholas", "Moulinette", "Daniel", "Nicholas", "Moulinette","Daniel", "Nicholas", "Moulinette", "Daniel", "Nicholas", "Moulinette"]
    var userImages = ["nicholas", "daniel", "nicholas", "daniel", "nicholas", "daniel", "nicholas", "daniel", "nicholas", "daniel", "nicholas", "daniel"]
    
    @IBOutlet var tableView: UITableView!
    
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cell = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.register(cell, forCellReuseIdentifier: reuseIdentifier)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
       // observePosts()

    }

    func observePosts() {
        
        let postsRef = Database.database().reference().child("posts")
        
        postsRef.observe(.value, with: { snapshot in
            
            var tempPosts = [Post]()
            
            for child in snapshot.children {
                
                if let childSnapshot = child as? DataSnapshot,
                    
                    let dict = childSnapshot.value as? [String:Any],
                    
                    let author = dict["author"] as? [String:Any],
                    let name = author["name"] as? String,
                    let email = author["email"] as? String,
                    let profilePhoto = author["profileImageUrl"] as? String,
                    
                    let caption = dict["caption"] as? String,
                    let location = dict["location"] as? String,
                    let image = dict["postImageUrl"] as? String {
                    
                    let userProfile = UserProfile(name: name, email: email, profileImageUrl: profilePhoto)
                    let post = Post(userProfile: userProfile, caption: caption, location: location, image: image)
                    tempPosts.append(post)
                }
            }
            self.posts = tempPosts
            self.tableView.reloadData()
            
        })
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! PostTableViewCell
        //cell.set(post: posts[indexPath.row])
        cell.postImage.image = UIImage(named: images[indexPath.row])
        cell.userImage.image = UIImage(named: userImages[indexPath.row])
        cell.usernameLabel.text = names[indexPath.row]
        return cell
    }
    
}
