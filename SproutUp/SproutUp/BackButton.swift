//
//  BackButton.swift
//  SproutUp
//
//  Created by Apurv Sethi on 6/8/15.
//  Copyright (c) 2015 SproutUp Co. All rights reserved.
//

import UIKit

class BackButton : UIButton {
    var delegate : ProductInformationDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupTapGestureRecognizer()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupTapGestureRecognizer() {
        let tapGestureRecognizer : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("onTapGesture:"))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func onTapGesture(tapGestureRecognizer: UITapGestureRecognizer) {
        self.delegate!.didTapBack()
    }
}
