//
//  RoundedCornerView.swift
//  TLM
//
//  Created by Jensen Andria on 2/4/16.
//  Copyright © 2016 HCA, Inc. All rights reserved.
//

import Foundation
import UIKit


@IBDesignable open class RoundedCornerView: UIView {
    
    /**
     The width of the border to be applied to the view.  Default is 2 pixels.
     */
    @IBInspectable open var borderWidth:CGFloat = 2.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    /**
     The color of the border to be applied to the view.  Default is light gray.
     */
    @IBInspectable open var borderColor:UIColor = UIColor.lightGray {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    /**
     The radius of the rounded corners.  Default is 4.0.
     */
    @IBInspectable open var cornerRadius:CGFloat = 4.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    func setup() {
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 2.0
        layer.cornerRadius = 4.0
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
}
