//
//  Extensions.swift
//  SproutUp
//
//  Created by Apurv Sethi on 6/5/15.
//  Copyright (c) 2015 SproutUp Co. All rights reserved.
//

import UIKit
import Darwin
import ObjectiveC

private var pvc_optionsAssociationKey : UInt8 = 0
private var pvc_viewStateAssociationKey : UInt8 = 1
private var pvc_setupAssociationKey : UInt8 = 2

extension CGPoint {
    func add(b : CGPoint) -> CGPoint {
        return CGPointMake(self.x + b.x, self.y + b.y)
    }
    
    func sub(b : CGPoint) -> CGPoint {
        return CGPointMake(self.x - b.x, self.y - b.y)
    }
}

extension CGFloat {
    var radians : CGFloat { return self * (CGFloat)(M_PI/180.0) }
}

extension CGRect {
    func extendedOutOfBounds(bounds : CGRect, translation : CGPoint) -> CGRect {
        var destination : CGRect = self
        while !CGRectIsNull(CGRectIntersection(bounds, destination)) {
            destination = CGRectOffset(destination, translation.x, translation.y)
        }
        return destination
    }
}

extension UIView {
    func constructBorderedLabelWithText(text : String, color : UIColor, angle : CGFloat) {
        self.layer.borderColor = color.CGColor
        self.layer.borderWidth = 5.0
        self.layer.cornerRadius = 10.0
        
        let label : UILabel = UILabel(frame: self.bounds)
        label.text = text
        label.textAlignment = NSTextAlignment.Center
        label.font = UIFont(name: "HelveticaNeue-CondensedBlack", size: 48.0)
        label.textColor = color
        self.addSubview(label)
        
        self.transform = CGAffineTransformRotate(CGAffineTransformIdentity, angle.radians)
    }
    
    var pvc_options : SwipeOptions! {
        get {
            return objc_getAssociatedObject(self, &pvc_optionsAssociationKey) as? SwipeOptions
        }
        set(newValue) {
            objc_setAssociatedObject(self, &pvc_optionsAssociationKey, newValue, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN))
        }
    }
    var pvc_viewState : ViewState! {
        get {
            return objc_getAssociatedObject(self, &pvc_viewStateAssociationKey) as? ViewState
        }
        set(newValue) {
            objc_setAssociatedObject(self, &pvc_viewStateAssociationKey, newValue, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN))
        }
    }
    
    func pvc_swipeToChooseSetup(options : SwipeOptions?) {
        self.pvc_options = SwipeOptions()
        if options != nil {
            self.pvc_options = options!
        }
        self.pvc_viewState = ViewState()
        self.pvc_viewState.originalCenter = self.center
        self.pvc_viewState.originalTransform = self.layer.transform
        self.pvc_setupPanGestureRecognizer()
        self.pvc_setupTapGestureRecognizer()
    }
    
    func pvc_swipe(direction : SwipeDirection) {
        if direction == SwipeDirection.None {
            self.pvc_finalizePosition()
        }
        
        var animations = {() -> () in
            let translation : CGPoint = self.pvc_translationExceedingThreshold (self.pvc_options.threshold,
                direction:direction)
            self.center = self.center.add(translation)
            self.pvc_rotateForTranslation(translation)
            self.pvc_executeOnPanBlockForTranslation(translation)
        }
        
        var completion = {(finished : Bool) -> () in
            if finished {
                self.pvc_finalizePosition()
            }
        }
        
        UIView.animateWithDuration(self.pvc_options.swipeAnimationDuration, delay: 0.0, options: self.pvc_options.swipeAnimationOption, animations: animations, completion: completion)
    }
    
    func pvc_setupPanGestureRecognizer() {
        let panGestureRecognizer : UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: Selector("pvc_onSwipeToChoosePanGestureRecognizer:"))
        self.addGestureRecognizer(panGestureRecognizer)
    }
    
    func pvc_setupTapGestureRecognizer() {
        let tapGestureRecognizer : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("pvc_onTapGesture:"))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func pvc_finalizePosition() {
        let direction : SwipeDirection = self.pvc_directionOfExceededThreshold()
        switch (direction) {
        case SwipeDirection.Right, SwipeDirection.Left:
            let translation : CGPoint = self.center.sub(self.pvc_viewState.originalCenter)
            self.pvc_exitSuperviewFromTranslation(translation)
        case SwipeDirection.None:
            self.pvc_returnToOriginalCenter()
            self.pvc_executeOnPanBlockForTranslation(CGPointZero)
        }
    }
    
    func pvc_returnToOriginalCenter() {
        UIView.animateWithDuration(self.pvc_options.swipeCancelledAnimationDuration, delay: 0.0, options: self.pvc_options.swipeCancelledAnimationOptions,
            animations: {
                self.layer.transform = self.pvc_viewState.originalTransform
                self.center = self.pvc_viewState.originalCenter
            },
            completion: {(finished : Bool) -> () in
                let delegate : SwipeToChooseDelegate = self.pvc_options.delegate!
                delegate.viewDidCancelSwipe(self)
        })
    }
    
    func pvc_exitSuperviewFromTranslation(translation : CGPoint) {
        let direction : SwipeDirection = self.pvc_directionOfExceededThreshold()
        
        let delegate : SwipeToChooseDelegate = self.pvc_options.delegate!
        if !(delegate.shouldBeChosenWithDirection(self, shouldBeChosenWithDirection: direction)) {
            self.pvc_returnToOriginalCenter()
            if self.pvc_options.onCancel != nil {
                self.pvc_options.onCancel!(self)
            }
        }
        
        var state : SwipeResult = SwipeResult()
        state.view = self
        state.translation = translation
        state.direction = direction
        state.onCompletion = {
            delegate.wasChosenWithDirection(self, wasChosenWithDirection: direction)
        }
        self.pvc_options.onChosen?(state)
    }
    
    func pvc_executeOnPanBlockForTranslation(translation : CGPoint) {
        if (self.pvc_options.onPan != nil) {
            let thresholdRatio : CGFloat = min(1.0, fabs(translation.x)/self.pvc_options.threshold)
            
            var direction : SwipeDirection = SwipeDirection.None;
            if (translation.x > 0.0) {
                direction = SwipeDirection.Right
            }
            else if (translation.x < 0.0) {
                direction = SwipeDirection.Left
            }
            
            var state : PanState = PanState(view: self, direction: direction, thresholdRatio: thresholdRatio)
            self.pvc_options.onPan?(state)
        }
    }
    
    func pvc_rotateForTranslation(translation : CGPoint) {
        let rotation : CGFloat = (translation.x/100.0 * self.pvc_options.rotationFactor).radians
        self.layer.transform = CATransform3DMakeRotation(rotation, 0.0, 0.0, 1.0)
    }
    
    func pvc_translationExceedingThreshold(threshold : CGFloat, direction : SwipeDirection) -> CGPoint {
        assert(direction != SwipeDirection.None);
        
        let offset : CGFloat = threshold + 1.0
        switch (direction) {
        case SwipeDirection.Left:
            return CGPointMake(-offset, 0)
        case SwipeDirection.Right:
            return CGPointMake(offset, 0)
        default:
            NSException(name: NSInternalInconsistencyException, reason: "Invalid direction argument", userInfo: nil).raise()
            return CGPointZero;
        }
    }
    
    func pvc_directionOfExceededThreshold() -> SwipeDirection {
        if (self.center.x > self.pvc_viewState.originalCenter.x + self.pvc_options.threshold) {
            return SwipeDirection.Right
        }
        else if (self.center.x < self.pvc_viewState.originalCenter.x - self.pvc_options.threshold) {
            return SwipeDirection.Left
        }
        else {
            return SwipeDirection.None
        }
    }
    
    func pvc_onSwipeToChoosePanGestureRecognizer(panGestureRecognizer : UIPanGestureRecognizer) {
        let view : UIView = panGestureRecognizer.view!
        
        if panGestureRecognizer.state == UIGestureRecognizerState.Began {
            self.pvc_viewState.originalCenter = view.center
            self.pvc_viewState.originalTransform = view.layer.transform
        }
        else if panGestureRecognizer.state == UIGestureRecognizerState.Ended {
            self.pvc_finalizePosition()
        }
        else {
            let translation : CGPoint = panGestureRecognizer.translationInView(view)
            view.center = self.pvc_viewState.originalCenter.add(translation)
            self.pvc_rotateForTranslation(translation)
            self.pvc_executeOnPanBlockForTranslation(translation)
        }
    }
    
    func pvc_onTapGesture(tapGestureRecognizer: UITapGestureRecognizer) {
        let delegate : SwipeToChooseDelegate = self.pvc_options.delegate!
        delegate.didTapImage()
    }
}
