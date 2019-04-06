//
//  ApplyLeaveViewController.swift
//  Tebsbot
//
//  Created by Premraj C Ramankutty on 04/04/19.
//  Copyright © 2019 Premraj C Ramankutty. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import Speech

class ApplyLeaveViewController: UIViewController,confirmationDelegate {
    func didCancelClicked() {
         self.navigationController?.popViewController(animated: true)
         self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var messageTextField: TextField!
    @IBOutlet var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    @IBOutlet var sendButtonboardHeightLayoutConstraint: NSLayoutConstraint?
    @IBOutlet var voiceButtonboardHeightLayoutConstraint: NSLayoutConstraint?
    
    @IBOutlet weak var recordButton: UIButton!
    
    @IBOutlet weak var sendButton: UIButton!
    //MARK:- speet to text
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    var isRecording = false
    
    let messageFrame = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))

    
    
    var chatArray:[LeaveChatModal]! = []
    var messageArray: [String] = []
    var chatMessage: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        sendMessage()
        setUpKeyBoardNotification()
        setUIBoarder()
        
        
        //for speech recogonition
        self.requestSpeechAuthorization()
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    func setUpKeyBoardNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardNotification(notification:)),
                                               name: UIResponder.keyboardDidShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardNotification(notification:)),
                                               name: UIResponder.keyboardDidHideNotification,
                                               object: nil)
    }
    func setUIBoarder(){
        //message text field
        self.messageTextField.layer.borderWidth = 1
        self.messageTextField.layer.cornerRadius = 10
        self.messageTextField.layer.borderColor = UIColor.gray.cgColor
    }
    func sendMessage(message: String? = ""){
        if message != ""{
            self.activityIndicator("Sending...")
            WebService.shared.applyLeaveChat(message: message!) { (status, errorMessage, chatModel) in
                DispatchQueue.main.sync {
                    self.sendButton.isEnabled = true
                    self.stopActivity()
                }
                if status{
                    if chatModel?.message == "continue"{
                        self.chatArray.append(chatModel!)
                        DispatchQueue.main.sync {
                            self.chatTableView.reloadData()
                        }
                        if let question = chatModel?.data?.question {
                            self.speakText(message: question)
                        }
                        
                    }else{
                        debugPrint("move to next page")
                        DispatchQueue.main.sync {
                            self.chatArray.append(chatModel!)
                            let storyboard = UIStoryboard(name: "Home", bundle: nil)
                            let confirmatioCcontroller = storyboard.instantiateViewController(withIdentifier: "ConfirmationPageViewController") as! ConfirmationPageViewController
                            confirmatioCcontroller.leaveConfirm = self.chatArray.last
                            confirmatioCcontroller.delegate = self
                            self.navigationController?.pushViewController(confirmatioCcontroller, animated: true)
                        }
                        
                    }
                }else{
                    debugPrint("No chat Available")
                }
            }
        } else{
            debugPrint("no message")
        }
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func onSend(_ sender: Any) {
        print("on send click")
        let message = self.messageTextField.text!
        if message.count != 0 && message != ""{
            self.messageTextField.resignFirstResponder()
            //stop recording if it is recording
            if isRecording {
                self.recordButton.sendActions(for: .touchUpInside)
            }
            
            messageArray.append(message)
            if chatArray.count != 0 {
                chatMessage = "\((chatArray[chatArray.count - 1].data?.sentence!))\(message)"
            }else{
                chatMessage = message
            }
            self.sendMessage(message: chatMessage)
            self.messageTextField.text = ""
            self.sendButton.isEnabled = false
        }else{
            debugPrint("enter a message a to send")
        }
    }
    @IBAction func onRecord(_ sender: Any) {
        self.messageTextField.resignFirstResponder()
        if isRecording == true {
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
            recognitionTask?.cancel()
            isRecording = false
            recordButton.backgroundColor = UIColor.gray
        } else {
            self.recordAndRecognizeSpeech()
            isRecording = true
            recordButton.backgroundColor = UIColor.red
        }
    }
    
}
extension ApplyLeaveViewController: UITableViewDelegate, UITableViewDataSource, SFSpeechRecognizerDelegate {
    
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
                self.keyboardHeightLayoutConstraint?.constant = 20.0
                self.sendButtonboardHeightLayoutConstraint?.constant = 20.0
                self.voiceButtonboardHeightLayoutConstraint?.constant = 20.0
            } else {
                self.keyboardHeightLayoutConstraint?.constant = endFrame?.size.height ?? 20.0
                self.sendButtonboardHeightLayoutConstraint?.constant = endFrame?.size.height ?? 20.0
                self.voiceButtonboardHeightLayoutConstraint?.constant = endFrame?.size.height ?? 20.0
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
    
    func scrollToBottom(){
        
        DispatchQueue.main.async {
            let indexPath = IndexPath(
                row: self.chatArray.count - 1,
                section: 0)
            self.chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chatArray.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:LeaveChatTableviewCell = tableView.dequeueReusableCell(withIdentifier: "LeaveChatTableviewCell", for: indexPath) as! LeaveChatTableviewCell
        if chatArray.count != 0{
            cell.setChatForIndex(chat: self.chatArray[indexPath.row],message:messageArray[indexPath.row])
            if (self.chatArray.count - 1) == indexPath.row {
                cell.loadingImage.isHidden = false
            }
        }
        return cell
    }
    
    //MARK:- text to speech
    func speakText(message:String) {
        let utterance = AVSpeechUtterance(string: message)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        
        let synth = AVSpeechSynthesizer()
        synth.speak(utterance)
    }
    
    //MARK: - Check Authorization Status
    
    func requestSpeechAuthorization() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    self.recordButton.isEnabled = true
                case .denied:
                    self.recordButton.isEnabled = false
                    self.messageTextField.text = "User denied access to speech recognition"
                case .restricted:
                    self.recordButton.isEnabled = false
                    self.messageTextField.text = "Speech recognition restricted on this device"
                case .notDetermined:
                    self.recordButton.isEnabled = false
                    self.messageTextField.text = "Speech recognition not yet authorized"
                }
            }
        }
    }
    //MARK: - Recognize Speech
    
    func recordAndRecognizeSpeech() {
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        do{
             node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
                self.request.append(buffer)
            }
        } catch {
            return print(error)
        }
        
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            self.sendAlert(message: "There has been an audio engine error.")
            return print(error)
        }
        guard let myRecognizer = SFSpeechRecognizer() else {
            self.sendAlert(message: "Speech recognition is not supported for your current locale.")
            return
        }
        if !myRecognizer.isAvailable {
            self.sendAlert(message: "Speech recognition is not currently available. Check back at a later time.")
            // Recognizer is not available right now
            return
        }
        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { result, error in
            if let result = result {
                
                let bestString = result.bestTranscription.formattedString
                self.messageTextField.text = bestString
                
                var lastString: String = ""
                for segment in result.bestTranscription.segments {
                    let indexTo = bestString.index(bestString.startIndex, offsetBy: segment.substringRange.location)
                    lastString = bestString.substring(from: indexTo)
                }
            } else if let error = error {
                if self.messageTextField.text?.count == 0 {
                    self.sendAlert(message: "There has been a speech recognition error.")
                }
                print(error)
            }
        })
    }
    
    //MARK: - Alert
    
    func sendAlert(message: String) {
        let alert = UIAlertController(title: "Speech Recognizer Error", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
//custom text field
class TextField: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
