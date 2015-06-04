//
//  ProductsViewController.swift
//  SproutUp
//
//  Created by Apurv Sethi on 6/4/15.
//  Copyright (c) 2015 SproutUp Co. All rights reserved.
//

import UIKit

class ProductsViewController: UIViewController {
    
    @IBAction func interestedPressed(sender: AnyObject) {
        handleInterest(true)
    }
    
    @IBAction func notInterestedPressed(sender: AnyObject) {
        handleInterest(false)
    }
    
    var productViews : [ProductView] = []
    var currProductView : ProductView!
    var done : Bool = false
    
    var products : [Product] = [
        Product(name: "None", pic: UIImage(named: "3")),
        Product(name: "One", pic: UIImage(named: "5")),
        Product(name: "Two", pic: UIImage(named: "8")),
        Product(name: "Three", pic: UIImage(named: "9"))
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        for product in self.products {
            currProductView = ProductView(
                frame: CGRectMake(0, 0, self.view.frame.width - 50, self.view.frame.width - 50),
                product: product,
                center: CGPoint(x: self.view.bounds.width/2, y: self.view.bounds.height/3))
            self.productViews.append(currProductView)
        }
        
        for productView in self.productViews {
            self.view.addSubview(productView)
        }
        
        let pan = UIPanGestureRecognizer(target: self, action: Selector("handlePan:"))
        self.view.addGestureRecognizer(pan)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleInterest (interest: Bool) {
        if interest && !(self.currProductView == productViews[0]) {
            // User is interested in product
            self.currProductView.swipe(interest)
        }
        else if !interest && !(self.currProductView == productViews[0]) {
            // User is not interested in product
            self.currProductView.swipe(interest)
        }
        if !(self.currProductView == productViews[0]) {
            self.productViews.removeAtIndex(self.productViews.count - 1)
        }
        self.currProductView = self.productViews.last!
    }
    
    func handlePan(gesture : UIPanGestureRecognizer) {
        if gesture.state == UIGestureRecognizerState.Ended {
            let location = gesture.locationInView(self.view)
            if self.currProductView.center.x/self.view.bounds.maxX > 0.8 &&
                !(self.currProductView == productViews[0]) {
                self.handleInterest(true)
            }
            else if self.currProductView.center.x/self.view.bounds.maxX < 0.2 &&
                !(self.currProductView == productViews[0]){
                self.handleInterest(false)
            }
            else {
                self.currProductView.returnToCenter()
            }
        }
        let translation = gesture.translationInView(self.currProductView)
        self.currProductView.center = CGPoint(x: self.currProductView!.center.x + translation.x,
            y: self.currProductView!.center.y + translation.y)
        gesture.setTranslation(CGPointZero, inView: self.view)
    }
}
