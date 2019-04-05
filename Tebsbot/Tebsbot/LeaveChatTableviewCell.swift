//
//  LeaveChatTableviewCell.swift
//  Tebsbot
//
//  Created by Premraj C Ramankutty on 05/04/19.
//  Copyright © 2019 Premraj C Ramankutty. All rights reserved.
//

import Foundation
import UIKit

class LeaveChatTableviewCell: UITableViewCell {
    
    
    @IBOutlet weak var timeLabelSend: UILabel!
    
    @IBOutlet weak var messageSendLable: UILabel!
    @IBOutlet weak var timeLabelReceiv: UILabel!
    @IBOutlet weak var messageReceiveLabel: UILabel!
    @IBOutlet weak var loadingImage: UIImageView!
    override func awakeFromNib() {
        
    }
    
    func setChatForIndex(chat:LeaveChatModal,message:String) {
        self.timeLabelSend.text = setTime(curDate: chat.currentDate)
        self.messageSendLable.text = message
        self.messageReceiveLabel.text = chat.data?.question
        self.timeLabelReceiv.text = self.setTime(curDate: Date())
    }
    func setTime(curDate:Date) -> String{
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let myString = formatter.string(from: Date())
        return myString// string
    }
}
