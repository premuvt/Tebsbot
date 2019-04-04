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
    
    func setChatForIndex(chat:LeaveChatModal) {
        self.messageSendLable.text = chat.data?.sentence
        self.messageReceiveLabel.text = chat.data?.question
    }
}
