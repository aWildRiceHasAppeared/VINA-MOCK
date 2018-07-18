//
//  ProfilePhotoSelection.swift
//  VINA Mock
//
//  Created by Irving Hsu on 4/25/18.
//  Copyright © 2018 Irving Hsu. All rights reserved.
//

import Foundation
import Firebase
import Photos
import UIKit

class UploadProfilePhotoClass {

    func uploadProfilePicture(image: UIImage, progressView: UIProgressView, completion: @escaping ()->()){
        guard let userID = Auth.auth().currentUser?.uid else {return}
        
        let storage = Storage.storage().reference(withPath: userID)
        let userProfileImageReference = storage.child("profileImage")
        let uploadMetaData = StorageMetadata()
        uploadMetaData.contentType = "image/jpeg"
        
        let compressedImage = image.resizeWithPercent(percentage: 0.1)
        
        guard let uploadData = UIImagePNGRepresentation(compressedImage!) else { return }
        let uploadTask = userProfileImageReference.putData(uploadData, metadata: uploadMetaData) { (metadata, error) in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                print("Upload complete")
                completion()
            }
        }
        uploadTask.observe(.progress) { (snapshot) in
            guard let progress = snapshot.progress else {return}
            DispatchQueue.main.async {
                progressView.isHidden = false
                progressView.progress = Float(progress.fractionCompleted)
            }
        }
    }
    
    func checkPermission() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            print("Access is granted by user")
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                print("status is \(newStatus)")
                if newStatus ==  PHAuthorizationStatus.authorized {
                    /* do stuff here */
                    print("success")
                }
            })
            print("It is not determined until now")
        case .restricted:
            // same same
            print("User do not have access to photo album.")
        case .denied:
            // same same
            print("User has denied the permission.")
        }
    }
}
extension UIImage {
    func resizeWithPercent(percentage: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: size.width * percentage, height: size.height * percentage)))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
    func resizeWithWidth(width: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
    
}

