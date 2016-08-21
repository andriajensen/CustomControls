//
//  BetterSlider.swift
//  rounding
//
//  Created by Jensen Andria on 6/28/16.
//  Copyright © 2016 HCA, Inc. All rights reserved.
//

import Foundation
import UIKit

public protocol BetterSliderDelegate {
    
    func sliderValueChanged(newValue:Int)
}

@available(iOS 9.0, *)
@IBDesignable public class BetterSlider: UIView {
    
    private var thumbSize:CGFloat = 40
    private var indicatorSize:CGFloat = 80
    
    private var slider:UISlider?
    private var indicatorLabel:UILabel?
    private var indicator:UIView?
    private var thumbLabel:UILabel?
    private var emptyThumbImage:UIImage?
    private var thumbImage:UIImage?
    
    public var delegate:BetterSliderDelegate?
    
    @IBInspectable public var minimumValue:Int = 1 {
        didSet {
            if minimumValue >= maximumValue {
                minimumValue = maximumValue-1
            }
            slider?.minimumValue = Float(minimumValue)
        }
    }
    
    @IBInspectable public var maximumValue:Int = 10 {
        didSet {
            if maximumValue <= minimumValue {
                maximumValue = minimumValue+1
            }
            slider?.maximumValue = Float(maximumValue)
        }
    }
    
    @IBInspectable public var trackColor:UIColor = UIColor.lightGrayColor() {
        didSet {
            slider?.tintColor = trackColor
            slider?.minimumTrackTintColor = trackColor
            slider?.maximumTrackTintColor = trackColor
        }
    }
    
    @IBInspectable public var value:Int {
        set {
            slider?.value = Float(newValue)
            updateThumb()
        }
        get {
            return Int(slider?.value ?? 0)
        }
    }
    
    @IBInspectable public var thumbColor:UIColor = UIColor.blueColor() {
        didSet {
            thumbLabel?.backgroundColor = thumbColor
        }
    }
    
    @IBInspectable public var valueColor:UIColor = UIColor.darkGrayColor() {
        didSet {
            thumbLabel?.textColor = valueColor
            indicatorLabel?.textColor = valueColor
        }
    }
    
    required override public init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let slider = slider {
            // anchor the slider to the bottom, center it and have it fill the available horizontal space
            slider.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activateConstraints([
                slider.centerXAnchor.constraintEqualToAnchor(centerXAnchor),
                slider.bottomAnchor.constraintEqualToAnchor(bottomAnchor, constant: 0),
                slider.leadingAnchor.constraintEqualToAnchor(leadingAnchor),
                slider.trailingAnchor.constraintEqualToAnchor(trailingAnchor),
                slider.heightAnchor.constraintEqualToConstant(50)
                ])
        }
    }
    
    override public func drawRect(rect: CGRect) {
        updateThumb()
    }
    
    override public func intrinsicContentSize() -> CGSize {
        return CGSize(width: 300, height: 100)
    }
    
    public class override func requiresConstraintBasedLayout() -> Bool {
        return true
    }
    
    public override func prepareForInterfaceBuilder() {
        self.clipsToBounds = false
    }
    
    func setupViews() {
        
        slider = UISlider()
        
        if let slider = slider {
            slider.addTarget(self, action: #selector(updateValueIndicator), forControlEvents: .TouchDragInside)
            slider.addTarget(self, action: #selector(showValueIndicator), forControlEvents: .TouchDown)
            slider.addTarget(self, action: #selector(hideValueIndicatorAnimated), forControlEvents: [.TouchUpInside])
            slider.addTarget(self, action: #selector(hideValueIndicator), forControlEvents: [.TouchUpOutside, .TouchDragExit, .TouchCancel, .TouchDragOutside])
            slider.addTarget(self, action: #selector(updateThumb), forControlEvents: [.TouchDragOutside, .TouchDragInside])
            slider.addTarget(self, action: #selector(updateValueIndicator), forControlEvents: [.ValueChanged])
            
            addSubview(slider)
            
            // create a transparent view to use as a placeholder for the thumb
            // this helps make a smooth animation instead of a thumb image always showing
            let emptyThumbView = UIView(frame:CGRectMake(0,0,thumbSize, thumbSize))
            emptyThumbView.backgroundColor = UIColor.clearColor()
            emptyThumbImage = emptyThumbView.toImage()
            slider.setThumbImage(emptyThumbImage, forState: .Normal)
            slider.setThumbImage(emptyThumbImage, forState: .Highlighted)
            
            
            thumbLabel = createThumbLabel()
            if let thumbLabel = thumbLabel {
                addSubview(thumbLabel)
            }
            
            self.userInteractionEnabled = true
            
        }
        
        minimumValue = 1
        maximumValue = 10
        trackColor = UIColor.lightGrayColor()
        thumbColor = UIColor.blueColor()
        valueColor = UIColor.whiteColor()
        value = 1
    }
    
}



// MARK: Thumb Label

extension BetterSlider {
    
    func createThumbLabel() -> UILabel {
        // make a label to use for the thumb
        // this shows instead of a slider's actual thumb image so we can animate it
        
        let label = UILabel(frame:currentThumbRect)
        label.text = "\(value)"
        label.font = UIFont.systemFontOfSize(20)
        label.backgroundColor = thumbColor
        label.textColor = valueColor
        label.textAlignment = .Center
        label.layer.cornerRadius = thumbSize/2
        label.layer.masksToBounds = true
        label.center = currentThumbCenter
        
        return label
    }
    
    private var currentThumbRect:CGRect {
        guard let slider = slider else {
            return CGRectZero
        }
        
        print("slider.value = \(slider.value)")
        return slider.thumbRectForBounds(slider.bounds, trackRect: slider.trackRectForBounds(slider.bounds), value: slider.value)
    }
    
    private var currentThumbCenter:CGPoint {
        return CGPoint(x: currentThumbRect.midX, y: currentThumbRect.midY+thumbSize+10)
    }
    
    func updateThumb() {
        guard let thumbLabel = thumbLabel else {
            return
        }
        
        // update the thumb position/text
        thumbLabel.text = "\(value)"
        thumbLabel.center = currentThumbCenter
    }
    
}


// MARK: Value Indicator Drawing

extension BetterSlider {

    func updateValueIndicator() {
        guard slider != nil else {
            return
        }
        
        delegate?.sliderValueChanged(value)
        
        // make sure the indicator is showing correctly
        indicator?.frame = currentIndicatorRect
        indicatorLabel?.text = "\(value)"
        print("frame = \(indicator?.frame)")
        
        updateThumb()
    }
    
    
    func showValueIndicator() {
        // draw an upside-down teardrop shape for the path
        let path = UIBezierPath()
        let halfSize = indicatorSize/2
        let quarterSize = halfSize/2
        
        
        path.moveToPoint(CGPoint(x:halfSize, y:indicatorSize))
        path.addCurveToPoint(CGPoint(x:halfSize, y:0), controlPoint1: CGPoint(x:0, y:quarterSize), controlPoint2: CGPoint(x:quarterSize, y:0))
        path.addCurveToPoint(CGPoint(x:halfSize, y:indicatorSize), controlPoint1: CGPoint(x:3*quarterSize, y:0), controlPoint2: CGPoint(x: indicatorSize, y: quarterSize))
        path.closePath()
        
        // fill using the matching thumb color and use the path for a new layer
        let layer = CAShapeLayer()
        layer.path = path.CGPath
        layer.fillColor = thumbColor.CGColor
        
        // create an indicator view at the appropriate position (based on current thumb's rect)
        indicator = UIView(frame: currentIndicatorRect)
        
        if let indicator = indicator {
            // add the shape drawn to the indicator view with a transparent background
            indicator.layer.addSublayer(layer)
            indicator.backgroundColor = UIColor.clearColor()
            
            // create the label for the value and add it to the indicator view
            indicatorLabel = createThumbLabel()
            if let indicatorLabel = indicatorLabel {
                indicator.addSubview(indicatorLabel)
                indicatorLabel.center = CGPoint(x:halfSize, y:halfSize/2)
            }
            
            // insert the indicator behind the slider
            self.insertSubview(indicator, atIndex: 0)
            
            // set starting scale small so it can grow with animation
            let scale = CGAffineTransformMakeScale(0.2, 0.2)
            indicator.transform = CGAffineTransformConcat(scale, CGAffineTransformMakeTranslation(0, halfSize))
        }
        
        
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: .CurveLinear, animations: {
            // shrink and hide the thumb label
            self.thumbLabel?.transform = CGAffineTransformMakeScale(0.1, 0.1)
            self.thumbLabel?.alpha = 0.0
            
            // grow and show the indicator, fading in the value label
            self.indicatorLabel?.alpha = 1.0
            self.indicator?.transform = CGAffineTransformIdentity
            
            }, completion:nil )
        
        
    }
    
    func hideValueIndicator() {
        // show the thumb at full size without animation
        self.thumbLabel?.transform = CGAffineTransformIdentity
        self.thumbLabel?.alpha = 1.0
        
        // make sure the value and position are correct
        self.updateThumb()
        
        // hide the indicator
        self.indicator?.removeFromSuperview()
    }
    
    func hideValueIndicatorAnimated() {
        // fade out the indicator while shrinking and translating down
        UIView.animateWithDuration(0.2, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.8, options: .CurveLinear, animations: {
            // fade out the label and transform the view to shrink downward
            self.indicatorLabel?.alpha = 0.0
            self.indicator?.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(0.01, 0.01), CGAffineTransformMakeTranslation(0, self.indicatorSize/2))
            
            // fade in the thumb and grow it to its original size
            self.thumbLabel?.transform = CGAffineTransformIdentity
            self.thumbLabel?.alpha = 1.0
            
            }, completion: { finished in
                
                // clean up indicator view and make sure thumb is correct still
                self.updateThumb()
                self.indicator?.alpha = 0.0
                self.indicator?.removeFromSuperview()
        })
        
    }
    
    
    
    var currentIndicatorRect:CGRect {
        let rect = currentThumbRect
        print("rect = \(rect)")
        return CGRectMake(rect.midX-thumbSize, rect.midY-thumbSize/2-10, indicatorSize, indicatorSize)
    }
    
    
    
    
}
