//
//  HomeViewcontroller.swift
//  Tebsbot
//
//  Created by Premraj C Ramankutty on 04/04/19.
//  Copyright © 2019 Premraj C Ramankutty. All rights reserved.
//

import Foundation
import UIKit
class HomeNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

class HomeViewcontroller: UIViewController {
    
    @IBOutlet weak var applyLeaveView: UIView!
    
    @IBOutlet weak var applyClaimView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.applyLeave))
        self.applyLeaveView.addGestureRecognizer(gesture)
        let gesture2 = UITapGestureRecognizer(target: self, action:  #selector(self.applyClaim))
        self.applyClaimView.addGestureRecognizer(gesture2)
        
    }
    
    
    
    @objc func applyLeave(sender : UITapGestureRecognizer) {
        // Do what you want
        print("applyLeave")
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ApplyLeaveViewController")
        self.navigationController?.pushViewController(controller, animated: true)
    }
    @objc func applyClaim(sender : UITapGestureRecognizer) {
        // Do what you want
        print("applyClaim")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "UploadReceiptViewController")
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
