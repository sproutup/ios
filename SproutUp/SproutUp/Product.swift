//
//  Product.swift
//  SproutUp
//
//  Created by Apurv Sethi on 6/4/15.
//  Copyright (c) 2015 SproutUp Co. All rights reserved.
//

import UIKit

class Product {
    var name : String
    var pic : UIImage?
    
    init(name: String, pic: UIImage?) {
        self.name = name
        self.pic = pic
    }
}
