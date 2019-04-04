//
//  LoginViewController.swift
//  Tebsbot
//
//  Created by uvionics on 04/04/19.100
//  Copyright © 2019 Premraj C Ramankutty. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {


    //MARK: OUTLETS
    
    @IBOutlet weak var textFieldUserName: LineTextField!
    @IBOutlet weak var textFieldPassword: LineTextField!
    
    @IBOutlet weak var buttonSignUp: UIButton!
    @IBOutlet weak var buttonLogin: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setUpActions()
        
    }
    func setUI(){
        buttonLogin.layer.cornerRadius = buttonLogin.frame.height / 2
        buttonLogin.layer.masksToBounds = true
    }
    func setUpActions(){
        buttonLogin.addTarget(self, action:#selector(buttonLoginPressed(sender:)), for: .touchUpInside)
    }
    
    //MARK:- Button Actions
    
    @objc func buttonLoginPressed(sender: UIButton){
        if textFieldUserName.text == "ranjit" && textFieldPassword.text == "1234"{
            debugPrint("Valid Credentials")
        }else{
            debugPrint("Invalid Credentials")
        }
    }
    
    @IBAction func buttonLoginPressed(_ sender: UIButton) {
        if textFieldUserName.text == "ranjit" && textFieldPassword.text == "1234"{
            debugPrint("Valid Credentials")
        }else{
            debugPrint("Invalid Credentials")
        }
    }
    @IBAction func buttonSignupPressed(_ sender: Any) {
    }
}
