//
//  FindUsersViewController.swift
//  Time Traveler
//
//  Created by Daniel Nzioka on 12/3/19.
//  Copyright © 2019 Daniel Nzioka. All rights reserved.
//

import UIKit
import Firebase

class FindUsersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var users = [UserProfile]()
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cell = UINib(nibName: "UserTableViewCell", bundle: nil)
        tableView.register(cell, forCellReuseIdentifier: "UserCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        observeUsers()

    }

    func observeUsers() {
        
        let profileRef = Database.database().reference().child("users")
        profileRef.observe(.value) { (snapshot) in
            
            var usersInfo = [UserProfile]()
            
            for child in snapshot.children {
                
                if let childSnapshot = child as? DataSnapshot,
                
                let dict = childSnapshot.value as? [String:Any],
                
                let name = dict["name"] as? String,
                let email = dict["email"] as? String,
                let image = dict["profileImageUrl"] as? String {
                    
                let userProfile = UserProfile(name: name,
                                              email: email,
                                              profileImageUrl: image)
                usersInfo.append(userProfile)
                }
            }
            self.users = usersInfo
            print(self.users)
            self.tableView.reloadData()
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserTableViewCell
        cell.set(user: users[indexPath.row])
        return cell
    }

}
