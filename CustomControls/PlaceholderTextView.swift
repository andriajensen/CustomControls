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
public class PlaceholderTextView: UITextView {
    
    private var placeholderLabel:UILabel!
    
    /**
     The placeholder text the text view will display.  Default is an empty string.
     */
    @IBInspectable public var placeholderText:String = "" {
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
    @IBInspectable public var placeholderTextColor:UIColor = UIColor.lightGrayColor() {
        didSet {
            placeholderLabel?.textColor = placeholderTextColor
        }
    }
    
    // when the font is set, apply it to the placeholder as well so they always match
    public override var font: UIFont? {
        didSet {
            placeholderLabel?.font = font
            setNeedsDisplay()
        }
    }
    
    func textChanged(notification:NSNotification) {
        // only pick up notifications that came from this object
        if notification.object as! PlaceholderTextView == self {
            
            // hide the placeholder if we actually have text typed in
            placeholderLabel.hidden = (textStorage.length != 0)
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
    
    private func setup() {
        
        // Create a placeholder label with default text and color
        placeholderLabel = UILabel()
        placeholderTextColor = UIColor.lightGrayColor()
        placeholderText = ""
        
        // add the placeholder label to the UITextView and setup contraints for adaptive design support
        addSubview(placeholderLabel)
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false

        // add constraints to display the placeholder text in the proper place dependent on the insets
        NSLayoutConstraint.activateConstraints([
            placeholderLabel.topAnchor.constraintEqualToAnchor(topAnchor, constant: textContainerInset.top),
            placeholderLabel.leadingAnchor.constraintEqualToAnchor(leadingAnchor, constant: textContainerInset.left+5),
            placeholderLabel.trailingAnchor.constraintEqualToAnchor(trailingAnchor)
        ])
        
        // Handle text changes so we hide/show the placeholder appropriately
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(textChanged),
                                                         name: UITextViewTextDidChangeNotification,
                                                         object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(textChanged),
                                                         name: UITextViewTextDidBeginEditingNotification,
                                                         object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(textChanged),
                                                         name: UITextViewTextDidEndEditingNotification,
                                                         object: nil)
        
    }

}



