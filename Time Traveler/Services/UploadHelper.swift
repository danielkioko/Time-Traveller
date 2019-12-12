//
//  UploadHelper.swift
//  Time Traveler
//
//  Created by Daniel Nzioka on 12/12/19.
//  Copyright © 2019 Daniel Nzioka. All rights reserved.
//

import UIKit
import Firebase
import Foundation

class FirFile: NSObject {
    
    static let shared: FirFile = FirFile()
    
    let kFirFileStorageRef = Storage.storage().reference().child("Files")

        /// Current uploading task
        var currentUploadTask: StorageUploadTask?

        func upload(data: Data,
                    withName fileName: String,
                    block: @escaping (_ url: String?) -> Void) {

            // Create a reference to the file you want to upload
            let fileRef = kFirFileStorageRef.child(fileName)

            /// Start uploading
            upload(data: data, withName: fileName, atPath: fileRef) { (url) in
                block(url)
            }
        }

        func upload(data: Data,
                    withName fileName: String,
                    atPath path:StorageReference,
                    block: @escaping (_ url: String?) -> Void) {

            // Upload the file to the path
            self.currentUploadTask = path.putData(data, metadata: nil) { (metaData, error) in

                guard let metadata = metaData else {
                  return
                }
                
                self.kFirFileStorageRef.downloadURL { (url, error) in
                  guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    return
                  }
                    let urlString = downloadURL.absoluteString
                    block(urlString)
                }
                
            }
        }

        func cancel() {
            self.currentUploadTask?.cancel()
        }
    }
    

