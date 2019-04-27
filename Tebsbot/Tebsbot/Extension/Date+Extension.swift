//
//  Date+Extension.swift
//  Tebsbot
//
//  Created by uvionics on 26/04/19.
//  Copyright © 2019 Premraj C Ramankutty. All rights reserved.
//

import Foundation
extension Date{
    
    var ticks: UInt64 {
        return UInt64(self.timeIntervalSince1970)
    }
    func setTimeFormat() -> String{
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "dd-MM-yy"
        
        let myString = formatter.string(from: self)
        return myString// string
    }
    func setTimeFormatwithYear() -> String{
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "dd-MM-yyyy"
        
        let myString = formatter.string(from: self)
        return myString// string
    }
}
