//
//  SwipeToChooseView.swift
//  SproutUp
//
//  Created by Apurv Sethi on 6/5/15.
//  Copyright (c) 2015 SproutUp Co. All rights reserved.
//

import UIKit

class SwipeToChooseView : UIView {
    let SwipeToChooseViewHorizontalPadding : CGFloat = 10.0
    let SwipeToChooseViewTopPadding : CGFloat = 20.0
    let SwipeToChooseViewImageTopPadding : CGFloat = 100.0
    let SwipeToChooseViewLabelWidth : CGFloat = 65.0
    
    var options : SwipeToChooseViewOptions!
    
    var imageView : UIImageView!
    var likedView : UIView!
    var nopeView : UIView!
    
    init(frame : CGRect, options : SwipeToChooseViewOptions) {
        super.init(frame : frame)
        self.options = options
        setupView()
        constructImageView()
        constructLikedView()
        constructNopeView()
        setupSwipeToChoose()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.backgroundColor = UIColor.clearColor()
        self.layer.cornerRadius = 5.0
        self.layer.masksToBounds = true
        self.layer.borderWidth = 2.0
        self.layer.borderColor = UIColor(red: 220.0/255.0, green: 220.0/255.0, blue:220.0/255.0, alpha:1.0).CGColor
    }
    
    func constructImageView() {
        imageView = UIImageView(frame: self.bounds)
        imageView.clipsToBounds = true
        self.addSubview(imageView)
    }
    
    func constructLikedView() {
        var yOrigin : CGFloat = SwipeToChooseViewTopPadding
        if self.options.likedImage != nil {
            yOrigin = SwipeToChooseViewImageTopPadding
        }
        let frame : CGRect = CGRectMake(SwipeToChooseViewHorizontalPadding, yOrigin, self.imageView.bounds.midX, SwipeToChooseViewLabelWidth)
        if (self.options.likedImage != nil) {
            self.likedView = UIView(frame: frame)
            self.likedView.constructBorderedLabelWithText(self.options.likedText, color: self.options.likedColor, angle: self.options.likedRotationAngle);
        }
        else {
            self.likedView = UIImageView(image: self.options.likedImage)
            self.likedView.frame = frame
            self.likedView.contentMode = UIViewContentMode.ScaleAspectFit
        }
        self.likedView.alpha = 0.0
        self.imageView.addSubview(self.likedView)
    }
    
    func constructNopeView() {
        let width : CGFloat = self.imageView.bounds.midX
        let xOrigin : CGFloat = self.imageView.bounds.maxX - width - SwipeToChooseViewHorizontalPadding
        var yOrigin : CGFloat = SwipeToChooseViewTopPadding
        if self.options.likedImage != nil {
            yOrigin = SwipeToChooseViewImageTopPadding
        }
        let frame : CGRect = CGRectMake(xOrigin, yOrigin, width, SwipeToChooseViewLabelWidth)
        if (self.options.nopeImage != nil) {
            self.nopeView = UIView(frame: frame)
            self.nopeView.constructBorderedLabelWithText(self.options.nopeText, color:self.options.nopeColor, angle:self.options.nopeRotationAngle)
        }
        else {
            self.nopeView = UIImageView(image: self.options.nopeImage)
            self.nopeView.frame = frame
            self.nopeView.contentMode = UIViewContentMode.ScaleAspectFit
        }
        self.nopeView.alpha = 0.0;
        self.imageView.addSubview(self.nopeView)
    }
    
    func setupSwipeToChoose() {
        let options : SwipeOptions = SwipeOptions()
        options.delegate = self.options.delegate
        options.threshold = self.options.threshold
        
        var likedImageView : UIView = self.likedView
        var nopeImageView : UIView = self.nopeView
        weak var weakself : SwipeToChooseView? = self
        options.onPan = { (state : PanState) -> () in
            if state.direction == SwipeDirection.None {
                likedImageView.alpha = 0.0
                nopeImageView.alpha = 0.0
            }
            else if state.direction == SwipeDirection.Left {
                likedImageView.alpha = 0.0
                nopeImageView.alpha = state.thresholdRatio
            }
            else if state.direction == SwipeDirection.Right {
                likedImageView.alpha = state.thresholdRatio
                nopeImageView.alpha = 0.0
            }
            if weakself!.options.onPan != nil {
                weakself!.options.onPan!(state)
            }
        }
        self.pvc_swipeToChooseSetup(options)
    }
}