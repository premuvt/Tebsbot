//
//  ApplyLeaveViewController.swift
//  Tebsbot
//
//  Created by Premraj C Ramankutty on 04/04/19.
//  Copyright © 2019 Premraj C Ramankutty. All rights reserved.
//

import Foundation
import UIKit

class ApplyLeaveViewController: UIViewController,confirmationDelegate {
    func didCancelClicked() {
         self.navigationController?.popViewController(animated: true)
         self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    
    var chatArray:[LeaveChatModal]! = []
    var messageArray: [String] = []
    var chatMessage: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        sendMessage()
//        chatTableView.register(UITableViewCell.self, forCellReuseIdentifier: "LeaveChatTableviewCell")
    }
    
    func sendMessage(message: String? = ""){
        if message != ""{
        WebService.shared.applyLeaveChat(message: message!) { (status, errorMessage, chatModel) in
            if status{
                if chatModel?.message == "continue"{
                self.chatArray.append(chatModel!)
                DispatchQueue.main.sync {
                    self.chatTableView.reloadData()
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
        let message = self.messageTextField.text!
        if message.count != 0 && message != ""{
            messageArray.append(message)
            if chatArray.count != 0 {
             chatMessage = "\((chatArray[chatArray.count - 1].data?.sentence!))\(message)"
            }else{
               chatMessage = message
            }
        self.sendMessage(message: chatMessage)
            self.messageTextField.text = ""
        }else{
            debugPrint("enter a message a to send")
        }
    }
    @IBAction func onRecord(_ sender: Any) {
    }
}
extension ApplyLeaveViewController: UITableViewDelegate, UITableViewDataSource {
    
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
    
    
    
}
