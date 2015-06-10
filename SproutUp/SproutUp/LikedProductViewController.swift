//
//  LikedProductViewController.swift
//  SproutUp
//
//  Created by Apurv Sethi on 6/4/15.
//  Copyright (c) 2015 SproutUp Co. All rights reserved.
//

import UIKit

class LikedProductViewController: UIViewController {
    
    var product : Product!
    var productLikedView : UIScrollView!
    var backButton : UIButton!
    var availability : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        constructProductLikedView()
        constructBackButton()
    }
    
    func constructProductLikedView() {
        self.productLikedView = UIScrollView(frame : productViewFrame())
        self.view.addSubview(self.productLikedView)
        self.availability = UILabel(frame: CGRectMake(0, 0, 300, 60))
        self.availability.text = product.description
        self.availability.lineBreakMode = NSLineBreakMode.ByWordWrapping
        self.availability.numberOfLines = 0
        self.productLikedView.addSubview(self.availability)
    }
    
    func constructBackButton() {
        self.backButton = UIButton(frame : backButtonFrame())
        self.backButton.backgroundColor = UIColor.blackColor()
        self.backButton.setTitle("Back", forState: UIControlState.Normal)
        self.backButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.backButton.addTarget(self, action: "didTapBack", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(self.backButton)
    }
    
    func productViewFrame() -> CGRect {
        var horizontalPadding:CGFloat = 20.0
        var topPadding:CGFloat = 30.0
        var bottomPadding:CGFloat = 30.0
        return CGRectMake(horizontalPadding,topPadding,self.view.frame.width - (horizontalPadding * 2), self.view.frame.height - bottomPadding)
    }
    
    func backButtonFrame() -> CGRect {
        return CGRectMake(self.view.frame.minX,self.view.frame.maxY - 30,self.view.frame.width, 30)
    }
    
    func didTapBack() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}