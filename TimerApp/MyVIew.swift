//
//  MyVIew.swift
//  TimerApp
//
//  Created by Admin on 03/02/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
@IBDesignable
class MyVIew: UIView {

    @IBInspectable  var FirstColor :UIColor = UIColor.clear {
        didSet{
        UpdateView()
        }
        
    }
    @IBInspectable var SecondColor:UIColor = UIColor.clear {
        didSet{
         UpdateView()
        }
    }
    // i don`t understand this line of code 
    override class var layerClass:AnyClass {
        get{
            return CAGradientLayer.self
        }
    }
    
    func UpdateView(){
        let Layer = self.layer as! CAGradientLayer
     Layer.colors = [FirstColor.cgColor,SecondColor.cgColor]
    }
}
