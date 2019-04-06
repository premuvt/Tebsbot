//
//  ConfirmationPageViewController.swift
//  Tebsbot
//
//  Created by Premraj C Ramankutty on 05/04/19.
//  Copyright © 2019 Premraj C Ramankutty. All rights reserved.
//

import UIKit

protocol confirmationDelegate {
    func didCancelClicked()
}
class ConfirmationPageViewController: UIViewController {
    var delegate:confirmationDelegate?
    
    @IBOutlet weak var buttonCancel: UIButton!
    @IBOutlet weak var buttonConfirm: UIButton!
    @IBOutlet weak var leaveDateLabel: UILabel!
    @IBOutlet weak var leaveTypeLabel: UILabel!
    
    var leaveConfirm : LeaveChatModal?
    var leavedate = ""
    var leaveType = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        let logo = UIImage(named: "logo")
        let imageView = UIImageView(image:logo)
        imageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageView
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage.init(named: "arrow"), for: UIControl.State.normal)
        button.addTarget(self, action:#selector(ApplyLeaveViewController.backAction), for:.touchUpInside)
        button.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30) //CGRectMake(0, 0, 30, 30)
        let barButton = UIBarButtonItem.init(customView: button)
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    
    func setUpUI(){
        buttonConfirm.layer.cornerRadius = buttonConfirm.frame.height / 2
        buttonConfirm.layer.masksToBounds = true
        buttonCancel.layer.cornerRadius = buttonCancel.frame.height / 2
        buttonCancel.layer.masksToBounds = true
        
        if leaveConfirm != nil{
            self.leaveTypeLabel.text = leaveConfirm?.data?.type
            self.leaveDateLabel.text = leaveConfirm?.data?.date
        }
        
    }
    
    @IBAction func buttonConfirmPressed(_ sender: UIButton) {
        
        WebService.shared.confirmLeave(parameter: leaveConfirm?.data , completionBlock: { (success, errorMessage, successMessage) in
            if success{
                DispatchQueue.main.sync {
                    let storyboard = UIStoryboard(name: "Home", bundle: nil)
                    let finalConfirmatioCcontroller = storyboard.instantiateViewController(withIdentifier: "FinalConfirmationViewController") as! FinalConfirmationViewController
                  finalConfirmatioCcontroller.delegate = self
                    self.navigationController?.pushViewController(finalConfirmatioCcontroller, animated: true)
                } }else{
                debugPrint("errorMessage")
            }
        })
        
        
        
    }
    
    @IBAction func buttonCancelPressed(_ sender: UIButton) {
        
        delegate?.didCancelClicked()
    }
    
    
}
extension ConfirmationPageViewController:FinalConfirmationPageDelegate{
    func didClickCancel(viewController: FinalConfirmationViewController) {
        delegate?.didCancelClicked()
    }
    
    
}
