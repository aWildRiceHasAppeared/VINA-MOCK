//
//  VINAZINEViewController.swift
//  VINA Mock
//
//  Created by Irving Hsu on 4/24/18.
//  Copyright © 2018 Irving Hsu. All rights reserved.
//

import UIKit
import WebKit

class VINAZINEViewController: UIViewController {

    @IBOutlet weak var VINAZINEWebView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let VINAZINEURL = URL(string: "https://vinazine.com/category/thrive/")
        let request = URLRequest(url: VINAZINEURL!)
        VINAZINEWebView.load(request)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
