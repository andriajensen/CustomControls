//
//  ViewController.swift
//  CustomControls
//
//  Created by Jensen Andria on 8/19/16.
//  Copyright © 2016 HCA, Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

 
    @IBOutlet weak var roundedCornerButton: RoundedCornerButton!
    @IBOutlet weak var roundedCornerView: RoundedCornerView!
    @IBOutlet weak var borderedTextView: BorderedTextView!
    @IBOutlet weak var selectableButton: SelectableButton!
    @IBOutlet weak var stackedButton: StackedButton!
    @IBOutlet weak var roundImageView: RoundImageView!

    
    @IBAction func toggleTextViewBorderColor(_ sender: AnyObject) {
        
        if borderedTextView.borderColor == UIColor.red {
            borderedTextView.borderColor = UIColor.blue
        }
        else {
            borderedTextView.borderColor = UIColor.red
        }
    }
    
}

