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
    var productView : ChooseProductView!
    
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
        self.setProdView(self.popPersonViewWithFrame(productViewFrame())!)
        self.view.addSubview(self.productView)
        constructNopeButton()
        constructLikedButton()
    }
    
    func setProdView(productView : ChooseProductView) {
        self.productView = productView
        self.currentPerson = productView.product
    }
    
    func defaultProducts() -> [Product] {
        return [
            Product(name: "One",
                images: [UIImage(named: "3"), UIImage(named: "5"), UIImage(named: "8")],
                description: "Product number one",
                moreInfo: "This is product number one. Deck of cards. More specifically, contains the number 3, 5, and 8. No others guaranteed"),
            Product(name: "Two", images: [UIImage(named: "5")], description: "Product number two", moreInfo: ""),
            Product(name: "Three", images: [UIImage(named: "8")], description: "Product number three", moreInfo: "")]
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
            println("Photo deleted!")
        }
        else {
            println("Photo saved!")
            self.performSegueWithIdentifier("likedSegue", sender: nil)
        }
        let delay = 0.15 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()) {
            if self.products.count != 0 {
                self.productView = self.popPersonViewWithFrame(self.productViewFrame())
                self.view.addSubview(self.productView)
            }
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
        options.threshold = 120.0
        options.onPan = { state -> Void in }
        
        var productView : ChooseProductView = ChooseProductView(frame: frame, product : self.products[0], options: options)
        productView.delegate = self
        self.products.removeAtIndex(0)
        return productView
        
    }
    
    func productViewFrame() -> CGRect{
        var horizontalPadding:CGFloat = 20.0
        var topPadding:CGFloat = 50.0
        var bottomPadding:CGFloat = 200.0
        return CGRectMake(horizontalPadding,topPadding,self.view.frame.width - (horizontalPadding * 2), self.view.frame.height - bottomPadding)
    }
    
    func constructNopeButton() -> Void{
        let button : UIButton =  UIButton.buttonWithType(UIButtonType.System) as! UIButton
        let image : UIImage = UIImage(named:"nope")!
        button.frame = CGRectMake(ChoosePersonButtonHorizontalPadding, self.productView.frame.maxY + ChoosePersonButtonVerticalPadding, image.size.width, image.size.height)
        button.setImage(image, forState: UIControlState.Normal)
        button.tintColor = UIColor(red: 247.0/255.0, green: 91.0/255.0, blue: 37.0/255.0, alpha: 1.0)
        button.addTarget(self, action: "nopeproductView", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(button)
    }
    
    func constructLikedButton() -> Void{
        let button : UIButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        let image : UIImage = UIImage(named:"liked")!
        button.frame = CGRectMake(self.view.frame.maxX - image.size.width - ChoosePersonButtonHorizontalPadding, self.productView.frame.maxY + ChoosePersonButtonVerticalPadding, image.size.width, image.size.height)
        button.setImage(image, forState:UIControlState.Normal)
        button.tintColor = UIColor(red: 29.0/255.0, green: 245.0/255.0, blue: 106.0/255.0, alpha: 1.0)
        button.addTarget(self, action: "likeproductView", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(button)
        
    }
    
    func nopeproductView() -> Void{
        self.productView.pvc_swipe(SwipeDirection.Left)
    }
    
    func likeproductView() -> Void{
        self.productView.pvc_swipe(SwipeDirection.Right)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "infoSegue" {
            var destViewController : ProductInformationViewController = segue.destinationViewController as! ProductInformationViewController
            destViewController.product = productView.product
        }
        else if segue.identifier == "likedSegue" {
            var destViewController : LikedProductViewController = segue.destinationViewController as! LikedProductViewController
            destViewController.product = productView.product
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
