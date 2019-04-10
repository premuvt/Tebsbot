//
//  ClaimConfirmationPageViewController.swift
//  Tebsbot
//
//  Created by uvionics on 06/04/19.
//  Copyright © 2019 Premraj C Ramankutty. All rights reserved.
//

import UIKit

class ClaimConfirmationPageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationController?.navigationBar.backgroundColor = UIColor.white
        let logo = UIImage(named: "logo")
        let imageView = UIImageView(image:logo)
        imageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageView
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage.init(named: "arrow"), for: UIControl.State.normal)
        button.addTarget(self, action:#selector(backButtonClicked(sender:)), for:.touchUpInside)
        button.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30) //CGRectMake(0, 0, 30, 30)
        let barButton = UIBarButtonItem.init(customView: button)
        self.navigationItem.leftBarButtonItem = barButton
        
        let rightButton = UIButton.init(type: .custom)
        rightButton.setImage(UIImage.init(named: "logout"), for: UIControl.State.normal)
        rightButton.addTarget(self, action:#selector(logout(sender:)), for:.touchUpInside)
        rightButton.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30) //CGRectMake(0, 0, 30, 30)
        let barButtonRight = UIBarButtonItem.init(customView: rightButton)
        self.navigationItem.rightBarButtonItem = barButtonRight
    }
    @objc func backButtonClicked(sender:UIButton){
       self.navigationController?.popToRootViewController(animated: true)
    }
    @objc func logout(sender:UIButton){
        let alert = UIAlertController.init(title: "Confirm", message: "Do you really want to continue", preferredStyle: .alert)
        alert.alertWithOkCancelButton(view: self, okAction: .logout)
    }
}
