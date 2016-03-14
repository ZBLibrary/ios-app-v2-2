//
//  WaterReplenishDetailTableViewController.swift
//  OZner
//
//  Created by 赵兵 on 16/3/8.
//  Copyright © 2016年 sunlinlin. All rights reserved.
//

import UIKit

class WaterReplenishDetailTableViewController: UITableViewController {

    var HeadView:HeadOfWaterReplenishDetailCell!
    var FooterView:FooterOfWaterReplenishDetailCell!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets=false
        
        HeadView = NSBundle.mainBundle().loadNibNamed("HeadOfWaterReplenishDetailCell", owner: self, options: nil).last as!  HeadOfWaterReplenishDetailCell
        HeadView.selectionStyle=UITableViewCellSelectionStyle.None
        HeadView.backButton.addTarget(self, action: Selector("backClick"), forControlEvents: .TouchUpInside)
        HeadView.shareButton.addTarget(self, action: Selector("shareClick"), forControlEvents: .TouchUpInside)
        FooterView = NSBundle.mainBundle().loadNibNamed("FooterOfWaterReplenishDetailCell", owner: self, options: nil).last as!  FooterOfWaterReplenishDetailCell
        FooterView.selectionStyle=UITableViewCellSelectionStyle.None
        
    }
    func backClick()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    func shareClick()
    {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row==0
        {
            return 332
        }
        else
        {
            return 470
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row==0
        {
            return HeadView
        }else
        {
            return FooterView
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        CustomTabBarView.sharedCustomTabBar().hideOverTabBar()
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
