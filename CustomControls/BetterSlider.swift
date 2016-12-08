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
    
    func sliderValueChanged(_ newValue:Int)
}

@available(iOS 9.0, *)
@IBDesignable open class BetterSlider: UIView {
    
    fileprivate var thumbSize:CGFloat = 40
    fileprivate var indicatorSize:CGFloat = 80
    
    fileprivate var slider:UISlider?
    fileprivate var indicatorLabel:UILabel?
    fileprivate var indicator:UIView?
    fileprivate var thumbLabel:UILabel?
    fileprivate var emptyThumbImage:UIImage?
    fileprivate var thumbImage:UIImage?
    
    open var delegate:BetterSliderDelegate?
    
    @IBInspectable open var minimumValue:Int = 1 {
        didSet {
            if minimumValue >= maximumValue {
                minimumValue = maximumValue-1
            }
            slider?.minimumValue = Float(minimumValue)
        }
    }
    
    @IBInspectable open var maximumValue:Int = 10 {
        didSet {
            if maximumValue <= minimumValue {
                maximumValue = minimumValue+1
            }
            slider?.maximumValue = Float(maximumValue)
        }
    }
    
    @IBInspectable open var trackColor:UIColor = UIColor.lightGray {
        didSet {
            slider?.tintColor = trackColor
            slider?.minimumTrackTintColor = trackColor
            slider?.maximumTrackTintColor = trackColor
        }
    }
    
    @IBInspectable open var value:Int {
        set {
            slider?.value = Float(newValue)
            updateThumb()
        }
        get {
            return Int(slider?.value ?? 0)
        }
    }
    
    @IBInspectable open var thumbColor:UIColor = UIColor.blue {
        didSet {
            thumbLabel?.backgroundColor = thumbColor
        }
    }
    
    @IBInspectable open var valueColor:UIColor = UIColor.darkGray {
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
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let slider = slider {
            // anchor the slider to the bottom, center it and have it fill the available horizontal space
            slider.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                slider.centerXAnchor.constraint(equalTo: centerXAnchor),
                slider.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
                slider.leadingAnchor.constraint(equalTo: leadingAnchor),
                slider.trailingAnchor.constraint(equalTo: trailingAnchor),
                slider.heightAnchor.constraint(equalToConstant: 50)
                ])
        }
    }
    
    override open func draw(_ rect: CGRect) {
        updateThumb()
    }
    
    override open var intrinsicContentSize : CGSize {
        return CGSize(width: 300, height: 100)
    }
    
    open class override var requiresConstraintBasedLayout : Bool {
        return true
    }
    
    open override func prepareForInterfaceBuilder() {
        self.clipsToBounds = false
    }
    
    func setupViews() {
        
        slider = UISlider()
        
        if let slider = slider {
            slider.addTarget(self, action: #selector(updateValueIndicator), for: .touchDragInside)
            slider.addTarget(self, action: #selector(showValueIndicator), for: .touchDown)
            slider.addTarget(self, action: #selector(hideValueIndicatorAnimated), for: [.touchUpInside])
            slider.addTarget(self, action: #selector(hideValueIndicator), for: [.touchUpOutside, .touchDragExit, .touchCancel, .touchDragOutside])
            slider.addTarget(self, action: #selector(updateThumb), for: [.touchDragOutside, .touchDragInside])
            slider.addTarget(self, action: #selector(updateValueIndicator), for: [.valueChanged])
            
            addSubview(slider)
            
            // create a transparent view to use as a placeholder for the thumb
            // this helps make a smooth animation instead of a thumb image always showing
            let emptyThumbView = UIView(frame:CGRect(x: 0,y: 0,width: thumbSize, height: thumbSize))
            emptyThumbView.backgroundColor = UIColor.clear
            emptyThumbImage = emptyThumbView.toImage()
            slider.setThumbImage(emptyThumbImage, for: UIControlState())
            slider.setThumbImage(emptyThumbImage, for: .highlighted)
            
            
            thumbLabel = createThumbLabel()
            if let thumbLabel = thumbLabel {
                addSubview(thumbLabel)
            }
            
            self.isUserInteractionEnabled = true
            
        }
        
        minimumValue = 1
        maximumValue = 10
        trackColor = UIColor.lightGray
        thumbColor = UIColor.blue
        valueColor = UIColor.white
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
        label.font = UIFont.systemFont(ofSize: 20)
        label.backgroundColor = thumbColor
        label.textColor = valueColor
        label.textAlignment = .center
        label.layer.cornerRadius = thumbSize/2
        label.layer.masksToBounds = true
        label.center = currentThumbCenter
        
        return label
    }
    
    fileprivate var currentThumbRect:CGRect {
        guard let slider = slider else {
            return CGRect.zero
        }
        
        print("slider.value = \(slider.value)")
        return slider.thumbRect(forBounds: slider.bounds, trackRect: slider.trackRect(forBounds: slider.bounds), value: slider.value)
    }
    
    fileprivate var currentThumbCenter:CGPoint {
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
        
        
        path.move(to: CGPoint(x:halfSize, y:indicatorSize))
        path.addCurve(to: CGPoint(x:halfSize, y:0), controlPoint1: CGPoint(x:0, y:quarterSize), controlPoint2: CGPoint(x:quarterSize, y:0))
        path.addCurve(to: CGPoint(x:halfSize, y:indicatorSize), controlPoint1: CGPoint(x:3*quarterSize, y:0), controlPoint2: CGPoint(x: indicatorSize, y: quarterSize))
        path.close()
        
        // fill using the matching thumb color and use the path for a new layer
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.fillColor = thumbColor.cgColor
        
        // create an indicator view at the appropriate position (based on current thumb's rect)
        indicator = UIView(frame: currentIndicatorRect)
        
        if let indicator = indicator {
            // add the shape drawn to the indicator view with a transparent background
            indicator.layer.addSublayer(layer)
            indicator.backgroundColor = UIColor.clear
            
            // create the label for the value and add it to the indicator view
            indicatorLabel = createThumbLabel()
            if let indicatorLabel = indicatorLabel {
                indicator.addSubview(indicatorLabel)
                indicatorLabel.center = CGPoint(x:halfSize, y:halfSize/2)
            }
            
            // insert the indicator behind the slider
            self.insertSubview(indicator, at: 0)
            
            // set starting scale small so it can grow with animation
            let scale = CGAffineTransform(scaleX: 0.2, y: 0.2)
            indicator.transform = scale.concatenating(CGAffineTransform(translationX: 0, y: halfSize))
        }
        
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: .curveLinear, animations: {
            // shrink and hide the thumb label
            self.thumbLabel?.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.thumbLabel?.alpha = 0.0
            
            // grow and show the indicator, fading in the value label
            self.indicatorLabel?.alpha = 1.0
            self.indicator?.transform = CGAffineTransform.identity
            
            }, completion:nil )
        
        
    }
    
    func hideValueIndicator() {
        // show the thumb at full size without animation
        self.thumbLabel?.transform = CGAffineTransform.identity
        self.thumbLabel?.alpha = 1.0
        
        // make sure the value and position are correct
        self.updateThumb()
        
        // hide the indicator
        self.indicator?.removeFromSuperview()
    }
    
    func hideValueIndicatorAnimated() {
        // fade out the indicator while shrinking and translating down
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.8, options: .curveLinear, animations: {
            // fade out the label and transform the view to shrink downward
            self.indicatorLabel?.alpha = 0.0
            self.indicator?.transform = CGAffineTransform(scaleX: 0.01, y: 0.01).concatenating(CGAffineTransform(translationX: 0, y: self.indicatorSize/2))
            
            // fade in the thumb and grow it to its original size
            self.thumbLabel?.transform = CGAffineTransform.identity
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
        return CGRect(x: rect.midX-thumbSize, y: rect.midY-thumbSize/2-10, width: indicatorSize, height: indicatorSize)
    }
    
    
    
    
}
