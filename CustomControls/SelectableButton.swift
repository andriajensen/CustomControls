//
//  SelectableButton.swift
//  rounding
//
//  Created by Jensen Andria on 6/12/16.
//  Copyright © 2016 HCA, Inc. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
public class SelectableButton:RoundedCornerButton {
    
    /**
     Captures when the button is selected, so we change the background color
     */
    public override var selected: Bool {
        didSet {
            updateBackgroundColor()
        }
    }
    
    /**
     The background color when the button is selected. Default is a light gray.
     */
    @IBInspectable public var selectedBackgroundColor:UIColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.5) {
        didSet {
            updateBackgroundColor()
        }
    }
    
    /**
     The background color when the button is deselected (normal).  Default is clear.
     */
    @IBInspectable public var deselectedBackgroundColor:UIColor = UIColor.clearColor() {
        didSet {
            updateBackgroundColor()
        }
    }
    
    private func updateBackgroundColor() {
        backgroundColor = (selected ? selectedBackgroundColor : deselectedBackgroundColor)
    }
    
    public override func prepareForInterfaceBuilder() {
        tintColor = UIColor.clearColor()
    }
}
