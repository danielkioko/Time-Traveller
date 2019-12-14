//
//  NewEventViewController.swift
//  Time Traveler
//
//  Created by Daniel Nzioka on 12/12/19.
//  Copyright © 2019 Daniel Nzioka. All rights reserved.
//

import UIKit
import Photos
import Firebase
import Foundation
import CoreLocation
import BSImagePicker

class NewEventViewController: UIViewController, CLLocationManagerDelegate {
    
    var imageUrls:[String] = []
    var eventReference: DatabaseReference?
    
    let locationManager = CLLocationManager()
    var locationString: String?
    
    @IBOutlet var eventName: UITextField!
    @IBOutlet var imageView: UIImageView!
    
    var imageAssets = [PHAsset]()
    var eventImages = [UIImage]()
    
    typealias FileCompletionBlock = () -> Void
    var block: FileCompletionBlock?
    
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
    
    func fetchCityAndCountry(from location: CLLocation, completion: @escaping (_ city: String?, _ Country: String?, _ erro: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) {
            placemarks, error in
            completion(placemarks?.first?.locality,
                       placemarks?.first?.country,
                       error)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocation = manager.location else { return }
        fetchCityAndCountry(from: location) { (city, country, error) in
            guard let city = city, let country = country, error == nil else {
                return
            }
            self.locationString = (city + ", " + country)
        }
    }
    
    @IBAction func selectPhotos(_ sender:Any) {
        
        let vc = BSImagePickerViewController()
        self.bs_presentImagePickerController(
            vc,
            animated: true,
            select: { (asset: PHAsset) -> Void in
                
        }, deselect: { (asset: PHAsset) -> Void in
            
        }, cancel: { (assets: [PHAsset]) -> Void in
        
        }, finish: { (assets: [PHAsset]) -> Void in
            for i in 0..<assets.count
            {
                self.imageAssets.append(assets[i])
            }
            self.convertImagesToAssets()
        }, completion: nil)
        
    }
    
    func convertImagesToAssets()  -> Void {
        
        if imageAssets.count != 0 {
            
            for i in 0..<imageAssets.count {
            
                let manager = PHImageManager.default()
                let option = PHImageRequestOptions()
                var thumbnail = UIImage()
                option.isSynchronous = true
                
                manager.requestImage(for: imageAssets[i],
                                     targetSize: CGSize(width: 200, height: 200),
                                     contentMode: .aspectFill,
                                     options: option,
                                     resultHandler: { (result, info)-> Void in
                                        thumbnail = result!
                })
                
                let data = thumbnail.jpegData(compressionQuality: 0.7)
                let newImage = UIImage(data: data!)
                
                //Upload To Firebase
                
                self.eventImages.append(newImage! as UIImage)
                
            }
            
            self.imageView.animationImages = self.eventImages
            self.imageView.animationDuration = 3.0
            self.imageView.startAnimating()
            
        }
        
        print("complete photo array \(self.eventImages)")
        
    }
    
    @IBAction func done(_ sender:Any) {
        uploadEventData()
    }
    
    func uploadEventData() {
                        
        guard let userProfile = UserService.currentUserProfile else { return }
                        
        let eventObject = [
            "author" : [
                "name" : userProfile.name,
                "email" : userProfile.email,
                "profileImageUrl":  userProfile.profileImageUrl
            ],
            "eventName": self.eventName.text!,
            "eventLocation": self.locationString!,
            "timestamp": [".sv":"timestamp"]
        ] as [String : Any]
                        
        let eventRef = Database.database().reference().child("events").childByAutoId()
        eventRef.updateChildValues(eventObject, withCompletionBlock: {(err, ref) in
            
            if let err = err {
                print(err)
                return
            }
            self.eventReference = eventRef
            
        })
        
        print("Data Uploaded")
        uploadEventAssets()
                                                
    }
    
    func uploadEventAssets() {
        
        var i = 0
        
        while i < eventImages.count {
            
            let imageName = UUID().uuidString
            let storageRef = Storage.storage().reference().child("event_images").child("\(imageName)" + "_" + String(i) + ".png")
                
            if let uploadData = eventImages[i].pngData() {
                
                storageRef.putData(uploadData, metadata: nil) { (_, err) in
                    
                    if let error = err {
                        print(error)
                        return
                    }
                    
                    storageRef.downloadURL { (url, err) in
                        
                        if let err = err {
                            print(err)
                        }
                        
                        guard let url = url else { return }
                        self.imageUrls.append(url.absoluteString)
                        self.uploadImageArray()
                        //print("Showing image urls")
                        //print(self.imageUrls)
                        
                    }
                    
                }
                
            }
            
            i += 1
        }
    }
    
    func uploadImageArray () {
        
        let values = ["eventImages": self.imageUrls]
        
        self.eventReference?.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if let err = err {
                print(err)
                return
            }
            
            print("Saved images successfully into Firebase DB")
            
        })
        
    }
    
}
