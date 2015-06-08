//
//  SwipeOptions.swift
//  SproutUp
//
//  Created by Apurv Sethi on 6/5/15.
//  Copyright (c) 2015 SproutUp Co. All rights reserved.
//

import UIKit

class SwipeOptions : NSObject {
    var delegate : SwipeToChooseDelegate?
    
    var swipeCancelledAnimationDuration : NSTimeInterval = 0.2
    var swipeCancelledAnimationOptions : UIViewAnimationOptions = UIViewAnimationOptions.CurveEaseOut
    var swipeAnimationDuration : NSTimeInterval = 0.1
    var swipeAnimationOption : UIViewAnimationOptions = UIViewAnimationOptions.CurveEaseIn
    var threshold : CGFloat = 100.0
    var rotationFactor : CGFloat = 10.0
    var onPan : (PanState -> ())? = nil
    var onChosen : (SwipeResult -> ())? = { (state : SwipeResult) -> () in
        let duration = 0.1
        let options = UIViewAnimationOptions.CurveLinear
        let destination = state.view!.frame.extendedOutOfBounds(state.view!.superview!.bounds,translation: state.translation)
        UIView.animateWithDuration(duration, delay: 0.0, options: options,
            animations: {state.view!.center = CGPointMake(destination.midX, destination.midY);},
            completion: {(finished: Bool) -> () in
                if (finished) {
                    state.view!.removeFromSuperview()
                    state.onCompletion()
                }
        })
    }
    var onCancel : (UIView -> ())? = nil
}