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
        setUI()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationController?.navigationBar.backgroundColor = UIColor.white
        let logo = UIImage(named: "logo")
        let imageView = UIImageView(image:logo)
        imageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageView
        
        let rightButton = UIButton.init(type: .custom)
        rightButton.setImage(UIImage.init(named: "logout"), for: UIControl.State.normal)
        rightButton.addTarget(self, action:#selector(logout(sender:)), for:.touchUpInside)
        rightButton.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30) //CGRectMake(0, 0, 30, 30)
        let barButtonRight = UIBarButtonItem.init(customView: rightButton)
        self.navigationItem.rightBarButtonItem = barButtonRight
    }
    
    func setUI(){
        applyLeaveView.layer.cornerRadius = applyLeaveView.frame.height / 2
        applyLeaveView.layer.masksToBounds = true
        applyClaimView.layer.cornerRadius = applyClaimView.frame.height / 2
        applyClaimView.layer.masksToBounds =  true

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
    
    @objc func logout(sender:UIButton){
        UserDefaults.standard.removeObject(forKey: "user")
        UserDefaults.standard.removeObject(forKey: "pass")
        (UIApplication.shared.delegate as! AppDelegate).navigatetoLoginPage()
    }
}
