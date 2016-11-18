//
//  SkinQueryTableViewController.swift
//  OZner
//
//  Created by 赵兵 on 16/3/10.
//  Copyright © 2016年 sunlinlin. All rights reserved.
//

import UIKit

class SkinQueryTableViewController_EN: UITableViewController {
 

    var headCell:SkinHeadTableViewCell_EN!
    var centerCell:SkinCenterTableViewCell_EN!
    var footerCell:SkinFooterTableViewCell!
    var currentSkinTypeIndex=0//0：无，1油，2干,3中
    var totalTimes = 0
    var TimeString = ""
    
    var currentSex=SexType.WoMan
    override func viewDidLoad() {
        super.viewDidLoad()
        //因为缺少男的图片，所以临时设置女的
//        currentSex=SexType.WoMan
        self.automaticallyAdjustsScrollViewInsets=false
        //头部视图
        headCell = NSBundle.mainBundle().loadNibNamed("SkinHeadTableViewCell_EN", owner: self, options: nil).last as!  SkinHeadTableViewCell_EN
        headCell.selectionStyle=UITableViewCellSelectionStyle.None
        headCell.backButton.addTarget(self, action: #selector(backClick), forControlEvents: .TouchUpInside)
        headCell.updateCell(currentSkinTypeIndex, sex: currentSex)
        //中部视图
        centerCell = NSBundle.mainBundle().loadNibNamed("SkinCenterTableViewCell_EN", owner: self, options: nil).last as!  SkinCenterTableViewCell_EN
        centerCell.selectionStyle=UITableViewCellSelectionStyle.None
        centerCell.updateData(totalTimes, Date: TimeString)
        //尾部视图
        footerCell = NSBundle.mainBundle().loadNibNamed("SkinFooterTableViewCell", owner: self, options: nil).last as!  SkinFooterTableViewCell
        footerCell.bugEssenceButton.addTarget(self, action: #selector(bugEssenceClick), forControlEvents: .TouchUpInside)
        footerCell.MyCurrentFuZhi(currentSkinTypeIndex, sex: currentSex)
        //传入我当前的肤质
        footerCell.selectionStyle=UITableViewCellSelectionStyle.None
        
    }

    //返回
    func backClick()
    {
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    //购买精华液
    func bugEssenceClick()
    {
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        CustomTabBarView.sharedCustomTabBar().hideOverTabBar()
    }
    // MARK: - Table view data source

    private let heightArr:[CGFloat]=[418,160,430]
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return heightArr[indexPath.row]
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row==0
        {
            return headCell
            
        }else if indexPath.row==1
        {
            return centerCell
        }
        else
        {
            return footerCell
        }
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
