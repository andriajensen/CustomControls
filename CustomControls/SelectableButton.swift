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
            updateColors()
        }
    }
    
    /**
     Determines whether the button will toggle selected state on a touch up inside event.
     */
    
    @IBInspectable public var touchToSelect:Bool = true
    
    /**
     The background color when the button is selected. Default is a light gray.
     */
    @IBInspectable public var selectedBackgroundColor:UIColor = UIColor.lightGrayColor() {
        didSet {
            updateColors()
        }
    }
    
    /**
     The background color when the button is deselected (normal).  Default is dark gray.
     */
    @IBInspectable public var deselectedBackgroundColor:UIColor = UIColor.darkGrayColor() {
        didSet {
            updateColors()
        }
    }
    
    func updateColors() {
        backgroundColor = (selected ? selectedBackgroundColor : deselectedBackgroundColor)
        borderColor = (selected ? deselectedBackgroundColor : selectedBackgroundColor)
        setTitleColor(selectedBackgroundColor, forState: .Normal)
        setTitleColor(deselectedBackgroundColor, forState: .Selected)
        
        imageView?.tintColor = borderColor
    }
    
    @objc private func touched() {
        if touchToSelect {
            self.selected = !selected
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        
        // set defaults
        selectedBackgroundColor = UIColor.lightGrayColor()
        deselectedBackgroundColor = UIColor.darkGrayColor()
        cornerRadius = 4.0
        borderWidth = 1.0
        tintColor = UIColor.clearColor()
        
        // update colors on button
        updateColors()
        
        // handle the touch event to do the selection if turned on
        self.addTarget(self, action: #selector(touched), forControlEvents: .TouchUpInside)
    }
}
