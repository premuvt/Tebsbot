//
//  UIAlert.swift
//  Tebsbot
//
//  Created by uvionics on 10/04/19.
//  Copyright © 2019 Premraj C Ramankutty. All rights reserved.
//

import Foundation
import UIKit

public enum Actions{
    case logout
    case cancel
}
extension UIAlertController{
    func alertWithOkCancelButton(view:UIViewController,okAction:Actions){
        let okAction = UIAlertAction.init(title: "Logout", style: .default) { (success) in
            switch okAction{
            case .logout:
                (UIApplication.shared.delegate as! AppDelegate).navigatetoLoginPage()
            default:
                self.dismiss(animated: true, completion: nil)
            }
        }
        let cancelAction = UIAlertAction.init(title: "Continue", style: .cancel) { (success) in
                self.dismiss(animated: true, completion: nil)
           }
        self.addAction(okAction)
        self.addAction(cancelAction)
        view.present(self, animated: true, completion: nil)
        
    }
    func alertWithOkButton(view:UIViewController){
        
    }
    func alertWithOkButton(){
        
    }
}
