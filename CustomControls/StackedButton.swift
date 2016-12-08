//
//  StackedButton.swift
//  rounding
//
//  Created by Jensen Andria on 6/10/16.
//  Copyright © 2016 HCA, Inc. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
open class StackedButton:SelectableButton {
    
    /**
     The vertical padding between the image and the text.  Default is 6.0.
     */
    @IBInspectable open var padding:CGFloat = 6.0 {
        didSet {
            adjustInsets()
        }
    }
    
    // override layoutSubviews since we are messing with the insets
    open override func layoutSubviews() {
        super.layoutSubviews()
        adjustInsets()
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // set default values for this button, and get defaults from super
    override func setup() {
        super.setup()
        padding = 6.0
        adjustInsets()
    }
    
    func adjustInsets() {
        
        // get the size of the image and title, then add padding to get a total height
        let imageSize = self.imageView!.frame.size
        let titleSize = self.titleLabel!.frame.size
        let totalHeight = imageSize.height + titleSize.height + padding
        
        // adjust image insets to account for the title
        self.imageEdgeInsets = UIEdgeInsets(
            top: -(totalHeight - imageSize.height),
            left: 0,
            bottom: 0,
            right: -titleSize.width
        )
        
        // adjust title insets to account for the image
        self.titleEdgeInsets = UIEdgeInsets(
            top: 0,
            left: -imageSize.width,
            bottom: -(totalHeight - titleSize.height),
            right: 0
        )
        
    }
    
}

