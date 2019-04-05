//
//  UIViewController+Storyboard.swift
//  PersonalCare
//
//  Created by UVIONICS on 26/12/17.
//  Copyright © 2017 Uvionics. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    class func initWithStoryboardID(storyboardName:String, name : String) -> UIViewController {
        return UIStoryboard.init(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: name)
    }
}


extension UIViewController {
    enum Storyboard:String{
        case account = "Account"
        case home = "Home"
        case measure = "Measure"
        case result = "Result"
        case notification = "Notification"
        case customViews = "CustomViews"
        case dataFetch = "DataFetch"
    }
    class func initWithStoryboardID(storyboard:Storyboard, name : String) -> UIViewController {
        return UIStoryboard.init(name: storyboard.rawValue, bundle: nil).instantiateViewController(withIdentifier: name)
    }
}

