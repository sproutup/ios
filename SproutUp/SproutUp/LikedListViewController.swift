//
//  LikedListViewController.swift
//  SproutUp
//
//  Created by Apurv Sethi on 6/11/15.
//  Copyright (c) 2015 SproutUp Co. All rights reserved.
//

import UIKit

class LikedListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView! = UITableView()
    
    var items: [String] = []
    
    var likedProducts : [Product]!
    var selectedRow : Int = 0
    var backButton : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        for prod in self.likedProducts {
            items.append(prod.name)
        }
        
        tableView.frame         =   CGRectMake(0, 50, 320, 200);
        tableView.delegate      =   self
        tableView.dataSource    =   self
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.view.addSubview(tableView)
        constructBackButton()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        
        cell.textLabel?.text = self.items[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("You selected cell #\(indexPath.row)!")
        self.selectedRow = indexPath.row
        self.performSegueWithIdentifier("productInfoSegue", sender: nil)
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
    
    func didTapBack() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "productInfoSegue" {
            var destViewController : ProductInformationViewController = segue.destinationViewController as! ProductInformationViewController
            destViewController.product = self.likedProducts[self.selectedRow]
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}