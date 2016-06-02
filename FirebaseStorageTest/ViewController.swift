//
//  ViewController.swift
//  FirebaseStorageTest
//
//  Created by Iavor V. Dekov on 6/2/16.
//  Copyright © 2016 Iavor Dekov. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let storage = FIRStorage.storage()
        
        // Create a storage reference from our storage service
        let storageRef = storage.referenceForURL("gs://fir-storagetestapp.appspot.com")
        
        // Create a child reference
        // imagesRef now points to "images"
        let imagesRef = storageRef.child("images")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

