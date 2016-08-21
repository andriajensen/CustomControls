//
//  UIView+Image.swift
//  rounding
//
//  Created by Jensen Andria on 6/28/16.
//  Copyright © 2016 HCA, Inc. All rights reserved.
//

import Foundation
import UIKit

public extension UIView {
    public func toImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
        
        layer.renderInContext(UIGraphicsGetCurrentContext()!)
        
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return finalImage
    }
}