//
//  ProductView.swift
//
//
//  Created by Apurv Sethi on 6/4/15.
//
//

import UIKit

class ProductView : UIView {
    let imageMarginSpace : CGFloat = 5.0
    var productField : UIImageView!
    var animator : UIDynamicAnimator!
    var originalCenter : CGPoint!
    var product : Product!
    
    init(frame: CGRect, product : Product, center : CGPoint) {
        super.init(frame: frame)
        self.center = center
        self.originalCenter = center
        self.product = product
        animator = UIDynamicAnimator(referenceView: self)
        productField = UIImageView()
        productField.image = product.image
        productField.frame = CGRectIntegral(CGRectMake(
            self.imageMarginSpace, self.imageMarginSpace,
            self.frame.width - (self.imageMarginSpace * 2),
            self.frame.height - (self.imageMarginSpace * 2)))
        self.addSubview(productField)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func swipe(decision : Bool) {
        animator.removeAllBehaviors()
        
        let gravityX = decision ? 0.5 : -0.5
        let magnitude = decision ? 20 : -20
        let gravityBehavior : UIGravityBehavior = UIGravityBehavior(items: [self])
        gravityBehavior.gravityDirection = CGVectorMake(CGFloat(gravityX), 0)
        animator.addBehavior(gravityBehavior)
        
        let pushBehavior : UIPushBehavior = UIPushBehavior(items: [self], mode: UIPushBehaviorMode.Instantaneous)
        pushBehavior.magnitude = CGFloat(magnitude)
        animator.addBehavior(pushBehavior)
    }
    
    func returnToCenter() {
        UIView.animateWithDuration(0.8, delay: 0.1, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: .AllowUserInteraction, animations: {self.center = self.originalCenter}, completion: {finished in println("Finished animation")})
    }
}
