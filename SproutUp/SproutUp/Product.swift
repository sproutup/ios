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
    var image : UIImage!
    var info : String
    
    init(name: String, image: UIImage?, info : String) {
        self.name = name
        self.image = image
        self.info = info
    }
}
