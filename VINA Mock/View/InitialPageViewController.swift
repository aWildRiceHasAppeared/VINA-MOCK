//
//  InitialPageViewController.swift
//  VINA Mock
//
//  Created by Irving Hsu on 4/24/18.
//  Copyright © 2018 Irving Hsu. All rights reserved.
//

import UIKit

class InitialPageViewController: UIViewController, UIScrollViewDelegate{

    @IBOutlet weak var InitialPageControl: UIPageControl!
    @IBOutlet weak var InitialScrollView: UIScrollView!
    
    var images = ["VINA","VINA2"]
    var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    let signupClass = SignUpEmailFirebase()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.bringSubview(toFront: InitialPageControl)
        InitialPageControl.numberOfPages = images.count
        
        for i in 0..<images.count {
            frame.origin.x = InitialScrollView.frame.size.width * (CGFloat(i)*1.15)
            frame.size = CGSize(width: InitialScrollView.frame.width , height: InitialScrollView.frame.height)
            
            let imageView = UIImageView(frame: frame)
            imageView.image = UIImage(named: images[i])
            self.InitialScrollView.addSubview(imageView)
        }
        
        InitialScrollView.contentSize = CGSize(width: (InitialScrollView.frame.size.width * CGFloat(images.count)) + 100, height: InitialScrollView.frame.size.height)
        InitialScrollView.delegate = self
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        InitialPageControl.currentPage = Int(pageNumber)
        print("InitialPageControl.currentPage : \(InitialPageControl.currentPage)")
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func TermsOfServiceButton(_ sender: UIButton) {
        self.openWebsite(url: "https://vina.io/vina-terms-of-service")
    }
    @IBAction func PrivacyPolicyButton(_ sender: UIButton) {
        self.openWebsite(url: "https://vina.io/privacy")
    }
    
    func openWebsite(url:String){
        UIApplication.shared.open(URL(string : url)!, options: [:], completionHandler: { (status) in
        })
    }
    
    @IBAction func loginWithFacebook(_ sender: UIButton) {
        performSegue(withIdentifier: "loggedInWithFacebookSegue", sender: self)
    }
    @IBAction func loginWithOtherOptionButton(_ sender: UIButton) {
        if signupClass.userLongitude != nil {
            print(self.signupClass.userLongitude)
            performSegue(withIdentifier: "SignupSegue", sender: self)
        } else {
            print("User location unknown wait ")
        }
    }
    

}
