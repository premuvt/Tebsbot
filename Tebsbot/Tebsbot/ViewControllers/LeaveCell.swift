//
//  LeaveCell.swift
//  Tebsbot
//
//  Created by Premraj C Ramankutty on 24/04/19.
//  Copyright © 2019 Premraj C Ramankutty. All rights reserved.
//

import Foundation
import UIKit

class LeaveCell: UITableViewCell {
    
    
    @IBOutlet weak var leaveStatusLabel: UILabel!
    @IBOutlet weak var leaveTypeLabel: UILabel!
    @IBOutlet weak var leaveDescriptionLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var dateRangeLabel: UILabel!
    
    override func awakeFromNib() {
        
    }
    
    func setCellData(data:Data) {
        //label cornner radious
        self.leaveStatusLabel.layer.masksToBounds = true
        self.leaveStatusLabel.layer.cornerRadius = self.leaveStatusLabel.frame.height/2
        
        //set cell data
        
        switch data.leaveType {
        case "sick":
            self.leaveTypeLabel.text = "Medical Leave"
        default:
            self.leaveTypeLabel.text = data.leaveType
        }
//        self.leaveDescriptionLabel =
        if data.leaveStatus == "PENDING" {
            self.leaveStatusLabel.text = "Approval Pending"
        }
        else{
            self.leaveStatusLabel.text = "Approved"
        }
        if let duration = data.duration {
            let dayString:String = duration>1 ? "days":"day"
            self.durationLabel.text = String(describing: duration) + " " + dayString
        }
        
        self.dateRangeLabel.text = data.startDate! + " - " + data.endDate!
    }
//    func getLeaveDescriptionFrom(timeStamp:String) -> <#return type#> {
//        <#function body#>
//    }
}
