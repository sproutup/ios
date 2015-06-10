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
    var descriptionLabel : UILabel!
    
    init(frame: CGRect, product: Product, options: SwipeToChooseViewOptions) {
        
        super.init(frame: frame, options: options)
        self.product = product
        
        var bottomHeight : CGFloat = 90.0
        self.imageView.frame = CGRectMake(self.bounds.minX, self.bounds.minY, self.bounds.width, self.bounds.height - bottomHeight)
        self.imageView.image = self.product.mainImage
        
        self.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleBottomMargin
        self.layer.borderWidth = 0.0
        
        self.imageView.autoresizingMask = self.autoresizingMask
        constructInformationView(bottomHeight)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func constructInformationView(bottomHeight: CGFloat) {
        var bottomFrame : CGRect = CGRectMake(0, self.bounds.height - bottomHeight, self.bounds.width, bottomHeight);
        self.basicInfoView = UIView(frame:bottomFrame)
        self.basicInfoView.backgroundColor = UIColor.whiteColor()
        self.basicInfoView.clipsToBounds = true
        self.basicInfoView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleTopMargin
        self.addSubview(self.basicInfoView)
        constructNameLabel()
        constructDescriptionLabel()
    }
    
    func constructNameLabel() {
        var leftPadding : CGFloat = 12.0
        var topPadding : CGFloat = 7.0
        var bottomPadding : CGFloat = 50.0
        var frame : CGRect = CGRectMake(leftPadding, topPadding, floor(self.basicInfoView.frame.width/2),
            self.basicInfoView.frame.height - topPadding - bottomPadding)
        self.nameLabel = UILabel(frame:frame)
        self.nameLabel.text = "\(product.name)"
        self.basicInfoView.addSubview(self.nameLabel)
    }
    
    func constructDescriptionLabel() {
        var horizontalPadding : CGFloat = 12.0
        var topPadding : CGFloat = 30.0
        var frame : CGRect = CGRectMake(horizontalPadding, topPadding,
            self.basicInfoView.frame.width - (horizontalPadding * 2),
            self.basicInfoView.frame.height - topPadding)
        self.descriptionLabel = UILabel(frame:frame)
        self.descriptionLabel.text = "\(product.description)"
        self.basicInfoView.addSubview(self.descriptionLabel)
    }
}
