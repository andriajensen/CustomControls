//
//  PlaceholderTextView.swift
//  rounding
//
//  Created by Jensen Andria on 6/12/16.
//  Copyright © 2016 HCA, Inc. All rights reserved.
//

import UIKit

@available(iOS 9.0, *)
@IBDesignable
open class PlaceholderTextView: UITextView {
    
    fileprivate var placeholderLabel:UILabel!
    
    /**
     The placeholder text the text view will display.  Default is an empty string.
     */
    @IBInspectable open var placeholderText:String = "" {
        didSet {
            // dynamically size the placeholder label as the placeholder text is updated
            placeholderLabel?.text = placeholderText
            placeholderLabel?.sizeToFit()
            layoutIfNeeded()
        }
    }
    
    /**
     The color of the placeholder text.  Default is light gray.
     */
    @IBInspectable open var placeholderTextColor:UIColor = UIColor.lightGray {
        didSet {
            placeholderLabel?.textColor = placeholderTextColor
        }
    }
    
    // when the font is set, apply it to the placeholder as well so they always match
    open override var font: UIFont? {
        didSet {
            placeholderLabel?.font = font
            setNeedsDisplay()
        }
    }
    
    func textChanged(_ notification:Notification) {
        // only pick up notifications that came from this object
        if notification.object as! PlaceholderTextView == self {
            
            // hide the placeholder if we actually have text typed in
            placeholderLabel.isHidden = (textStorage.length != 0)
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
        
        // Create a placeholder label with default text and color
        placeholderLabel = UILabel()
        placeholderTextColor = UIColor.lightGray
        placeholderText = ""
        
        // add the placeholder label to the UITextView and setup contraints for adaptive design support
        addSubview(placeholderLabel)
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false

        // add constraints to display the placeholder text in the proper place dependent on the insets
        NSLayoutConstraint.activate([
            placeholderLabel.topAnchor.constraint(equalTo: topAnchor, constant: textContainerInset.top),
            placeholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: textContainerInset.left+5),
            placeholderLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        // Handle text changes so we hide/show the placeholder appropriately
        NotificationCenter.default.addObserver(self,
                                                         selector: #selector(textChanged),
                                                         name: NSNotification.Name.UITextViewTextDidChange,
                                                         object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(textChanged),
                                                         name: NSNotification.Name.UITextViewTextDidBeginEditing,
                                                         object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(textChanged),
                                                         name: NSNotification.Name.UITextViewTextDidEndEditing,
                                                         object: nil)
        
    }

}



