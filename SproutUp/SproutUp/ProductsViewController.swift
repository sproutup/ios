//
//  ProductsViewController.swift
//  SproutUp
//
//  Created by Apurv Sethi on 6/4/15.
//  Copyright (c) 2015 SproutUp Co. All rights reserved.
//

import UIKit

class ProductsViewController: UIViewController, SwipeToChooseDelegate {
    
    var products : [Product] = []
    let ChoosePersonButtonHorizontalPadding : CGFloat = 80.0
    let ChoosePersonButtonVerticalPadding : CGFloat = 20.0
    var currentPerson : Product!
    var frontCardView : ChooseProductView!
    var backCardView : ChooseProductView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.products = defaultProducts()
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.products = defaultProducts()
        // Here you can init your properties
    }
    func suportedInterfaceOrientations() -> UIInterfaceOrientationMask{
        return UIInterfaceOrientationMask.Portrait
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.setFrontView(self.popPersonViewWithFrame(frontCardViewFrame())!)
        self.view.addSubview(self.frontCardView)
        self.backCardView = self.popPersonViewWithFrame(backCardViewFrame())!
        self.view.insertSubview(self.backCardView, belowSubview: self.frontCardView)
        constructNopeButton()
        constructLikedButton()
    }
    
    func setFrontView(frontCardView : ChooseProductView) {
        self.frontCardView = frontCardView
        self.currentPerson = frontCardView.product
    }
    
    func defaultProducts() -> [Product] {
        return [Product(name: "One", image: UIImage(named: "3"), info: "Product number one"), Product(name: "Two", image: UIImage(named: "5"), info: "Product number two"), Product(name: "Three", image: UIImage(named: "8"), info: "Product number three")]
    }
    
    func viewDidCancelSwipe(view: UIView) {
        println("Couldn't decide, huh?")
    }
    func shouldBeChosenWithDirection(view: UIView, shouldBeChosenWithDirection: SwipeDirection) -> Bool {
        if shouldBeChosenWithDirection != SwipeDirection.None {
            return true
        }
        else {
            // Snap the view back and cancel the choice.
            UIView.animateWithDuration(0.16, animations: {
                view.transform = CGAffineTransformIdentity
                view.center = view.superview!.center
            })
            return false
        }
    }
    func wasChosenWithDirection(view: UIView, wasChosenWithDirection: SwipeDirection) {
        if (wasChosenWithDirection == SwipeDirection.Left) {
            println("Photo deleted!");
        }
        else {
            println("Photo saved!");
        }
        if(self.backCardView != nil){
            self.setFrontView(self.backCardView)
        }
        
        self.backCardView = self.popPersonViewWithFrame(self.backCardViewFrame())
        //if(true){
        // Fade the back card into view.
        if(self.backCardView != nil){
            self.backCardView.alpha = 0.0
            self.view.insertSubview(self.backCardView, belowSubview: self.frontCardView)
            UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseInOut, animations: {
                self.backCardView.alpha = 1.0
                },completion:nil)
        }
    }
    func didTapImage() {
        self.performSegueWithIdentifier("infoSegue", sender: nil)
    }
    
    func popPersonViewWithFrame(frame : CGRect) -> ChooseProductView? {
        if(self.products.count == 0){
            return nil;
        }
        
        var options : SwipeToChooseViewOptions = SwipeToChooseViewOptions()
        options.delegate = self
        options.threshold = 100.0
        options.onPan = { state -> Void in
            if(self.backCardView != nil){
                var frame:CGRect = self.frontCardViewFrame()
                self.backCardView.frame = CGRectMake(frame.origin.x, frame.origin.y-(state.thresholdRatio * 10.0), CGRectGetWidth(frame), CGRectGetHeight(frame))
            }
        }
        
        var productView : ChooseProductView = ChooseProductView(frame: frame, product : self.products[0], options: options)
        productView.delegate = self
        self.products.removeAtIndex(0)
        return productView
        
    }
    
    func frontCardViewFrame() -> CGRect{
        var horizontalPadding:CGFloat = 20.0
        var topPadding:CGFloat = 60.0
        var bottomPadding:CGFloat = 200.0
        return CGRectMake(horizontalPadding,topPadding,self.view.frame.width - (horizontalPadding * 2), self.view.frame.height - bottomPadding)
    }
    
    func backCardViewFrame() -> CGRect{
        var frontFrame:CGRect = frontCardViewFrame()
        return CGRectMake(frontFrame.origin.x, frontFrame.origin.y + 10.0, frontFrame.width, frontFrame.height)
    }
    
    func constructNopeButton() -> Void{
        let button : UIButton =  UIButton.buttonWithType(UIButtonType.System) as! UIButton
        let image : UIImage = UIImage(named:"nope")!
        button.frame = CGRectMake(ChoosePersonButtonHorizontalPadding, self.backCardView.frame.maxY + ChoosePersonButtonVerticalPadding, image.size.width, image.size.height)
        button.setImage(image, forState: UIControlState.Normal)
        button.tintColor = UIColor(red: 247.0/255.0, green: 91.0/255.0, blue: 37.0/255.0, alpha: 1.0)
        button.addTarget(self, action: "nopeFrontCardView", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(button)
    }
    
    func constructLikedButton() -> Void{
        let button : UIButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        let image : UIImage = UIImage(named:"liked")!
        button.frame = CGRectMake(self.view.frame.maxX - image.size.width - ChoosePersonButtonHorizontalPadding, self.backCardView.frame.maxY + ChoosePersonButtonVerticalPadding, image.size.width, image.size.height)
        button.setImage(image, forState:UIControlState.Normal)
        button.tintColor = UIColor(red: 29.0/255.0, green: 245.0/255.0, blue: 106.0/255.0, alpha: 1.0)
        button.addTarget(self, action: "likeFrontCardView", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(button)
        
    }
    
    func nopeFrontCardView() -> Void{
        self.frontCardView.pvc_swipe(SwipeDirection.Left)
    }
    
    func likeFrontCardView() -> Void{
        self.frontCardView.pvc_swipe(SwipeDirection.Right)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "infoSegue" {
            var destViewController : ProductInformationViewController = segue.destinationViewController as! ProductInformationViewController
            destViewController.product = frontCardView.product
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
