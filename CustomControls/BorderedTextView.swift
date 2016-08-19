//
//  BorderedTextView.swift
//  rounding
//
//  Created by Jensen Andria on 6/9/16.
//  Copyright © 2016 HCA, Inc. All rights reserved.
//

import Foundation
import UIKit

@available(iOS 9.0, *)
@IBDesignable public class BorderedTextView:PlaceholderTextView {
    
    /**
     The color of the border around the text view.  Default is light gray.
     */
    @IBInspectable public var borderColor:UIColor = UIColor.lightGrayColor() {
        didSet {
            setup()
        }
    }
    
    /** 
     The corner radius to control how rounded the text view's corner are.  Default is 9.
     */
    @IBInspectable public var cornerRadius:CGFloat = 9.0 {
        didSet {
            setup()
        }
    }
    
    /**
     The width of the border to be applied to the label.  Default is 2 pixels.
     */
    @IBInspectable public var borderWidth:CGFloat = 2.0 {
        didSet {
            setup()
        }
    }
    
    override public func drawRect(rect: CGRect) {
        super.drawRect(rect)
        setup()
    }
    
    private func setup() {
        
        // animate a change to the border color
        let colorChange = CABasicAnimation(keyPath: "borderColor")
        
        colorChange.fromValue = layer.borderColor
        colorChange.toValue = borderColor
        
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.CGColor
        layer.cornerRadius = cornerRadius
        layer.addAnimation(colorChange, forKey: "borderColor")
    
    }
    
}

