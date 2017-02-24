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
open class SelectableButton:RoundedCornerButton {
    
    /**
     Captures when the button is selected, so we change the background color
     */
    open override var isSelected: Bool {
        didSet {
            updateColors()
        }
    }
    
    /**
     Determines whether the button will toggle selected state on a touch up inside event.
     */
    
    @IBInspectable open var touchToSelect:Bool = true
    
    /**
     The background color when the button is selected. Default is a light gray.
     */
    @IBInspectable open var selectedBackgroundColor:UIColor = UIColor.lightGray {
        didSet {
            updateColors()
        }
    }
    
    /**
     The background color when the button is deselected (normal).  Default is dark gray.
     */
    @IBInspectable open var deselectedBackgroundColor:UIColor = UIColor.darkGray {
        didSet {
            updateColors()
        }
    }
    
    func updateColors() {
        backgroundColor = (isSelected ? selectedBackgroundColor : deselectedBackgroundColor)
        borderColor = (isSelected ? deselectedBackgroundColor : selectedBackgroundColor)
        setTitleColor(selectedBackgroundColor, for: UIControlState())
        setTitleColor(deselectedBackgroundColor, for: .selected)
        
        imageView?.tintColor = borderColor
    }
    
    @objc fileprivate func touched() {
        if touchToSelect {
            self.isSelected = !isSelected
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
        selectedBackgroundColor = UIColor.lightGray
        deselectedBackgroundColor = UIColor.darkGray
        cornerRadius = 4.0
        borderWidth = 1.0
        tintColor = UIColor.clear
        
        // update colors on button
        updateColors()
        
        // handle the touch event to do the selection if turned on
        self.addTarget(self, action: #selector(touched), for: .touchUpInside)
    }
}
