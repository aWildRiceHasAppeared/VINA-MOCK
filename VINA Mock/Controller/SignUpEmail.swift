//
//  SignUpEmail.swift
//  VINA Mock
//
//  Created by Irving Hsu on 4/25/18.
//  Copyright © 2018 Irving Hsu. All rights reserved.
//

import Foundation
import Firebase
import UIKit
import MapKit
import CoreLocation

class SignUpEmailFirebase{
    
    var ref: DatabaseReference!
    let locationManager = CLLocationManager()
    var userCity = ""
    var userLattitude : CLLocationDegrees?
    var userLongitude : CLLocationDegrees?
    
    func requestUserLocation(completion: @escaping ()->()){
        // Getting the user's location
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self as? CLLocationManagerDelegate
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            self.userLattitude = locationManager.location?.coordinate.latitude
            self.userLongitude = locationManager.location?.coordinate.longitude
            completion()
        }
    }
    
    func getUserCityByLocation(latittude: CLLocationDegrees, longitude: CLLocationDegrees){
        self.geocode(latitude: latittude, longitude: longitude) { (placemark, error) in
            if error != nil {
                print("There is an error")
            } else {
                if let place = placemark {
                    print(place.locality)
                    self.userCity = place.locality!
                    guard case let self.userCity = place.locality else { self.userCity = "No Location"
                        return
                    }
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    func geocode(latitude: Double, longitude: Double, completion: @escaping (CLPlacemark?, Error?) -> ())  {
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) { completion($0?.first, $1) }
    }

    func signUpToFirebase(email: String, password: String, name: String, gender: String, city: String, completion: @escaping ()->()){
        ref = Database.database().reference()
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print(error?.localizedDescription)
                return
            } else {
                self.ref.child("User").child((Auth.auth().currentUser?.uid)!).updateChildValues(["Email":email])
                self.ref.child("User").child((Auth.auth().currentUser?.uid)!).updateChildValues(["Name":name])
                self.ref.child("User").child((Auth.auth().currentUser?.uid)!).updateChildValues(["Gender":gender])
                
                if city == "" {
                    self.ref.child("User").child((Auth.auth().currentUser?.uid)!).updateChildValues(["City":"No Location"])
                } else {
                    self.ref.child("User").child((Auth.auth().currentUser?.uid)!).updateChildValues(["City":city])
                }
                completion()
            }
        }
    }
}
