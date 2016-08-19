//
//  RoundedCornerButton.swift
//  TLM
//
//  Created by Jensen Andria on 2/4/16.
//  Copyright © 2016 HCA, Inc. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable public class RoundedCornerButton: UIButton {
    
    /**
     The width of the border to be applied to the label.  Default is 2 pixels.
     */
    @IBInspectable public var borderWidth:CGFloat = 2.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    /**
     The color of the border to be applied to the label.  Default is light gray.
     */
    @IBInspectable public var borderColor:UIColor = UIColor.lightGrayColor() {
        didSet {
            layer.borderColor = borderColor.CGColor
        }
    }
    
    /**
     The radius of the rounded corners.  Default is 5.0.
     */
    @IBInspectable public var cornerRadius:CGFloat = 5.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    public override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        clipsToBounds = true
    }
    
    
}



