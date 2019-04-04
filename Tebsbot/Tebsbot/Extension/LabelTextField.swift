//
//  LabelTextField.swift
//  CustomViews
//
//  Created by uvionics on 21/11/17.
//  Copyright © 2017 uvionics. All rights reserved.
//

import UIKit

@IBDesignable
class LabelTextField: LineTextField {
    @IBInspectable var labelText: String = "" {
        didSet{
            setNeedsDisplay()
        }
    }
    @IBInspectable var fontColor:UIColor = UIColor.black {
        didSet{
            setNeedsDisplay()
        }
    }
    @IBInspectable var fontSize:CGFloat = 10 {
        didSet{
            setNeedsDisplay()
        }
    }
    var label = UILabel()
    var view = UIView()
    var showPasswordView = UIView()
    var eyeButton = UIButton()
    override func draw(_ rect: CGRect) {
        // Drawing code
        super.draw(rect)
//        view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: rect.width * 0.4, height: rect.height))
//        view.backgroundColor = UIColor.clear
//        label = UILabel.init(frame: view.bounds)
//        label.frame.size.width -= 5
//        label.textAlignment = NSTextAlignment.left
////        label.text = l
////        label.place
//        label.font = UIFont(name: "SEGOEUI", size: 14.0)
//        label.textColor = fontColor
//        view.frame.size.width = label.intrinsicContentSize.width + 10
//        view.addSubview(label)
//        leftView = view
//        leftViewMode = UITextFieldViewMode.always
        
        // RightView
//        showPasswordView = UIView.init(frame: CGRect(x: 0, y: 0, width:rect.height, height: rect.height))
//        showPasswordView.backgroundColor = .red
////        eyeButton = UIButton.init(frame: showPasswordView.bounds)
////        eyeButton.frame.size.width -= 2
////        eyeButton.titleLabel?.textAlignment = NSTextAlignment.right
////        eyeButton.setTitle("hi", for: .normal)
////
////        showPasswordView.frame.size.width = eyeButton.intrinsicContentSize.width + 10
////        showPasswordView.addSubview(eyeButton)
//        rightView = showPasswordView
//        rightViewMode = UITextFieldViewMode.always
        
    }
    override func awakeFromNib() {
//        NotificationCenter.default.addObserver(self, selector: #selector(self.rotated), name: NSNotification.Name.UIDevice.orientationDidChangeNotification, object: nil)
    }
    @objc func rotated() {
        setNeedsDisplay()
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
