//
//  RegisterController.swift
//  Time Traveler
//
//  Created by Daniel Nzioka on 12/3/19.
//  Copyright © 2019 Daniel Nzioka. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

class RegisterController: UIViewController {
    
    @IBOutlet var name: UITextField!
    @IBOutlet var email: UITextField!
    @IBOutlet var password: UITextField!

    @IBAction func createAccountAction(_ sender: AnyObject) {
      
        if email.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
        
        } else {
            
            guard let emailText = email.text, let passwordText = password.text, let nameText = name.text else {
                print("Form is not valid")
                return
            }
            
            Auth.auth().createUser(withEmail: emailText, password: passwordText) { (user, error) in
                
                if error == nil {
                    
                    guard let uid =  user?.user.uid else {
                        return
                    }
                    
                    let ref = Database.database().reference()
                    let userRef = ref.child("users").child(uid)
                    let values = ["name": nameText, "email": emailText]
                    userRef.updateChildValues(values, withCompletionBlock: { (err, ref) in
                        
                        if let err = err {
                            print(err)
                            return
                        }
                        
                        print("Saved user successfully into Firebase DB")
                        
                    })
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "FinishProfile")
                    self.present(vc!, animated: true, completion: nil)
                    
                } else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
