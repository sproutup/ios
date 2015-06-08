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
    
    var viewDidCancelSwipe : ((UIView) -> ())? = nil
    var shouldBeChosenWithDirection : ((UIView, SwipeDirection) -> Bool)? = nil
    var wasChosenWithDirection : ((UIView, SwipeDirection) -> ())? = nil
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.products = defaultProducts()
        initializeDelegates()
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.products = defaultProducts()
        initializeDelegates()
        // Here you can init your properties
    }
    func suportedInterfaceOrientations() -> UIInterfaceOrientationMask{
        return UIInterfaceOrientationMask.Portrait
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        // Display the first ChoosePersonView in front. Users can swipe to indicate
        // whether they like or dislike the person displayed.
        self.setFrontView(self.popPersonViewWithFrame(frontCardViewFrame())!)
        self.view.addSubview(self.frontCardView)
        
        // Display the second ChoosePersonView in back. This view controller uses
        // the MDCSwipeToChooseDelegate protocol methods to update the front and
        // back views after each user swipe.
        self.backCardView = self.popPersonViewWithFrame(backCardViewFrame())!
        self.view.insertSubview(self.backCardView, belowSubview: self.frontCardView)
        
        // Add buttons to programmatically swipe the view left or right.
        // See the `nopeFrontCardView` and `likeFrontCardView` methods.
        constructNopeButton()
        constructLikedButton()
    }
    
    func setFrontView(frontCardView:ChooseProductView) {
        
        // Keep track of the person currently being chosen.
        // Quick and dirty, just for the purposes of this sample app.
        self.frontCardView = frontCardView
        self.currentPerson = frontCardView.product
    }
    
    func defaultProducts() -> [Product] {
        return [Product(name: "One", image: UIImage(named: "3")), Product(name: "Two", image: UIImage(named: "5")), Product(name: "Three", image: UIImage(named: "8"))]
    }
    
    func initializeDelegates() {
        self.viewDidCancelSwipe = {(view: UIView) -> () in
            println("Couldn't decide, huh?")
        }
        self.shouldBeChosenWithDirection = {(view: UIView, shouldBeChosenWithDirection: SwipeDirection) -> Bool in
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
        self.wasChosenWithDirection = {(view: UIView, wasChosenWithDirection: SwipeDirection) -> () in
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
    }
    
    func popPersonViewWithFrame(frame:CGRect) -> ChooseProductView?{
        if(self.products.count == 0){
            return nil;
        }
        
        // UIView+MDCSwipeToChoose and MDCSwipeToChooseView are heavily customizable.
        // Each take an "options" argument. Here, we specify the view controller as
        // a delegate, and provide a custom callback that moves the back card view
        // based on how far the user has panned the front card view.
        var options : SwipeToChooseViewOptions = SwipeToChooseViewOptions()
        options.delegate = self
        options.threshold = 160.0
        options.onPan = { state -> Void in
            if(self.backCardView != nil){
                var frame:CGRect = self.frontCardViewFrame()
                self.backCardView.frame = CGRectMake(frame.origin.x, frame.origin.y-(state.thresholdRatio * 10.0), CGRectGetWidth(frame), CGRectGetHeight(frame))
            }
        }
        
        // Create a personView with the top person in the people array, then pop
        // that person off the stack.
        
        var productView : ChooseProductView = ChooseProductView(frame: frame, product : self.products[0], options: options)
        self.products.removeAtIndex(0)
        return productView
        
    }
    
    func frontCardViewFrame() -> CGRect{
        var horizontalPadding:CGFloat = 20.0
        var topPadding:CGFloat = 60.0
        var bottomPadding:CGFloat = 200.0
        return CGRectMake(horizontalPadding,topPadding,CGRectGetWidth(self.view.frame) - (horizontalPadding * 2), CGRectGetHeight(self.view.frame) - bottomPadding)
    }
    
    func backCardViewFrame() -> CGRect{
        var frontFrame:CGRect = frontCardViewFrame()
        return CGRectMake(frontFrame.origin.x, frontFrame.origin.y + 10.0, CGRectGetWidth(frontFrame), CGRectGetHeight(frontFrame))
    }
    
    func constructNopeButton() -> Void{
        let button : UIButton =  UIButton.buttonWithType(UIButtonType.System) as! UIButton
        let image : UIImage = UIImage(named:"nope")!
        button.frame = CGRectMake(ChoosePersonButtonHorizontalPadding, CGRectGetMaxY(self.backCardView.frame) + ChoosePersonButtonVerticalPadding, image.size.width, image.size.height)
        button.setImage(image, forState: UIControlState.Normal)
        button.tintColor = UIColor(red: 247.0/255.0, green: 91.0/255.0, blue: 37.0/255.0, alpha: 1.0)
        button.addTarget(self, action: "nopeFrontCardView", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(button)
    }
    
    func constructLikedButton() -> Void{
        let button : UIButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        let image : UIImage = UIImage(named:"liked")!
        button.frame = CGRectMake(CGRectGetMaxX(self.view.frame) - image.size.width - ChoosePersonButtonHorizontalPadding, CGRectGetMaxY(self.backCardView.frame) + ChoosePersonButtonVerticalPadding, image.size.width, image.size.height)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
