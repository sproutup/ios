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
    var mainImage : UIImage!
    var description : String
    var images : [UIImage!]
    var moreInfo : String
    var videoName : String
    var videoType : String
    //var canBuy : Bool
    //var canTry : Bool
    
    
    //init(name: String, images: [UIImage!], description: String, video: MPMoviePlayerController!, moreInfo: String, canBuy: Bool, canTry: Bool)
    init(name: String, images: [UIImage!], description: String, moreInfo: String, videoName: String, videoType: String) {
        self.name = name
        self.images = images
        self.mainImage = self.images[0]
        self.description = description
        self.moreInfo = moreInfo
        self.videoName = videoName
        self.videoType = videoType
        //self.canBuy = canBuy
        //self.canTry = canTry
    }
}
