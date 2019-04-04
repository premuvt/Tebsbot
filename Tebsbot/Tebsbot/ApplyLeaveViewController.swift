//
//  ApplyLeaveViewController.swift
//  Tebsbot
//
//  Created by Premraj C Ramankutty on 04/04/19.
//  Copyright © 2019 Premraj C Ramankutty. All rights reserved.
//

import Foundation
import UIKit

class ApplyLeaveViewController: UIViewController {
    
    @IBOutlet weak var chatTableView: UITableView!
    var chatArray:[LeaveChatModal]! = []
    override func viewDidLoad() {
        super.viewDidLoad()
        sendMessage()
        chatTableView.register(UITableViewCell.self, forCellReuseIdentifier: "LeaveChatTableviewCell")
    }
    
    func sendMessage(message: String? = ""){
        WebService.shared.applyLeaveChat(message: message!) { (status, errorMessage, chatModel) in
            if status{
                
                
            }else{
                debugPrint("No chat Available")
            }
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
}
extension ApplyLeaveViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chatArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:LeaveChatTableviewCell = tableView.dequeueReusableCell(withIdentifier: "LeaveChatTableviewCell", for: indexPath) as! LeaveChatTableviewCell
        
        cell.setChatForIndex(chat: self.chatArray[indexPath.row])
        if (self.chatArray.count - 1) == indexPath.row {
            cell.loadingImage.isHidden = false
        }
        return cell
    }
    
    
    
}
