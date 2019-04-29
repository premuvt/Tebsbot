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


class ApplyLeaveViewController: UIViewController, LeaveTypePickerDelegate{
  

    @IBOutlet weak var textViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var messageTextView: UITextView!
    
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var attachButton: UIButton!
    @IBOutlet weak var leaveTypeButton: UIButton!
    @IBOutlet weak var noThanks: UIButton!
    @IBOutlet weak var showBalance: UIButton!
    
    @IBOutlet var optionsView: UIView!
    @IBOutlet var chatVoiceAndTextView: UIView!
    @IBOutlet var selectLeaveTypeView: UIView!
    @IBOutlet weak var footerContinerView: UIView!
    @IBOutlet var documentView: UIView!
    @IBOutlet weak var recordButton: UIButton!
    
    @IBOutlet weak var sendButton: UIButton!
    //MARK:- speet to text
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer(locale: NSLocale.current)
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    var isRecording = false
    var synth:AVSpeechSynthesizer = AVSpeechSynthesizer()
    var start:String = "1"
    var reason:String = "0"
    var document:String = "0"
    var reasonText:String = ""
    
    var imagePicker = UIImagePickerController()
    var selectedImage: UIImage? = nil
    var fileName:String? = ""
    
//    let messageFrame = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))

    
    
    var chatArray:[LeaveChatModal]! = []
    var messageArray: [String] = [""]
    var chatMessage: String = ""
    var autoSendTimer:Timer!
    
    let noThanksString = "No thanks, Im good!"
    let showBalanceString = "Show my Leave Balance"
    
    var leaveBalanceFlag = false
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpKeyBoardNotification()
        setUIBoarder()
        speakText(message: sayIntroMessage())
        self.footerContinerView.addSubview(self.optionsView)
        self.optionsView.bindFrameToSuperviewBounds()
        
        self.chatTableView.rowHeight = UITableView.automaticDimension
        self.chatTableView.estimatedRowHeight = 200.0
        
        imagePicker.modalPresentationStyle = UIModalPresentationStyle.currentContext
        imagePicker.delegate = self

//        print("laguage code - ",Locale.current.languageCode!)
//        print("reagin local - ", NSLocale.current.identifier)
//        print("Supported locals - ",SFSpeechRecognizer.supportedLocales())
        
        //for speech recogonition
        self.requestSpeechAuthorization()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if messageArray.count != 0{
            self.chatTableView.reloadData()
            self.scrollToBottom()
        }
        
//        self.speakText(message: "Hi sir, now you can also apply leave by speak. Please tap the mic button on bottom right corner to speak.")
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
        
        self.messageTextView.delegate = self
        //message text field
        self.messageTextView.layer.borderWidth = 1
        self.messageTextView.layer.cornerRadius = 10
        self.messageTextView.layer.borderColor = UIColor.gray.cgColor
        
        //inset
        self.messageTextView.textContainerInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    }
    func sendMessage(message: String? = ""){
        if message != ""{
            debugPrint("message : ========= ",message!)
            self.activityIndicator("Sending...")
            updateMessageAndSendTime(message: message!)
            if reason == "1" {
                reasonText = message!
            }
            
            WebService.shared.applyLeaveChat(message: chatMessage, reason: reason, document: document, start: start, reasonText: reasonText) { (status, errorMessage, chatModel) in
                
                if self.start == "1" {
                    self.start = "0"
                }
                DispatchQueue.main.sync {
                    self.showBalance.isEnabled = true
                    self.noThanks.isEnabled = true
                    self.recordButton.isEnabled = true
                    self.attachButton.isEnabled = true
                    self.cameraButton.isEnabled = true
                    self.skipButton.isEnabled = true
                    self.sendButton.isEnabled = true
                    self.stopActivity()
                    self.messageTextView.text = ""
                }

                if status{
                    if chatModel?.message == "continue"{
                         DispatchQueue.main.sync {
                        self.updateFooterViewBasedOn(chatModal: chatModel!)
                        }
                        self.chatArray.append(chatModel!)
                        DispatchQueue.main.sync {
                            if message?.range(of: "Show my Leave Balance") != nil {
                                 self.leaveBalanceFlag = true
                            }
                            self.chatTableView.reloadData()
                            DispatchQueue.main.async {
                                self.scrollToBottom()
                            }
                            
                        }
                        if let question = chatModel?.data?.query {
                            self.speakText(message: question)
                        }
                        
                    }else{
                        debugPrint("move to next page")
                        DispatchQueue.main.sync {
                            self.goNextStep(chatModel: chatModel!)
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
    func updateFooterViewBasedOn(chatModal:LeaveChatModal) {
        if chatModal.data?.doc_flag! == "1"{
            self.document = "1"
            self.reason = "0"
            removeMessageViewAddDocumentView()
        }
        else if chatModal.data?.type_flag! == "1"{
            removeMessageViewAddLeaveTypeView()
        }
        else if chatModal.data?.reason_flag! == "1"{
            removeLeaveTypeViewAddMessageView()
            self.document = "0"
            self.reason = "1"
        }
        else if chatModal.data?.date_flag == "1"{
            removeOptionsViewAddMessageView()
        }
    }
    func updateMessageAndSendTime(message:String) {
        if messageArray.count == 1 && messageArray[0].count == 0 {
            messageArray.removeAll()
            messageArray = []
            self.messageArray.append(message)
            chatMessage = message
        }
        else if message == showBalanceString || message == noThanksString {
        }
        else{
            self.messageArray.append(message)
            for i in 0 ..< messageArray.count{

                chatMessage.append(messageArray[i])
                chatMessage.append(" ")
            }
        }
        
        var chat = chatArray[chatArray.count - 1]
        chat.sendDate = Date()
        chatArray[chatArray.count - 1] = chat
        self.chatTableView.reloadData()
        
    }
//    func updateChat(chat:LeaveChatModal) {
//        let lastChatObj = self.chatArray[self.chatArray.count - 1]
//        lastChatObj
//
//    }
    let jsonString = """
{
    "data": {
        "final_flag": 0,
        "query": "Hi, Im Leevo, I will help you apply for a leave. Do you wish to check your leave balance before we start?",
        "Sentence": null,
        "Leave": null,
        "type": "not specified",
        "Date": null,
        "from_date": "",
        "end_date": "",
        "date_flag": "0",
        "type_flag": "0",
        "reason_flag": "0",
        "doc_flag": "0"
    },
    "message": "",
    "flag": true
}
"""
    func sayIntroMessage() -> String {
        let jsonData = jsonString.data(using: .utf8)!
        let initialChat = try! JSONDecoder().decode(LeaveChatModal.self, from: jsonData)
        print(initialChat.data?.query!)
        self.chatArray.append(initialChat)
        self.chatTableView.reloadData()
        
        return (initialChat.data?.query!)!
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
        button.addTarget(self, action:#selector(ApplyLeaveViewController.backAction), for:.touchUpInside)
        button.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30) //CGRectMake(0, 0, 30, 30)
        let barButton = UIBarButtonItem.init(customView: button)
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        synth.stopSpeaking(at: .immediate)
    }
    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func onSend(_ sender: Any) {
        print("on send click")
        chatMessage.removeAll()
        let message = self.messageTextView.text!
        if message.count != 0 && message != ""{
            self.messageTextView.resignFirstResponder()
            //stop recording if it is recording
            if isRecording {
                self.recordButton.sendActions(for: .touchUpInside)
            }
            debugPrint("Chat Message : =========== ",message)
            self.sendMessage(message: message)
            self.sendButton.isEnabled = false
        }else{
            debugPrint("enter a message a to send")
        }
    }
    @IBAction func onRecord(_ sender: Any) {
        self.messageTextView.resignFirstResponder()
        if isRecording == true {
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
            recognitionTask?.cancel()
            isRecording = false
            recordButton.tintColor = UIColor.black
            
        } else {
//            synth.stopSpeaking(at: .immediate)
            self.recordAndRecognizeSpeech()
            isRecording = true
            recordButton.tintColor = UIColor.red
        }
    }
    @IBAction func onLeaveBalance() {
        print("onLeaveBalance")
        let message = showBalanceString
        self.showBalance.isEnabled = false
        self.noThanks.isEnabled = false
        self.sendMessage(message: message)
//        removeOptionsViewAddMessageView()
    }
    @IBAction func onNoThanks() {
        print("onNoThanks")
        self.showBalance.isEnabled = false
        self.noThanks.isEnabled = false
        let message = noThanksString
        
        self.sendMessage(message: message)
//        removeOptionsViewAddMessageView()
    }
    @IBAction func onSelectLeaveType() {
        print("onSelectLeaveType")
        self.leaveTypeButton.isEnabled = false
        
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let controller:LeaveTypePickerViewController = storyboard.instantiateViewController(withIdentifier: "LeaveTypePickerViewController") as! LeaveTypePickerViewController
        controller.delegate = self
        self.present(controller, animated: true, completion: nil)
    }
    @IBAction func onAttach() {
        print("onAttach")
        self.attachButton.isEnabled = false
        self.cameraButton.isEnabled = false
        self.skipButton.isEnabled = false
        self.openGallery()
    }
    @IBAction func onCamera() {
        print("onCamera")
        self.attachButton.isEnabled = false
        self.cameraButton.isEnabled = false
        self.skipButton.isEnabled = false
        self.openCamera()
    }
    @IBAction func onSkip() {
        print("onSkip")
        self.attachButton.isEnabled = false
        self.cameraButton.isEnabled = false
        self.skipButton.isEnabled = false
        sendMessage(message: "file")
//        let chat:LeaveChatModal = self.chatArray.last!
//        goNextStep(chatModel: chat)
    }
    func goNextStep(chatModel:LeaveChatModal) {
        self.chatArray.append(chatModel)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller:LeaveApplicationViewController = storyboard.instantiateViewController(withIdentifier: "LeaveApplicationViewController") as! LeaveApplicationViewController
        if self.selectedImage != nil {
            controller.selectedImage = self.selectedImage
            controller.imageSelected = true
        }
        
        controller.startDate = self.getDate(stringDate: (chatModel.data?.from_date!)!)
        controller.endDate = self.getDate(stringDate: (chatModel.data?.end_date!)!)
        controller.reason = reasonText
        controller.isFromBot = true
        controller.leaveType = chatModel.data?.type
        if ["medical","annual"].contains(chatModel.data?.type?.lowercased())
        {
            controller.totalLeave = 12
            controller.takenLeave = 10
        }
        else if ["compensatory"].contains(chatModel.data?.type?.lowercased()) {
            controller.totalLeave = 1
            controller.takenLeave = 1
        }
        else {
            controller.totalLeave = 10
            controller.takenLeave = 8
        }
        let navigationController =  UINavigationController(rootViewController: controller)
        self.present(navigationController, animated: true, completion: nil)
    }
    func removeOptionsViewAddMessageView() {
        self.optionsView.removeFromSuperview()
        self.footerContinerView.addSubview(self.chatVoiceAndTextView)
        self.chatVoiceAndTextView.bindFrameToSuperviewBounds()
    }
    func removeMessageViewAddLeaveTypeView() {
        self.chatVoiceAndTextView.removeFromSuperview()
        self.footerContinerView.addSubview(self.selectLeaveTypeView)
        self.selectLeaveTypeView.bindFrameToSuperviewBounds()
    }
    func removeLeaveTypeViewAddMessageView() {
        self.selectLeaveTypeView.removeFromSuperview()
        self.footerContinerView.subviews.forEach({ $0.removeFromSuperview() })
        self.footerContinerView.addSubview(self.chatVoiceAndTextView)
        self.chatVoiceAndTextView.bindFrameToSuperviewBounds()
    }
    func removeMessageViewAddDocumentView() {
        self.chatVoiceAndTextView.removeFromSuperview()
        self.footerContinerView.addSubview(self.documentView)
        self.documentView.bindFrameToSuperviewBounds()
    }
    
    
}
//MARK:- extension
extension ApplyLeaveViewController: UITableViewDelegate, UITableViewDataSource, SFSpeechRecognizerDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.selectedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imagePicker.dismiss(animated: true, completion: nil)
        self.attachButton.isEnabled = false
        self.cameraButton.isEnabled = false
        self.skipButton.isEnabled = false
        self.sendMessage(message: "file")
        self.chatTableView.reloadData()
        //        self.buttonupload.isUserInteractionEnabled = true
        //        self.buttonupload.isEnabled = true
        if imagePicker.sourceType != .camera{
            let imageURL = info[UIImagePickerController.InfoKey.referenceURL] as! NSURL
            
            self.fileName = imageURL.absoluteString
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let alertWarning = UIAlertController(title: "TebsBot", message: "You don't have camera", preferredStyle: .alert)//UIAlertView(title:"Warning", message: "You don't have camera", delegate:nil, cancelButtonTitle:"OK", otherButtonTitles:"")
            let cancelAction = UIAlertAction(title: "OK", style: .cancel)
            {
                UIAlertAction in
                self.dismiss(animated: false, completion: nil)
                
            }
            alertWarning.addAction(cancelAction)
            self.present(alertWarning, animated: true, completion: nil)
        }
    }
    func openGallery(){
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func dismissAlert() {
    }
    
    
    //MARK:- textview returnkey
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
        }
        return true
    }
    //MARK: - Key notification
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameY = endFrame!.origin.y
            let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            if endFrameY >= UIScreen.main.bounds.size.height {
                self.textViewConstraint?.constant = 0.0
            } else {
                self.textViewConstraint?.constant = (-1 * (endFrame?.size.height)!) 
                
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
            DispatchQueue.main.async {
                self.scrollToBottom()
                
            }
            
        }
    }
    
    func scrollToBottom(){
        
                var rowCount = self.messageArray.count - 1
            if self.chatArray.count > self.messageArray.count {
                rowCount = self.chatArray.count - 1
            }
            let indexPath = IndexPath(
                row: rowCount,
                section: 0)
        if self.navigationController!.visibleViewController! is ApplyLeaveViewController{
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
        if document == "1" && indexPath.row == (chatArray.count - 1)
        {
            let chat = self.chatArray[indexPath.row]
            
            let imageCell:LeaveChatImageCell = tableView.dequeueReusableCell(withIdentifier: "LeaveChatImageCell", for: indexPath) as! LeaveChatImageCell
            if selectedImage != nil {
                imageCell.docImage.isHidden = false
                imageCell.docImage.image = selectedImage
            }
            else{
                imageCell.docImage.isHidden = true
            }
            imageCell.receivedMessageLabel.layer.masksToBounds = true
            imageCell.receivedMessageLabel.layer.cornerRadius = 10
            imageCell.receivedMessageLabel.text = chat.data?.query
            imageCell.receivedTimeLabel.text = self.setTime(curDate: chat.receivedDate)
            return imageCell
        }
        if chatArray.count != 0 {
            var sendMessage:String! = ""
            if messageArray.count > indexPath.row
            {
                sendMessage = messageArray[indexPath.row]
            }
            cell.setChatForIndex(chat: self.chatArray[indexPath.row],message:sendMessage)
            if leaveBalanceFlag && indexPath.row == 1 && messageArray[0] == "Show my Leave Balance" {
//                leaveBalanceFlag = false
                let leaveBalanceMessage = "Medical Leaves       10/12\nAnnual Leaves      8/12\nCompensatory Off        5/12\nChild Care Leave      10/12\n\n"
                cell.messageReceiveLabel.text = leaveBalanceMessage + cell.messageReceiveLabel.text!
            }
            
        }
        return cell
    }
    func setTime(curDate:Date) -> String{
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let myString = formatter.string(from: curDate)
        return myString// string
    }
    func getDate(stringDate:String) -> Date{
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "dd-MM-yyyy"
        
        let date = formatter.date(from: stringDate)
        return date!// string
    }
        
    //MARK:- text to speech
    func speakText(message:String) {
        let utterance = AVSpeechUtterance(string: message)
        utterance.voice = AVSpeechSynthesisVoice(language: NSLocale.current.identifier)
        utterance.volume = 1.0
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
                    self.messageTextView.text = "User denied access to speech recognition"
                case .restricted:
                    self.recordButton.isEnabled = false
                    self.messageTextView.text = "Speech recognition restricted on this device"
                case .notDetermined:
                    self.recordButton.isEnabled = false
                    self.messageTextView.text = "Speech recognition not yet authorized"
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
                self.messageTextView.text = bestString
                self.autoSendTimer?.invalidate()

                    self.autoSendTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.sendAction), userInfo: nil, repeats: false)
                
                var lastString: String = ""
                for segment in result.bestTranscription.segments {
                    let indexTo = bestString.index(bestString.startIndex, offsetBy: segment.substringRange.location)
                    lastString = bestString.substring(from: indexTo)
                }
            } else if let error = error {
                if self.messageTextView.text?.count == 0 {
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
    
    @objc func sendAction() {
        self.sendButton.sendActions(for: .touchUpInside)
    }
    //leavetype picker delegate methords
    func didSelectLeaveType(leaveatype:String,total:Int,taken:Int){
        print(leaveatype,total,taken)
        self.leaveTypeButton.titleLabel?.text = leaveatype.capitalized
        self.sendMessage(message: leaveatype)
    }
    func cancelledLeavePicker(){
        print("cancelled picker")
    }
}
extension UIView {
    
    /// Adds constraints to this `UIView` instances `superview` object to make sure this always has the same size as the superview.
    /// Please note that this has no effect if its `superview` is `nil` – add this `UIView` instance as a subview before calling this.
    func bindFrameToSuperviewBounds() {
        guard let superview = self.superview else {
            print("Error! `superview` was nil – call `addSubview(view: UIView)` before calling `bindFrameToSuperviewBounds()` to fix this.")
            return
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: superview.topAnchor, constant: 0).isActive = true
        self.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: 0).isActive = true
        self.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: 0).isActive = true
        self.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: 0).isActive = true
        
    }
}
