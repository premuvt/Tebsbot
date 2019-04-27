//
//  Definitions.swift
//  Tebsbot
//
//  Created by Premraj C Ramankutty on 06/04/19.
//  Copyright © 2019 Premraj C Ramankutty. All rights reserved.
//

import Foundation
import UIKit

let BASE_URL:String                     = "https://tebsbot.uvionicstech.com/teBS-botver03/"
//let BASE_URL:String                     = "http://192.168.0.44:8082/"
let USER_MESSAGE:String                 = "user/message"
let CONFIRM_LEAVE:String                = "user/confirm-leave"
let FILE_UPLOAD:String                  = "user/file/text"
let CONFIRM_CLAIM:String                = "user/confirm-claim"
let LEAVE_LIST:String                   = "user/leave/list/"

// new

let LEAVE_UPLOAD:String                 = "user/leave"

let DEFAULT_TEXT: String                = "Select Dates"


//validationMessages
let NO_REASON : String                  = "Please select reason"
let NO_DATERANGESELECTED : String       = "No date range is selected. Select leave date that you are applying for."
let EDIT_BACKGROUND_COLOR :UIColor      = UIColor.init(red: 76/255, green: 128/255, blue: 248/255, alpha: 1.0)
let EDIT_BACKGROUND_COLOR_SELECTED :UIColor      = UIColor.init(red: 76/255, green: 128/255, blue: 248/255, alpha: 0.7)

