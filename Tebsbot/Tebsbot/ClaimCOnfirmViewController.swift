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
    
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
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
        navigationController?.navigationBar.backgroundColor = UIColor.white
        let logo = UIImage(named: "logo")
        let imageView = UIImageView(image:logo)
        imageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageView

        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    @IBAction func confirmButtonTapped(_ sender: UIButton) {
        self.activityIndicator("Confirming...")
        sender.isEnabled = false
        let dictionaryClaim: Dictionary<String,String> = ["date":dateLabel.text!,"claim_type":typeLabel.text!,"fare_amount":amountLable.text!]
        WebService.shared.confirmClaim(parameter: dictionaryClaim) { (success, errorMessage, successMessage) in
            sender.isEnabled = true
            if success{
                DispatchQueue.main.sync {
                    self.stopActivity()
                    let storyboard = UIStoryboard(name: "Home", bundle: nil)
                    let claimConfirmationPage = storyboard.instantiateViewController(withIdentifier: "ClaimConfirmationPageViewController") as! ClaimConfirmationPageViewController
                    self.navigationController?.pushViewController(claimConfirmationPage, animated: true)
                }
            }else{
                debugPrint("errorMessage")
            }
        }
        
        

    }
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    //MARK:- activity indicator
    
    func activityIndicator(_ title: String) {
        
        strLabel.removeFromSuperview()
        activityIndicator.removeFromSuperview()
        effectView.removeFromSuperview()
        
        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 160, height: 46))
        strLabel.text = title
        strLabel.font = .systemFont(ofSize: 14, weight: .medium)
        strLabel.textColor = UIColor(white: 0.9, alpha: 0.7)
        
        effectView.frame = CGRect(x: view.frame.midX - strLabel.frame.width/2, y: view.frame.midY - strLabel.frame.height/2 , width: 160, height: 46)
        effectView.layer.cornerRadius = 15
        effectView.layer.masksToBounds = true
        
        activityIndicator = UIActivityIndicatorView(style: .white)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 46, height: 46)
        activityIndicator.startAnimating()
        
        effectView.contentView.addSubview(activityIndicator)
        effectView.contentView.addSubview(strLabel)
        view.addSubview(effectView)
    }
    
    func stopActivity() {
        activityIndicator.stopAnimating()
        strLabel.removeFromSuperview()
        activityIndicator.removeFromSuperview()
        effectView.removeFromSuperview()
    }
}
