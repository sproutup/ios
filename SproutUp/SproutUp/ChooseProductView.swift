//
//  ChooseProductView.swift
//  SproutUp
//
//  Created by Apurv Sethi on 6/8/15.
//  Copyright (c) 2015 SproutUp Co. All rights reserved.
//

import UIKit

class ChooseProductView : SwipeToChooseView {
    
    var delegate : SwipeToChooseDelegate?
    var product: Product!
    var basicInfoView: UIView!
    var nameLabel: UILabel!
    
    init(frame: CGRect, product: Product, options: SwipeToChooseViewOptions) {
        
        super.init(frame: frame, options: options)
        self.product = product
        
        if let image = self.product.image {
            self.imageView.image = image
        }
        
        self.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth
        UIViewAutoresizing.FlexibleBottomMargin
        
        self.imageView.autoresizingMask = self.autoresizingMask
        constructInformationView()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func constructInformationView() -> Void{
        var bottomHeight:CGFloat = 60.0
        var bottomFrame:CGRect = CGRectMake(0, CGRectGetHeight(self.bounds) - bottomHeight, CGRectGetWidth(self.bounds), bottomHeight);
        self.basicInfoView = UIView(frame:bottomFrame)
        self.basicInfoView.backgroundColor = UIColor.whiteColor()
        self.basicInfoView.clipsToBounds = true
        self.basicInfoView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleTopMargin
        self.addSubview(self.basicInfoView)
        constructNameLabel()
    }
    
    func constructNameLabel() -> Void{
        var leftPadding:CGFloat = 12.0
        var topPadding:CGFloat = 17.0
        var frame:CGRect = CGRectMake(leftPadding, topPadding, floor(CGRectGetWidth(self.basicInfoView.frame)/2), CGRectGetHeight(self.basicInfoView.frame) - topPadding)
        self.nameLabel = UILabel(frame:frame)
        self.nameLabel.text = "\(product.name)"
        self.basicInfoView .addSubview(self.nameLabel)
    }
}
