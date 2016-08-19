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
    
    private var placeholderLabel:UILabel!
    
    // when the font is set, apply it to the placeholder as well so they always match
    public override var font: UIFont? {
        didSet {
            placeholderLabel?.font = font
            setNeedsDisplay()
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
    
    func textChanged(notification:NSNotification) {
        // only pick up notifications that came from this object
        if notification.object as! PlaceholderTextView == self {
            
            // hide the placeholder if we actually have text typed in
            placeholderLabel.hidden = (textStorage.length != 0)
        }
    }
    
    private func setup() {
        // Create a placeholder label with default text and font, then size to fit
        placeholderLabel = UILabel()
        placeholderLabel.text = placeholderText
        placeholderLabel.font = self.font
        placeholderLabel.sizeToFit()
        
        // add the placeholder label to the UITextView and setup contraints for adaptive design support
        self.addSubview(placeholderLabel)
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // add constraints to display the placeholder text in the proper place dependent on the insets
        placeholderLabel.topAnchor.constraintEqualToAnchor(topAnchor,
                                                           constant: textContainerInset.top).active = true
        
        placeholderLabel.leadingAnchor.constraintEqualToAnchor(leadingAnchor,
                                                               constant: textContainerInset.left+5).active = true
        
        placeholderLabel.trailingAnchor.constraintEqualToAnchor(trailingAnchor).active = true
        
        
        
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



