//
//  LeaveConfirmationViewController.swift
//  Tebsbot
//
//  Created by uvionics on 27/04/19.
//  Copyright © 2019 Premraj C Ramankutty. All rights reserved.
//

import UIKit
import AVFoundation

class LeaveConfirmationViewController: UIViewController {
    
    var synth:AVSpeechSynthesizer = AVSpeechSynthesizer()
    
    @IBOutlet weak var buttonOk: UIButton!
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
        self.buttonOk.layer.cornerRadius = self.buttonOk.frame.height / 2
        self.buttonOk.layer.masksToBounds = true
        
    }
    
    @IBAction func buttonOKClicked(sender:UIButton){
//        let storyboard = UIStoryboard(name: "Home", bundle: nil)
//        let controller = storyboard.instantiateViewController(withIdentifier: "LeaveHomeSummaryNavigationViewController")
//               (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController = controller
//        self.present(controller, animated: false, completion: nil)
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "LeaveHomeSummaryNavigationViewController")
        //            self.window?.rootViewController = controller
        
        (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController = controller
        
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

