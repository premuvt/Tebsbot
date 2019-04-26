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
    
    @IBOutlet weak var messageSendLable: PaddingLabel!
    @IBOutlet weak var timeLabelReceiv: UILabel!
    @IBOutlet weak var messageReceiveLabel: PaddingLabel!
    @IBOutlet weak var loadingImage: UIImageView!
    override func awakeFromNib() {
        
    }
    
    func setChatForIndex(chat:LeaveChatModal,message:String) {
        if chat.data?.query != "NULL"{
            self.messageReceiveLabel.isHidden = false
            self.timeLabelReceiv.isHidden = false
            self.timeLabelSend.text = setTime(curDate: chat.sendDate)
            if message.count > 0{
                self.messageSendLable.text = message
                self.messageSendLable.isHidden = false
                self.timeLabelSend.isHidden = false
            }
            else{
                self.messageSendLable.isHidden = true
                self.timeLabelSend.isHidden = true
            }
            
            self.messageReceiveLabel.text = chat.data?.query
            self.timeLabelReceiv.text = self.setTime(curDate:chat.receivedDate)
            
            //set corner radious
            self.messageReceiveLabel.layer.masksToBounds = true
            self.messageReceiveLabel.layer.cornerRadius = 10
            
            self.messageSendLable.layer.masksToBounds = true
            self.messageSendLable.layer.cornerRadius = 10
            
            
        }else{
             self.messageReceiveLabel.isHidden = true
            self.timeLabelReceiv.isHidden = true
            self.timeLabelSend.text = setTime(curDate: chat.sendDate)
            self.messageSendLable.text = message
        }

    }
    func setTime(curDate:Date) -> String{
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let myString = formatter.string(from: curDate)
        return myString// string
    }
}
@IBDesignable class PaddingLabel: UILabel {
    
    @IBInspectable var topInset: CGFloat = 10.0
    @IBInspectable var bottomInset: CGFloat = 10.0
    @IBInspectable var leftInset: CGFloat = 10.0
    @IBInspectable var rightInset: CGFloat = 10.0
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }
}
