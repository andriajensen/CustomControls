//
//  BorderedTextView.swift
//  rounding
//
//  Created by Jensen Andria on 6/9/16.
//  Copyright © 2016 HCA, Inc. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable open class BorderedTextView:PlaceholderTextView {
    
    
    /**
     The color of the border around the text view.  Default is light gray.
     */
    @IBInspectable open var borderColor:UIColor = UIColor.lightGray {
        didSet {
            // animate a change to the border color
            let colorChange = CABasicAnimation(keyPath: "borderColor")
            
            colorChange.fromValue = layer.borderColor
            colorChange.toValue = borderColor
            
            layer.borderColor = borderColor.cgColor
            layer.add(colorChange, forKey: "borderColor")
        }
    }
    
    
    /** 
     The corner radius to control how rounded the text view's corner are.  Default is 4.
     */
    @IBInspectable open var cornerRadius:CGFloat = 4.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    /**
     The width of the border to be applied to the label.  Default is 1 pixels.
     */
    @IBInspectable open var borderWidth:CGFloat = 1.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setup()
    }
    
    fileprivate func setup() {
        cornerRadius = 4.0
        borderWidth = 1.0
        borderColor = UIColor.lightGray
    }
    
    
}

