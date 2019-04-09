//
//  UIButton.swift
//  Tebsbot
//
//  Created by uvionics on 08/04/19.
//  Copyright © 2019 Premraj C Ramankutty. All rights reserved.
//

import Foundation
import UIKit
extension UIButton{
    func setCornerRaius(){
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds =  true
    }
}
