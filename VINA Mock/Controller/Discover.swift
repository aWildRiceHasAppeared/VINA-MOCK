//
//  Discover.swift
//  VINA Mock
//
//  Created by Irving Hsu on 4/26/18.
//  Copyright © 2018 Irving Hsu. All rights reserved.
//

import Foundation
import Firebase
import UIKit

class Discover {
    
    var userIDs = [String]()
    var userNames = [String]()
    var userImageData : Data?
    var userCities = [String]()
    var userInformationDictionary = [String: [String:String]]()
    
    func gettingUserIds(completion: @escaping ()->()){
        let applicantDatabaseRef = Database.database().reference()
        applicantDatabaseRef.observe(.value) { (snap: DataSnapshot) in
            let userList = snap.childSnapshot(forPath: "User").value as! [String: [String:String]]
            self.userInformationDictionary = userList
            completion()
        }
    }
    
    func downloadUserImages(userID: String, completion: @escaping ()->()){
        let storage = Storage.storage().reference()
            let profileImageReference = storage.child(userID).child("profileImage")
            profileImageReference.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
                if error != nil {
                    print(error?.localizedDescription)
                } else {
                    self.userImageData = data
                }
             completion()
        }
    }
    
    
}
