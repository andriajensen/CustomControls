//
//  RoundImageView.swift
//  rounding
//
//  Created by Jensen Andria on 4/26/16.
//  Copyright © 2016 HCA, Inc. All rights reserved.
//

import UIKit
import QuartzCore

@IBDesignable open class RoundImageView: UIImageView {

    /**
     The color of the border to be applied to the image.  Default is light gray.
     */
    @IBInspectable open var borderColor:UIColor = UIColor.lightGray {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    /**
     The width of the border to be applied to the image.  Default is 1 pixel.
     */
    @IBInspectable open var borderWidth:Double = 1.0 {
        didSet {
            layer.borderWidth = CGFloat(borderWidth)
        }
    }
    
    func setup() {
        // set default values
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 1.0
        layer.masksToBounds = true
        
        contentMode = .scaleAspectFill
        clipsToBounds = true
        
        // make sure we are attempting to keep a 1:1 aspect ratio
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalTo: heightAnchor, multiplier: 1.0).isActive = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    open override func layoutSubviews() {
        layer.cornerRadius = layer.frame.width/2
    }
    
    open override var intrinsicContentSize : CGSize {
        return CGSize(width: 150, height: 150)
    }
    
    open class override var requiresConstraintBasedLayout : Bool {
        return true
    }
    
    
    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        // make sure we are filling the circle and masking by default
        contentMode = .scaleAspectFill
        clipsToBounds = true
        
        // setup a placeholder image so we can see what it looks like when a photo is in the view
        // this image is only set for IB, and will not be set at runtime
        let bundle = Bundle(for: type(of: self))
        image =  UIImage(named: "headshot", in: bundle, compatibleWith: self.traitCollection)
        
    }
}
