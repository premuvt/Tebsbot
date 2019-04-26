//
//  LeveApplicaionModdel.swift
//  Tebsbot
//
//  Created by uvionics on 26/04/19.
//  Copyright © 2019 Premraj C Ramankutty. All rights reserved.
//

import Foundation
import UIKit

struct leaveAppUploadModel: Codable{
    var leaveType : String?
    var reason : String?
    var username : String?
    var startDate : String?
    var enddate : String?
    var appliedDateTime: Date?
    var fileName: String?
    var image : UIImage?
    
    
    enum CodingKeys: String, CodingKey {
        
        case leaveType = "leaveType"
        case reason = "reason"
        case username = "username"
        case startDate = "startDate"
        case enddate = "endDate"
        case appliedDateTime = "appliedDateTime"
        case fileName = "fileName"

    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        leaveType = try values.decodeIfPresent(String.self, forKey: .leaveType)
        reason = try values.decodeIfPresent(String.self, forKey: .reason)
        username = try values.decodeIfPresent(String.self, forKey: .username)
        startDate = try values.decodeIfPresent(String.self, forKey: .startDate)
        enddate = try values.decodeIfPresent(String.self, forKey: .enddate)
        fileName = try values.decodeIfPresent(String.self, forKey: .fileName)
        appliedDateTime = try values.decodeIfPresent(Date.self, forKey: .appliedDateTime)
    }

}
