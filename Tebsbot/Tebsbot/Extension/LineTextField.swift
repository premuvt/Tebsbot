//
//  LineTextField.swift
//  CustomViews
//
//  Created by uvionics on 21/11/17.
//  Copyright © 2017 uvionics. All rights reserved.
//

import UIKit

@IBDesignable
class LineTextField: UITextField {
    @IBInspectable var lineWidth:CGFloat = 1 {
        didSet{
            setNeedsDisplay()
        }
    }
    @IBInspectable var lineColor:UIColor = UIColor.black {
        didSet{
            setNeedsDisplay()
        }
    }
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.clear(rect)
        context?.setLineWidth(lineWidth)
        context?.beginPath()
        context?.move(to: CGPoint(x: -1, y: rect.height - lineWidth))
        context?.addLine(to: CGPoint(x: rect.width , y: rect.height - lineWidth))
        context?.setStrokeColor(lineColor.cgColor)
        context?.strokePath()
    }

}
