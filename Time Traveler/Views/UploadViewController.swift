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

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var postImageView: UIImageView!
    @IBOutlet var postCaption: UITextField!
    @IBOutlet var postLocation: UITextField!
    
    @IBAction func selectImage(_ sender: Any) {
        handleSelectProfileImageView()
    }
    
    @IBAction func uploadBtn(_ sender: Any) {
        uploadPost()
    }
    
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

                    print("Sucessfully Uploaded!")
                    
                }
                
            })
            
        }
        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}
