//
//  ClaimCOnfirmViewController.swift
//  Tebsbot
//
//  Created by Premraj C Ramankutty on 05/04/19.
//  Copyright © 2019 Premraj C Ramankutty. All rights reserved.
//

import Foundation
import UIKit
class ClaimConfirmViewController: UIViewController {
    
    var responceDateString:String!
    var responceClaimString:String!
    var responceFareString:String!
    var selectedImage:UIImage!
    
    @IBOutlet weak var reciptImageview: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var amountLable: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reciptImageview.image = selectedImage
        typeLabel.text = "Claime Type - \(responceClaimString ?? "no type")"
        dateLabel.text = "Claime Type - \(responceDateString ?? "no date")"
        amountLable.text = "Claime Type - \(responceFareString ?? "no amount")"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        let logo = UIImage(named: "logo")
        let imageView = UIImageView(image:logo)
        imageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageView
//        let button = UIButton.init(type: .custom)
//        button.setImage(UIImage.init(named: "arrow"), for: UIControl.State.normal)
//        button.addTarget(self, action:#selector(ApplyLeaveViewController.backAction), for:.touchUpInside)
//        button.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30) //CGRectMake(0, 0, 30, 30)
//        let barButton = UIBarButtonItem.init(customView: button)
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
}
