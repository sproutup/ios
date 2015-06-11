//
//  ProductInformationViewController.swift
//  SproutUp
//
//  Created by Apurv Sethi on 6/4/15.
//  Copyright (c) 2015 SproutUp Co. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class ProductInformationViewController: UIViewController, UIScrollViewDelegate {
    
    var product : Product!
    var productImages : [UIImage!]!
    var productInfoView : UIScrollView!
    var imageScrollView : UIScrollView!
    var imagePageControl : UIPageControl!
    var descriptionView : UILabel!
    var video : AVPlayerViewController!
    var playButton : UIButton!
    var backButton : UIButton!
    
    let scrollViewTopPadding : CGFloat = 20.0
    let scrollHeight : CGFloat = 300.0
    let scrollImageTopPadding : CGFloat = 20.0
    let scrollImageBottomPadding : CGFloat = 15.0
    let scrollImageHorizontalPadding : CGFloat = 60.0
    let pageControlHeight : CGFloat = 10.0
    let betweenScrollDescription : CGFloat = 10.0
    let descriptionHorizontalPadding : CGFloat = 20.0
    let descriptionHeight : CGFloat = 90.0
    let betweenDescriptionVideo : CGFloat = 10.0
    let videoHorizontalPadding : CGFloat = 20.0
    let videoHeight : CGFloat = 200
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productImages = self.product.images
        constructProductInfoView()
        constructBackButton()
    }
    
    func constructProductInfoView() {
        self.productInfoView = UIScrollView(frame: self.view.frame)
        self.view.addSubview(self.productInfoView)
        constructImageScrollView()
        constructDescriptionView()
        constructVideo()
    }
    
    func constructImageScrollView() {
        self.imageScrollView = UIScrollView(frame: CGRectMake(0.0, scrollViewTopPadding, self.view.bounds.width, scrollHeight))
        for index in 0..<self.productImages.count {
            var frame : CGRect = CGRectMake(0.0, scrollImageTopPadding,
                self.imageScrollView.frame.width - scrollImageHorizontalPadding * 2,
                self.imageScrollView.frame.height - scrollImageTopPadding - scrollImageBottomPadding)
            frame.origin.x = self.imageScrollView.bounds.width * CGFloat(index) + scrollImageHorizontalPadding
            self.imageScrollView.pagingEnabled = true
            
            var subView = UIImageView(frame: frame)
            subView.image = self.productImages[index]
            self.imageScrollView.addSubview(subView)
        }
        
        self.imageScrollView.contentSize = CGSizeMake(self.imageScrollView.frame.size.width * CGFloat(self.productImages.count), self.imageScrollView.frame.size.height)
        self.imageScrollView.showsHorizontalScrollIndicator = false
        self.imageScrollView.pagingEnabled = true
        self.imageScrollView.delegate = self
        self.imageScrollView.clipsToBounds = false
        self.productInfoView.addSubview(self.imageScrollView)
        
        constructImagePageControl()
    }
    
    func constructImagePageControl() {
        self.imagePageControl = UIPageControl(frame: CGRectMake(0.0, self.imageScrollView.frame.maxY, self.view.bounds.width, pageControlHeight))
        self.imagePageControl.numberOfPages = self.productImages.count
        self.imagePageControl.currentPage = 0
        self.imagePageControl.tintColor = UIColor.redColor()
        self.imagePageControl.pageIndicatorTintColor = UIColor.blackColor()
        self.imagePageControl.currentPageIndicatorTintColor = UIColor.greenColor()
        self.imagePageControl.addTarget(self, action: Selector("changeImagePage:"), forControlEvents: UIControlEvents.ValueChanged)
        self.productInfoView.addSubview(self.imagePageControl)
    }
    
    func constructDescriptionView() {
        self.descriptionView = UILabel(frame: CGRectMake(descriptionHorizontalPadding, self.imagePageControl.frame.maxY + self.betweenScrollDescription, self.view.frame.width - self.descriptionHorizontalPadding * 2, 0.0))
        self.descriptionView.lineBreakMode = NSLineBreakMode.ByWordWrapping
        self.descriptionView.numberOfLines = 0
        self.descriptionView.text = product.moreInfo
        self.descriptionView.frame.size = self.descriptionView.sizeThatFits(CGSizeMake(self.view.frame.width - self.descriptionHorizontalPadding * 2, CGFloat.max))
        self.productInfoView.addSubview(self.descriptionView)
    }
    
    func constructVideo() {
        self.video = AVPlayerViewController()
        self.video.player = AVPlayer(URL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(product.videoName, ofType: product.videoType)!))
        self.video.view.frame = CGRectMake(videoHorizontalPadding, self.descriptionView.frame.maxY + self.betweenDescriptionVideo, self.view.frame.width - videoHorizontalPadding * 2, self.videoHeight)
        self.productInfoView.addSubview(self.video.view)
        constructPlayButton()
    }
    
    func constructPlayButton() {
        self.playButton = UIButton(frame : self.video.view.frame)
        self.playButton.backgroundColor = UIColor.blackColor()
        self.playButton.setTitle("Play", forState: UIControlState.Normal)
        self.playButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.playButton.addTarget(self, action: "pressedPlay", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(self.playButton)
    }
    
    func constructBackButton() {
        self.backButton = UIButton(frame : backButtonFrame())
        self.backButton.backgroundColor = UIColor.blackColor()
        self.backButton.setTitle("Back", forState: UIControlState.Normal)
        self.backButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.backButton.addTarget(self, action: "didTapBack", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(self.backButton)
    }
    
    func backButtonFrame() -> CGRect {
        return CGRectMake(self.view.frame.minX,self.view.frame.maxY - 30,self.view.frame.width, 30)
    }
    
    func changeImagePage(sender: AnyObject) -> () {
        let x = CGFloat(self.imagePageControl.currentPage) * self.imageScrollView.frame.size.width
        self.imageScrollView.setContentOffset(CGPointMake(x, 0), animated: true)
    }
    
    func scrollViewDidEndDecelerating(imageScrollView: UIScrollView) {
        let pageNumber = round(self.imageScrollView.contentOffset.x / self.imageScrollView.frame.size.width)
        self.imagePageControl.currentPage = Int(pageNumber)
    }
    
    func pressedPlay() {
        println("pressed play")
        self.playButton.alpha = 0.0
        
        //self.video.setFullscreen(true, animated: true)
        self.video.player.play()
    }
    
    func didTapBack() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}