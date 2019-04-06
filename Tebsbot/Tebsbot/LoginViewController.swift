//
//  LoginViewController.swift
//  Tebsbot
//
//  Created by uvionics on 04/04/19.100
//  Copyright © 2019 Premraj C Ramankutty. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {


    //MARK: OUTLETS
    
    @IBOutlet weak var textFieldUserName: LineTextField!
    @IBOutlet weak var textFieldPassword: LineTextField!
    @IBOutlet weak var buttonLogin: UIButton!
    @IBOutlet var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
//        setDemoCred()
        setUpTapToDismissKeyboard()
        setUpKeyboardNotification()
        
    }
    func setUpKeyboardNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardNotification(notification:)),
                                               name: UIResponder.keyboardDidShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardNotification(notification:)),
                                               name: UIResponder.keyboardDidHideNotification,
                                               object: nil)
        textFieldUserName.becomeFirstResponder()
    }
    func setUI(){
        buttonLogin.layer.cornerRadius = buttonLogin.frame.height / 2
        buttonLogin.layer.masksToBounds = true
        
        textFieldUserName.delegate = self
        textFieldPassword.delegate = self
    }
    func setDemoCred() {
        self.textFieldUserName.text = "ranjit"
        self.textFieldPassword.text = "1234"
    }
    func setUpTapToDismissKeyboard() {
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        self.view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    //MARK:- Button Actions
    

    
    @IBAction func buttonLoginPressed(_ sender: UIButton) {
        if textFieldUserName.text == "ranjit" && textFieldPassword.text == "1234"{
            debugPrint("Valid Credentials")
            UserDefaults.standard.set(textFieldUserName.text, forKey: "user")
            UserDefaults.standard.set(textFieldPassword.text, forKey: "pass")
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "HomeNavigationController")
            self.present(controller, animated: true, completion: nil)
        }else{
            debugPrint("Invalid Credentials")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        
        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            self.buttonLogin.sendActions(for: .touchUpInside)
        }
        
        return true
    }
    
    
    //MARK: - Key notification
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameY = endFrame!.origin.y ?? 0
            let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            if endFrameY >= UIScreen.main.bounds.size.height {
                self.keyboardHeightLayoutConstraint?.constant = 274.0
                
            } else {
                self.keyboardHeightLayoutConstraint?.constant = endFrame?.size.height ?? 274.0
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
}
