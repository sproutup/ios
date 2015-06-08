//
//  SwipeToChooseDelegate.swift
//  SproutUp
//
//  Created by Apurv Sethi on 6/5/15.
//  Copyright (c) 2015 SproutUp Co. All rights reserved.
//

import UIKit

protocol SwipeToChooseDelegate {
    func viewDidCancelSwipe(view: UIView)
    func shouldBeChosenWithDirection (view: UIView, shouldBeChosenWithDirection: SwipeDirection) -> Bool
    func wasChosenWithDirection (view: UIView, wasChosenWithDirection: SwipeDirection)
    func didTapImage()
}