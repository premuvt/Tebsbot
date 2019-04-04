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
    @IBOutlet weak var buttonLogin: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setDemoCred()
    }
    func setUI(){
        buttonLogin.layer.cornerRadius = buttonLogin.frame.height / 2
        buttonLogin.layer.masksToBounds = true
    }
    func setDemoCred() {
        self.textFieldUserName.text = "ranjit"
        self.textFieldPassword.text = "1234"
    }
    
    //MARK:- Button Actions
    

    
    @IBAction func buttonLoginPressed(_ sender: UIButton) {
        if textFieldUserName.text == "ranjit" && textFieldPassword.text == "1234"{
            debugPrint("Valid Credentials")
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "HomeNavigationController")
            self.present(controller, animated: true, completion: nil)
        }else{
            debugPrint("Invalid Credentials")
        }
    }

}
