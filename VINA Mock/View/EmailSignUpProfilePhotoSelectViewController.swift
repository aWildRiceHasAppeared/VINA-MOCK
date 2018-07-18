//
//  EmailSignUpProfilePhotoSelectViewController.swift
//  VINA Mock
//
//  Created by Irving Hsu on 4/25/18.
//  Copyright © 2018 Irving Hsu. All rights reserved.
//

import UIKit
import Firebase

class EmailSignUpProfilePhotoSelectViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var profilePhotoImage: UIImageView!
    @IBOutlet weak var profilePhotoUploadProgressBar: UIProgressView!
    
    var imagePicker = UIImagePickerController()
    
    let profilePhotoSelectClass = UploadProfilePhotoClass()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profilePhotoSelectClass.checkPermission()
        imagePicker.delegate = self
        self.profilePhotoUploadProgressBar.isHidden = true
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func profilePhotoSelectPhotoButton(_ sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func profilePhotoUploadButton(_ sender: UIButton) {
        
        if self.profilePhotoImage.image != nil {
            profilePhotoSelectClass.uploadProfilePicture(image: self.profilePhotoImage.image!, progressView: self.profilePhotoUploadProgressBar) {
                
                self.performSegue(withIdentifier: "regCompleteSegue", sender: self)
                print("Upload Success")
            }
        } else {
            print("You've gotta select a picutre sis")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profilePhotoImage.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
