//
//  UploadReceiptViewController.swift
//  Tebsbot
//
//  Created by uvionics on 05/04/19.
//  Copyright © 2019 Premraj C Ramankutty. All rights reserved.
//

import UIKit

class UploadReceiptViewController: UIViewController {
    // MARK: - outlets
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var fileNameLabel: UILabel!
    
    @IBOutlet weak var buttonbrowse: UIButton!
    
    @IBOutlet weak var buttonupload: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    func setUpUI(){
        buttonbrowse.layer.cornerRadius = buttonbrowse.frame.height / 2
        buttonbrowse.layer.masksToBounds = true
        buttonupload.layer.cornerRadius = buttonupload.frame.height / 2
        buttonupload.layer.masksToBounds = true
    }

}
