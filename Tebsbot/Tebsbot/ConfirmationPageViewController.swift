//
//  ConfirmationPageViewController.swift
//  Tebsbot
//
//  Created by Premraj C Ramankutty on 05/04/19.
//  Copyright © 2019 Premraj C Ramankutty. All rights reserved.
//

import UIKit
import AVFoundation

class ConfirmationPageViewController: UIViewController {

    @IBOutlet weak var buttonCancel: UIButton!
    @IBOutlet weak var buttonConfirm: UIButton!
    @IBOutlet weak var leaveDateLabel: UILabel!
    @IBOutlet weak var leaveTypeLabel: UILabel!
    
    var leaveConfirm : LeaveChatModal?
    var synth:AVSpeechSynthesizer = AVSpeechSynthesizer()
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    var dateString = ""
    var changedDate = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dateString = changeDateFormat(string:leaveConfirm!.data!.date!)
        setUpUI()
        self.speakText(message: "Sir, do you like to apply \(String(leaveConfirm!.data!.type!)) on \(String(describing: dateString)). Please confirm.")
        //setUpUI()
    }
    func setday(daystring:String)-> String{
        switch daystring.lowercased() {
        case "first","one":
            return "1"
        case "second","two":
            return "2"
        case "third","three":
            return "3"
        case "fourth","four","forth":
            return "4"
        case "fifth","five":
            return "5"
        case "sixth","six":
            return "6"
        case "seventh","seven":
            return "7"
        case "eighth","eight":
            return "8"
        case "nineth","ninth","nine":
            return "9"
        case "tenth","ten":
            return "10"

        default:
            return daystring
        }
    }
    
    
    func changeDateFormat(string : String) -> String{
        
let dayArray = string.split(separator: "-")
        let day:String = String(dayArray[0])
        let dayString = setday(daystring: day)
        
        changedDate = dayString + "-" + String(dayArray[1]) + "-" + String(dayArray[2])
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "dd-mm-yyyy"
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "mm-dd-yyyy"  //"MMM d, h:mm a" for  Sep 12, 2:11 PM
        let datee = dateFormatterGet.date(from: changedDate)
        let speachdate =  dateFormatterPrint.string(from: datee!)
        return speachdate
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
        button.addTarget(self, action:#selector(buttonCancel(sender: )), for:.touchUpInside)
        button.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30) //CGRectMake(0, 0, 30, 30)
        let barButton = UIBarButtonItem.init(customView: button)
        self.navigationItem.leftBarButtonItem = barButton
        
        let rightButton = UIButton.init(type: .custom)
        rightButton.setImage(UIImage.init(named: "chat"), for: UIControl.State.normal)
        rightButton.addTarget(self, action:#selector(chat(sender:)), for:.touchUpInside)
        rightButton.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30) //CGRectMake(0, 0, 30, 30)
        let barButtonRight = UIBarButtonItem.init(customView: rightButton)
        self.navigationItem.rightBarButtonItem = barButtonRight

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        synth.stopSpeaking(at: .immediate)
    }
    func setUpUI(){
        buttonConfirm.layer.cornerRadius = buttonConfirm.frame.height / 2
        buttonConfirm.layer.masksToBounds = true
        buttonCancel.layer.cornerRadius = buttonCancel.frame.height / 2
        buttonCancel.layer.masksToBounds = true
        
        if leaveConfirm != nil{
            self.leaveTypeLabel.text = leaveConfirm?.data?.type
            self.leaveDateLabel.text = changedDate
        }
        
    }
    
    @IBAction func buttonConfirmPressed(_ sender: UIButton) {
        sender.isEnabled = false
        self.activityIndicator("Confirming...")
        WebService.shared.confirmLeave(parameter: leaveConfirm?.data , completionBlock: { (success, errorMessage, successMessage) in
            sender.isEnabled = true
            if success{
                DispatchQueue.main.sync {
                    self.stopActivity()
                    let storyboard = UIStoryboard(name: "Home", bundle: nil)
                    let finalConfirmatioCcontroller = storyboard.instantiateViewController(withIdentifier: "FinalConfirmationViewController") as! FinalConfirmationViewController
                self.navigationController?.pushViewController(finalConfirmatioCcontroller, animated: true)
                } }else{
                debugPrint("errorMessage")
            }
        })
    }
    
    @IBAction func buttonCancelPressed(_ sender: UIButton) {
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func chat(sender:UIButton){
self.navigationController?.popViewController(animated: true)
    }

    @objc func buttonCancel(sender:UIButton){
        self.navigationController?.popToRootViewController(animated: true)

    

}
    //MARK:- text to speech
    func speakText(message:String) {
        print("test to voice - ",message)
        let utterance = AVSpeechUtterance(string: message)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        self.synth.speak(utterance)
        
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
