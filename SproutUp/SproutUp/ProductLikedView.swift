//
//  ProductLikedView.swift
//  SproutUp
//
//  Created by Apurv Sethi on 6/8/15.
//  Copyright (c) 2015 SproutUp Co. All rights reserved.
//

import UIKit

class ProductLikedView : UIScrollView {
    
    var product : Product!
    var availability : UILabel!
    
    init(frame: CGRect, product : Product!) {
        super.init(frame: frame)
        self.product = product
        self.availability = UILabel(frame: CGRectMake(0, 0, 300, 60))
        self.availability.lineBreakMode = NSLineBreakMode.ByWordWrapping
        self.availability.numberOfLines = 0
        self.availability.text = product.availability
        self.addSubview(self.availability)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}