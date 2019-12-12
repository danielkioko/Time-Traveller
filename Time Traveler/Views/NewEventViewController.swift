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
        
        startUploading {
            "Uploading..."
        }
        
    }
    
    func startUploading(completion: @escaping FileCompletionBlock) {
         if eventImages.count == 0 {
            completion()
            return;
         }

         block = completion
         uploadImage(forIndex: 0)
    }
    
    func uploadImage(forIndex index:Int) {

         if index < eventImages.count {
            let data = eventImages[index].pngData()!
            
            let indexString = String(index)
            let name = eventName.text
            
            let fileName = String(format: "%@.png", "_img_")

              FirFile.shared.upload(data: data, withName: fileName, block: { (url) in
                  /// After successfully uploading call this method again by increment the **index = index + 1**
                  print(url ?? "Couldn't not upload. You can either check the error or just skip this.")
                  self.uploadImage(forIndex: index + 1)
               })
            
            return
          }

          if block != nil {
             block!()
          }
    }

}
