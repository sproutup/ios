//
//  MenuViewController.swift
//  SproutUp
//
//  Created by Apurv Sethi on 6/11/15.
//  Copyright (c) 2015 SproutUp Co. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView! = UITableView()
    
    var items: [String] = ["Liked list", "Something else", "Back"]
    
    var likedProducts : [Product]!
    var selectedRow : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.frame         =   CGRectMake(0, 50, 320, 200);
        tableView.delegate      =   self
        tableView.dataSource    =   self
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.view.addSubview(tableView)
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
        if indexPath.row == 0 {
            self.performSegueWithIdentifier("likedListSegue", sender: nil)
        }
        if indexPath.row == 2 {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "likedListSegue" {
            var destViewController : LikedListViewController = segue.destinationViewController as! LikedListViewController
            destViewController.likedProducts = self.likedProducts
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}