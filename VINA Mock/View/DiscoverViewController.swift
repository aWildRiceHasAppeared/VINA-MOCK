//
//  DiscoverViewController.swift
//  VINA Mock
//
//  Created by Irving Hsu on 4/24/18.
//  Copyright © 2018 Irving Hsu. All rights reserved.
//

import UIKit

class DiscoverViewController: UIViewController {

    @IBOutlet weak var matchCards: UIView!
    @IBOutlet weak var matchCards2: UIView!
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var VINAName: UILabel!
    @IBOutlet weak var VINAName2: UILabel!
    @IBOutlet weak var VINAMatchUserLocation: UILabel!
    @IBOutlet weak var VINAMatchUserLocation2: UILabel!
    @IBOutlet weak var VINAMatchUserInterest1Image: UIImageView!
    @IBOutlet weak var VINAMatchUserInterest2Image: UIImageView!
    @IBOutlet weak var VINAMatchUserInterest3Image: UIImageView!
    @IBOutlet weak var VINAMatchUserDescription: UITextView!
    @IBOutlet weak var VINAMatchUserDescription2: UITextView!
    @IBOutlet weak var VINAMatchUserProfileImage: UIImageView!
    @IBOutlet weak var VINAMatchUserProfileImage2: UIImageView!
    
    var divisor: CGFloat!
    let DiscoverClass = Discover()
    var userIDandImage = [String : Data]()
    var counter = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.thumbImageView.alpha = 0
        divisor = ((view.frame.width) / 2 ) / 0.61
        
        //Front card UI
        self.matchCards.layer.borderWidth = 1
        self.VINAMatchUserProfileImage.layer.masksToBounds = true
        self.VINAMatchUserProfileImage.layer.cornerRadius = self.VINAMatchUserProfileImage.frame.size.width / 2
        self.matchCards.center = self.view.center
        
        // Back card UI
        self.matchCards2.layer.borderWidth = 1
        self.VINAMatchUserProfileImage2.layer.masksToBounds = true
        self.VINAMatchUserProfileImage2.layer.cornerRadius = self.VINAMatchUserProfileImage2.layer.frame.size.width / 2
        self.matchCards2.center = CGPoint(x: self.view.center.x + 10, y: self.view.center.y + 10)
        self.matchCards2.layer.shadowColor = UIColor.gray.cgColor
        self.matchCards2.layer.shadowOpacity = 0.8
        self.matchCards2.layer.shadowOffset = CGSize(width: 10, height: 10)

        
        
        self.DiscoverClass.gettingUserIds {
            var firstItem = self.DiscoverClass.userInformationDictionary.first
            self.VINAName.text = firstItem?.value["Name"]
            self.VINAMatchUserLocation.text = firstItem?.value["City"]
            self.DiscoverClass.downloadUserImages(userID: (firstItem?.key)!) {
                self.VINAMatchUserProfileImage.image = UIImage(data:self.DiscoverClass.userImageData!)
                self.DiscoverClass.userInformationDictionary.popFirst()
            }
        }
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func reportButton(_ sender: UIButton) {
        let alert = UIAlertController(title: "Report", message: "Report this user?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { (alert) in
            print("You've reported this person")
            // Update this info into the reported's database. If exceed x amount, then block account.
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // Card swipe animation
    @IBAction func MatchCards(_ sender: UIPanGestureRecognizer) {
        let card = sender.view!
        // tracks how far you moves from your orignial position to where your finger is
        let point = sender.translation(in: view)
        let xFromCenter = card.center.x - self.view.center.x
        card.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
        
        card.transform = CGAffineTransform(rotationAngle: xFromCenter/divisor)

        if xFromCenter > 0 {
            thumbImageView.image = #imageLiteral(resourceName: "thumbsUp")
            thumbImageView.tintColor = UIColor.green
        } else {
            thumbImageView.image = #imageLiteral(resourceName: "thumbsDown")
            thumbImageView.tintColor = UIColor.red
        }
        
        thumbImageView.alpha = abs(xFromCenter) / view.center.x
        
        if sender.state == UIGestureRecognizerState.ended {
            if card.center.x < 75 {
                // Move off to teh left
                UIView.animate(withDuration: 0.2) {
                    card.center = CGPoint(x: card.center.x - 300 , y: card.center.y + 75)
                    card.alpha = 0
                }
                resetCard()
                return
            } else if card.center.x > (view.frame.width - 75){
                //Move off to the right side
                UIView.animate(withDuration: 0.2) {
                    card.center = CGPoint(x: card.center.x + 300 , y: card.center.y + 75)
                    card.alpha = 0
                }
                resetCard()
                return
            }
//            UIView.animate(withDuration: 0.3) {
//                card.center = self.view.center
//                self.thumbImageView.alpha = 0
//                self.matchCards.transform = CGAffineTransform.identity
//            }
        }
    }
    
    func resetCard(){
        UIView.animate(withDuration: 0.2) {
            self.matchCards.center = self.view.center
            self.thumbImageView.alpha = 0
            self.matchCards.transform = CGAffineTransform.identity
            self.matchCards.alpha = 1
        }
        self.loadFirstCard {
            self.loadSecondCard()
        }
        
    }
    
    
    func loadFirstCard(completion: @escaping()->()){
        var firstItem = self.DiscoverClass.userInformationDictionary.first
        
        if self.DiscoverClass.userInformationDictionary.count != 0 {
            self.VINAName.text = firstItem?.value["Name"]
            self.VINAMatchUserLocation.text = firstItem?.value["City"]
            self.DiscoverClass.downloadUserImages(userID: (firstItem?.key)!) {
                self.VINAMatchUserProfileImage.image = UIImage(data:self.DiscoverClass.userImageData!)
            }
            self.DiscoverClass.userInformationDictionary.popFirst()
            completion()
        } else {
            popOutOfSwipeAlert()
        }
    }
    func loadSecondCard(){
        if self.DiscoverClass.userInformationDictionary.count >= 1 {
            var firstItem = self.DiscoverClass.userInformationDictionary.first
            self.VINAName2.text = firstItem?.value["Name"]
            self.VINAMatchUserLocation2.text = firstItem?.value["City"]
            self.DiscoverClass.downloadUserImages(userID: (firstItem?.key)!) {
                self.VINAMatchUserProfileImage2.image = UIImage(data:self.DiscoverClass.userImageData!)
            }
        } else {
            popOutOfSwipeAlert()
        }
    }
    func popOutOfSwipeAlert(){
        let alert = UIAlertController(title: "Alert", message: "Out of people to swipe", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        self.VINAName.text = "Out of swipes"
        self.VINAMatchUserLocation.text = "Out of swipesville"
        self.VINAMatchUserProfileImage.image = #imageLiteral(resourceName: "puppy1")
        self.VINAName2.text = ""
        self.VINAMatchUserLocation2.text = ""
        self.VINAMatchUserProfileImage2.image = #imageLiteral(resourceName: "puppy1")
    }
}
