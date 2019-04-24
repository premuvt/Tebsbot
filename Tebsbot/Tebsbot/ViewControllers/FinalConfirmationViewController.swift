//
//  FinalConfirmationViewController.swift
//  Tebsbot
//
//  Created by Premraj C Ramankutty on 05/04/19.
//  Copyright © 2019 Premraj C Ramankutty. All rights reserved.
//

import UIKit
import AVFoundation


class FinalConfirmationViewController: UIViewController {
    
    var synth:AVSpeechSynthesizer = AVSpeechSynthesizer()

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.speakText(message: "Your leave has been applied. Thank you.")
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        synth.stopSpeaking(at: .immediate)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationController?.navigationBar.backgroundColor = UIColor.white
        let logo = UIImage(named: "logo")
        let imageView = UIImageView(image:logo)
        imageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageView
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage.init(named: "arrow"), for: UIControl.State.normal)
        button.addTarget(self, action:#selector(cancelClicked(sender:)), for:.touchUpInside)
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
    @objc func cancelClicked(sender:UIButton){
       self.navigationController?.popToRootViewController(animated: true)
        
    }
    @objc func logout(sender:UIButton){
        let alert = UIAlertController.init(title: "Confirm", message: "Are you sure you want to logout?", preferredStyle: .alert)
        alert.alertWithOkCancelButton(view: self, okAction: .logout)
    }

    //MARK:- text to speech
    func speakText(message:String) {
        print("test to voice - ",message)
        let utterance = AVSpeechUtterance(string: message)
        utterance.voice = AVSpeechSynthesisVoice(language: NSLocale.current.identifier)
        utterance.volume = 1.0
        
        self.synth.speak(utterance)
    }
}
