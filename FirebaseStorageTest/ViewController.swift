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
    
    @IBOutlet var uploadButton: UIBarButtonItem!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var cameraButton: UIBarButtonItem!
    @IBOutlet var libraryButton: UIBarButtonItem!
    @IBOutlet var progressBar: UIProgressView!
    
    var image = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uploadButton.enabled = false
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(.Camera)
    }
    
    @IBAction func upload(sender: UIBarButtonItem) {
        
        let imageData = UIImageJPEGRepresentation(image, 1.0);
        
        let storage = FIRStorage.storage()
        
        // Create a storage reference from our storage service
        let storageRef = storage.referenceForURL("gs://fir-storagetestapp.appspot.com")
        
        // Create a reference to the file you want to upload
        let riversRef = storageRef.child("images/nature.jpg")
        
        // Create file metadata including the content type
        let metadata = FIRStorageMetadata()
        metadata.contentType = "image/jpeg"
        
        // Upload the file to the path "images/rivers.jpg"
        let uploadTask = riversRef.putData(imageData!, metadata: metadata)
        
        // Listen for state changes, errors, and completion of the upload.
        uploadTask.observeStatus(.Pause) { snapshot in
            print("paused")
        }
        
        uploadTask.observeStatus(.Success) { snapshot in
            // Upload completed successfully
            print("success")
        }
        
        uploadTask.observeStatus(.Progress) { snapshot in
            // Upload reported progress
            if let uploadProgress = snapshot.progress {
                let percentComplete = 100.0 * Double(uploadProgress.completedUnitCount) / Double(uploadProgress.totalUnitCount)
                print(percentComplete)
                
                self.progressBar.progress = Float(uploadProgress.completedUnitCount / uploadProgress.totalUnitCount)
            }
        }
        
        // Errors only occur in the "Failure" case
        uploadTask.observeStatus(.Failure) { snapshot in
            guard let storageError = snapshot.error else { return }
            guard let errorCode = FIRStorageErrorCode(rawValue: storageError.code) else { return }
            switch errorCode {
            case .ObjectNotFound:
                // File doesn't exist
                print("object not found")
            case .Unauthorized:
                // User doesn't have permission to access file
                print("unauthorized")
            case .Cancelled:
                // User canceled the upload
                print("cancelled")
            case .Unknown:
                // Unknown error occurred, inspect the server response
                print("unknown")
            default:
                print("default")
            }
        }
    }
    
}

// MARK: - UIImagePickerControllerDelegate
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBAction func selectImage(sender: UIBarButtonItem) {
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        if sender == libraryButton {
            imagePickerController.sourceType = .PhotoLibrary
        }
        else if sender == cameraButton {
            imagePickerController.sourceType = .Camera
        }
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        // The info dictionary contains multiple representations of the image, and this uses the original.
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // Set the image field to the selected image
        image = selectedImage
        
        // Set photoImageView to display the selected image.
        imageView.image = selectedImage
        
        // Enable the upload button
        uploadButton.enabled = true
        
        // Dismiss the picker.
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}