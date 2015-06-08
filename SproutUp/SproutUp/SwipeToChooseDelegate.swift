//
//  SwipeToChooseDelegate.swift
//  SproutUp
//
//  Created by Apurv Sethi on 6/5/15.
//  Copyright (c) 2015 SproutUp Co. All rights reserved.
//

import UIKit

protocol SwipeToChooseDelegate {
    var viewDidCancelSwipe : ((UIView) -> ())? {get}
    var shouldBeChosenWithDirection : ((UIView, SwipeDirection) -> Bool)? {get}
    var wasChosenWithDirection : ((UIView, SwipeDirection) -> ())? {get}
}