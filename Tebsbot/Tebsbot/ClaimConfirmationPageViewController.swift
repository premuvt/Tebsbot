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
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        let logo = UIImage(named: "logo")
        let imageView = UIImageView(image:logo)
        imageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageView
        
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
}
