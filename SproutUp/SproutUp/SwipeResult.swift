//
//  SwipeResult.swift
//  SproutUp
//
//  Created by Apurv Sethi on 6/5/15.
//  Copyright (c) 2015 SproutUp Co. All rights reserved.
//

import UIKit

enum SwipeDirection {
    case None
    case Left
    case Right
}

class SwipeResult : NSObject {
    var view : UIView?
    var translation : CGPoint = CGPointMake(0.0, 0.0)
    var direction : SwipeDirection = SwipeDirection.None
    var onCompletion : () -> () = {}
}