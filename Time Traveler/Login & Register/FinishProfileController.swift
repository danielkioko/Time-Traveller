//
//  FinishProfileController.swift
//  Time Traveler
//
//  Created by Daniel Nzioka on 12/3/19.
//  Copyright © 2019 Daniel Nzioka. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class FinishProfileController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var profileImageView: UIImageView!
    @IBAction func selectImage(_ sender: Any) {
        handleSelectProfileImageView()
    }
    
    @IBAction func done(_ sender: Any) {
        uploadImage()
    }
    
    func uploadImage() {
        
        let imageName = UUID().uuidString
        let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).png")
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        if let uploadData = profileImageView.image?.pngData() {
            
            storageRef.putData(uploadData, metadata: nil, completion: { (_, err) in
                
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
                    let values = ["profileImageUrl": url.absoluteString]
                    
                    let ref = Database.database().reference()
                    let userRef = ref.child("users").child(uid)
                    userRef.updateChildValues(values, withCompletionBlock: {(err, ref)
                        in
                        
                        if let err = err {
                            print(err)
                            return
                        }
                        
                        print("Saved user successfully into Firebase DB")
                        
                    })
                    
                    self.registerUserIntoDatabaseWithUID(uid, values: values as [String : AnyObject])
                    
                }
                
            })
            
        }
        
        
    }
    
    fileprivate func registerUserIntoDatabaseWithUID(_ uid: String, values: [String: AnyObject]) {
        
        let ref = Database.database().reference(fromURL: "")
        let usersReference = ref.child("users").child(uid)
        
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if let err = err {
                print(err)
                return
            }
          
            self.dismiss(animated: true, completion: nil)
            
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
            profileImageView.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

}

fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}
