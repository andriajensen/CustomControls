//
//  RoundImageView.swift
//  rounding
//
//  Created by Jensen Andria on 4/26/16.
//  Copyright © 2016 HCA, Inc. All rights reserved.
//

import UIKit
import QuartzCore

@IBDesignable public class RoundImageView: UIImageView {

    /**
     The color of the border to be applied to the image.  Default is light gray.
     */
    @IBInspectable public var borderColor:UIColor = UIColor.lightGrayColor() {
        didSet {
            layer.borderColor = borderColor.CGColor
        }
    }
    
    /**
     The width of the border to be applied to the image.  Default is 1 pixel.
     */
    @IBInspectable public var borderWidth:Double = 1.0 {
        didSet {
            layer.borderWidth = CGFloat(borderWidth)
        }
    }
    
    func setup() {
        layer.borderColor = UIColor.lightGrayColor().CGColor
        layer.borderWidth = 1.0
        layer.masksToBounds = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public override func layoutSubviews() {
        layer.cornerRadius = layer.frame.width/2
    }
    
    override public func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        // make sure we are filling the circle and masking by default
        contentMode = .ScaleAspectFill
        clipsToBounds = true
        
        // setup a placeholder image so we can see what it looks like when a photo is in the view
        // this image is only set for IB, and will not be set at runtime
        let bundle = NSBundle(forClass: self.dynamicType)
        image =  UIImage(named: "headshot", inBundle: bundle, compatibleWithTraitCollection: self.traitCollection)
        
    }
    
}
