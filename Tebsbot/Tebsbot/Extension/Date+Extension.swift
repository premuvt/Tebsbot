//
//  Date+Extension.swift
//  Tebsbot
//
//  Created by uvionics on 26/04/19.
//  Copyright © 2019 Premraj C Ramankutty. All rights reserved.
//

import Foundation
extension Date{
    func setTimeFormat() -> String{
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "yyyy-MM-dd"
        
        let myString = formatter.string(from: self)
        return myString// string
    }
}
