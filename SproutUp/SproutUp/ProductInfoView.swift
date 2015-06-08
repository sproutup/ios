//
//  ProductInfoView.swift
//  SproutUp
//
//  Created by Apurv Sethi on 6/8/15.
//  Copyright (c) 2015 SproutUp Co. All rights reserved.
//

import UIKit

class ProductInfoView : UIScrollView {
    
    var product : Product!
    var info : UILabel!
    
    init(frame: CGRect, product : Product!) {
        super.init(frame: frame)
        self.product = product
        self.info = UILabel(frame: CGRectMake(0, 0, 300, 30))
        self.info.text = product.info
        self.addSubview(info)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
