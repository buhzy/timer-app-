//
//  MyButtonView.swift
//  TimerApp
//
//  Created by Admin on 03/02/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
@IBDesignable
class MyButtonView: UIButton {

    @IBInspectable var BorderWidth: CGFloat = 0 {
        didSet{
            self.layer.borderWidth = BorderWidth
        }
   }
    @IBInspectable var BorderColor : UIColor = UIColor.clear {
        didSet{
            // must put cgcolor with any items defines color
            self.layer.borderColor = BorderColor.cgColor
        }
    }
    @IBInspectable var BorderRadius : CGFloat = 0 {
        didSet{
            //border radius refer to corner radius 
            self.layer.cornerRadius = BorderRadius
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        // to clear the white spaces from both of sides
        clipsToBounds = true
    }
    
}

