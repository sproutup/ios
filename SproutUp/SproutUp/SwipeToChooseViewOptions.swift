//
//  SwipeToChooseViewOptions.swift
//  SproutUp
//
//  Created by Apurv Sethi on 6/5/15.
//  Copyright (c) 2015 SproutUp Co. All rights reserved.
//

import Foundation

class SwipeToChooseViewOptions : NSObject {
    var delegate : SwipeToChooseDelegate?
    
    var likedText : String = "liked"
    var likedColor : UIColor = UIColor(red: 29.0/255.0, green: 245.0/255.0, blue: 106.0/255.0, alpha: 1.0)
    var likedImage : UIImage?
    var likedRotationAngle : CGFloat = -15.0
    
    var nopeText : String = "nope"
    var nopeColor : UIColor = UIColor(red: 247.0/255.0, green: 91.0/255.0, blue: 37.0/255.0, alpha: 1.0)
    var nopeImage : UIImage?
    var nopeRotationAngle : CGFloat = 15.0
    
    var threshold : CGFloat = 100.0
    var onPan : (PanState -> ())? = nil
}