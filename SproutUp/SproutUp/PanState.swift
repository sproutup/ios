//
//  PanState.swift
//  SproutUp
//
//  Created by Apurv Sethi on 6/5/15.
//  Copyright (c) 2015 SproutUp Co. All rights reserved.
//

import UIKit

class PanState : NSObject {
    var view : UIView
    var direction : SwipeDirection
    var thresholdRatio : CGFloat
    
    init(view: UIView, direction : SwipeDirection, thresholdRatio : CGFloat) {
        self.view = view
        self.direction = direction
        self.thresholdRatio = thresholdRatio
    }
}
