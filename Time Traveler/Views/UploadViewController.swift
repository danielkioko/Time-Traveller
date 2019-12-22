//
//  ViewController.swift
//  Time Traveler
//
//  Created by Daniel Nzioka on 12/4/19.
//  Copyright © 2019 Daniel Nzioka. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import CoreLocation

class UploadViewController: UIViewController, CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
    let locationManager = CLLocationManager()
    var urlArray:[String] = []
    
    var temporaryPostRef = ""
    
    @IBOutlet var postImageView: UIImageView!
    @IBOutlet var postCaption: UITextField!
    @IBOutlet var postLocation: UITextField!
    
    var locationString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
           if CLLocationManager.locationServicesEnabled() {
               locationManager.delegate = self
               locationManager.desiredAccuracy = kCLLocationAccuracyBest
               locationManager.startUpdatingLocation()
           }
    }
    
    @IBAction func selectImage(_ sender: Any) {
        handleSelectProfileImageView()
    }
    
    func fetchCityAndCountry(from location: CLLocation, completion: @escaping (_ city: String?, _ Country: String?, _ erro: Error?) ->()){
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            completion(placemarks?.first?.locality,
                       placemarks?.first?.country,
                       error)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocation = manager.location else { return }
        fetchCityAndCountry(from: location) { city, country, error in
            guard let city = city, let country = country, error == nil else { return }
            print(city + ", " + country)
            self.locationString = (city + ", " + country)
            self.postLocation.text = (city + ", " + country)
        }
    }
    
    @IBAction func uploadBtn(_ sender: Any) {
        uploadPost()
    }
    
//    func downloadPostArray() {
//
//        guard let uid = Auth.auth().currentUser?.uid else {
//            return
//        }
//
//        let ref = Database.database().reference().child("users").child(uid)
//        ref.observe(.value) { (snapshot) in
//
//            for child in snapshot.children {
//
//                if let childSnapshot = child as? DataSnapshot,
//                    let dict = childSnapshot.value as? [String:Any],
//                    let postUrls = dict["posts"] as? [String] {
//
//                    self.urlArray = postUrls
//
//                }
//
//
//            }
//
//        }
//
//        print("THIS IS THE ARRAY")
//        print(self.urlArray)
//
//    }

    func uploadPost() {
        
        let imageName = UUID().uuidString
        let storageRef = Storage.storage().reference().child("post_images").child("\(imageName).png")
        
        if let uploadData = postImageView.image?.pngData() {
            
            storageRef.putData(uploadData, metadata: nil, completion: {(_, err) in
                
                if let error = err {
                    print(error)
                    return
                }
                
                storageRef.downloadURL { (url, err) in
                    
                    if let err = err {
                        print(err)
                        return
                    }
                    
                    guard let url = url else { return }
                    
                    guard let userProfile = UserService.currentUserProfile else { return }
                    
                    let postObject = [
                        "author" : [
                            "name" : userProfile.name,
                            "email" : userProfile.email,
                            "profileImageUrl":  userProfile.profileImageUrl
                        ],
                        "postImageUrl": url.absoluteString,
                        "caption": self.postCaption.text!,
                        "location": self.postLocation.text!,
                        "timestamp": [".sv":"timestamp"]
                        ] as [String : Any]
                    
                    let ref = Database.database().reference()
                    let postRef = ref.child("posts").childByAutoId()
                    
                    postRef.updateChildValues(postObject, withCompletionBlock: { (err, ref) in
                        if let err = err {
                            print(err)
                            return
                        }
                    })
                    

                    print("This is the post UID")
                    print(postRef.key)
                    self.temporaryPostRef = postRef.key!

                    print("Sucessfully Uploaded!")
                    
                    self.updateUsersPostsList()
                    
                    let placeRef = Database.database().reference().child("locations")
                    
                    let postUID = postRef
                    let values = [
                        "locationName": self.locationString!
                    ]
                    
                    placeRef.updateChildValues(values) { (err, ref) in
                        
                        if let err = err {
                            print(err)
                            return
                        }
                        
                        print("Location Info Added")
                        
                    }
                    
                }
                
            })
            
        }
        
    }
    
    func updateUsersPostsList() {
        
       // downloadPostArray()
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let ref = Database.database().reference().child("users").child(uid)
        
        self.urlArray.append(temporaryPostRef)
        
        let value = ["posts": self.urlArray]
        
        ref.updateChildValues(value, withCompletionBlock: { (err, ref) in
            if let err = err {
                print(err)
                return
            }
            print("Post Listed")
        })
        
    }
    
    @objc func handleSelectProfileImageView() {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            postImageView.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }
    
}

fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}
