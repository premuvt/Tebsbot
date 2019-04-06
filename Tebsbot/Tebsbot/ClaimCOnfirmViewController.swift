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
    
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var reciptImageview: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var amountLable: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        reciptImageview.image = selectedImage
        typeLabel.text = "Claim Type - \(responceClaimString ?? "no type")"
        dateLabel.text = "Date - \(responceDateString ?? "no date")"
        amountLable.text = "Claim Amount - \(responceFareString ?? "no amount")"
    }
    func updateUI(){
        cancelButton.layer.cornerRadius = cancelButton.frame.height / 2
        cancelButton.layer.masksToBounds = true
        confirmButton.layer.cornerRadius = confirmButton.frame.height / 2
        confirmButton.layer.masksToBounds = true
        
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
    @IBAction func confirmButtonTapped(_ sender: UIButton) {
        DispatchQueue.main.sync {
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            let claimConfirmationPage = storyboard.instantiateViewController(withIdentifier: "ClaimConfirmationPageViewController") as! ClaimConfirmationPageViewController
//            finalConfirmatioCcontroller.delegate = self
            self.navigationController?.pushViewController(claimConfirmationPage, animated: true)
        }
    }
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
    }
}
