//
//  ViewState.swift
//  SproutUp
//
//  Created by Apurv Sethi on 6/5/15.
//  Copyright (c) 2015 SproutUp Co. All rights reserved.
//

import UIKit

enum RotationDirection {
    case RotationAwayFromCenter
    case RotationTowardsCenter
}

class ViewState : NSObject {
    var originalCenter : CGPoint = CGPointMake(0.0, 0.0)
    var originalTransform : CATransform3D = CATransform3D()
    var rotationDirection : RotationDirection = RotationDirection.RotationTowardsCenter
}