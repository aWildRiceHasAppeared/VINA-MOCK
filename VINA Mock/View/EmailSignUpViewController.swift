//
//  EmailSignUpViewController.swift
//  VINA Mock
//
//  Created by Irving Hsu on 4/25/18.
//  Copyright © 2018 Irving Hsu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import MapKit
import CoreLocation

class EmailSignUpViewController: UIViewController {

    @IBOutlet weak var signUpEmailTextfield: UITextField!
    @IBOutlet weak var signUpPasswordTextfield: UITextField!
    @IBOutlet weak var signUpNameTextfield: UITextField!
    @IBOutlet weak var signUpGenderTextfield: UITextField!
    
    var ref: DatabaseReference!
    let userID = Auth.auth().currentUser?.uid
    let SignUpClass = SignUpEmailFirebase()
    var userCity = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = Database.database().reference()
        // Do any additional setup after loading the view.
        self.SignUpClass.requestUserLocation() {
            
            guard let latitude = self.SignUpClass.userLattitude, let longitude = self.SignUpClass.userLongitude else { print("No user location")
                return
            }
            self.SignUpClass.getUserCityByLocation(latittude: latitude, longitude: longitude)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func submitButton(_ sender: UIButton) {
        let textfieldArray = [signUpEmailTextfield,signUpPasswordTextfield,signUpNameTextfield,signUpGenderTextfield]
        
        if !checkIfTextfieldIsEmpty(textfieldArray: textfieldArray) && checkGender(gender: self.signUpGenderTextfield.text!) {
            SignUpClass.signUpToFirebase(email: signUpEmailTextfield.text!, password: signUpPasswordTextfield.text!, name: signUpNameTextfield.text!, gender: signUpGenderTextfield.text!, city: self.SignUpClass.userCity){
                    self.SignUpClass.locationManager.stopUpdatingLocation()
                    self.performSegue(withIdentifier: "profileImageSelectSegue", sender: self)
            }
        } else {
            if checkGender(gender: signUpGenderTextfield.text!) == false {
                let alert = UIAlertController(title: "Alert", message: "Sorry this app is for woman only", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            print("Something is wrong")
        }
    }
    @IBAction func backButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func checkIfTextfieldIsEmpty(textfieldArray: [UITextField?]) -> Bool{
        var result: Bool?
        for textfield in textfieldArray {
            if (textfield?.text?.isEmpty)! {
                result = true
            } else {
                result = false
            }
        }
        return result!
    }
    
    func checkGender(gender: String) -> Bool{
        var result: Bool?
        if gender.lowercased() == "woman" {
            result = true
        } else {
            result = false
        }
        return result!
    }
}
