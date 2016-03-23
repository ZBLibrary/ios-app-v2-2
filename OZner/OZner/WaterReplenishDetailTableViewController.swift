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
        HeadView.backButton.addTarget(self, action: #selector(backClick), forControlEvents: .TouchUpInside)
        HeadView.shareButton.addTarget(self, action: #selector(shareClick), forControlEvents: .TouchUpInside)
        
        FooterView = NSBundle.mainBundle().loadNibNamed("FooterOfWaterReplenishDetailCell", owner: self, options: nil).last as!  FooterOfWaterReplenishDetailCell
        FooterView.toWhatYoufen.addTarget(self, action: #selector(toWhatOfYou), forControlEvents: .TouchUpInside)
        FooterView.toWhatWater.addTarget(self, action: #selector(toWhatOfWater), forControlEvents: .TouchUpInside)
        FooterView.toChatButton.addTarget(self, action: #selector(toChatButton), forControlEvents: .TouchUpInside)
        FooterView.toBuyEssence.addTarget(self, action: #selector(toBuyEssence), forControlEvents: .TouchUpInside)
        HeadView.delegate=FooterView//头部视图器官切换代理
        //测试数据
        let weekArray=NSMutableDictionary()
        let monthArray=NSMutableDictionary()
        
        for j in 0...3
        {
            let tmpArr=NSMutableArray()
            for i in 0...30
            {
                let record=CupRecord()
                record.TDS_Bad=Int32((i*21+j*i*i*8+13*j+37)%50+50)
                record.TDS_Good=Int32((i*11+j*i*i*13+7*j+31)%50+0)
                record.start=NSDate(timeIntervalSince1970: (NSDate().timeIntervalSince1970+NSTimeInterval(3600*24*i)))
                tmpArr.addObject(record)
                
            }
            weekArray.setValue(tmpArr, forKey: "\(j)")
            monthArray.setValue(tmpArr, forKey: "\(j)")
        }
        //初始化传入数据
        FooterView.updateCellData(weekArray, monthArr: monthArray, Organ: 1)
        FooterView.selectionStyle=UITableViewCellSelectionStyle.None
        
    }
    func backClick()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    func shareClick()
    {
        
    }
    //
    func toWhatOfYou()
    {
        let toWhatControll=ToWhatViewController(nibName: "ToWhatViewController", bundle: nil)
        toWhatControll.title="油分"
        self.navigationController?.pushViewController(toWhatControll, animated: true)
    }
    func toWhatOfWater()
    {
        let toWhatControll=ToWhatViewController(nibName: "ToWhatViewController", bundle: nil)
        toWhatControll.title="水分"
        self.navigationController?.pushViewController(toWhatControll, animated: true)
    }
    func toChatButton()
    {
        CustomTabBarView.sharedCustomTabBar().touchDownAction((CustomTabBarView.sharedCustomTabBar().btnMuArr as NSMutableArray).objectAtIndex(2) as! UIButton)
    }
    func toBuyEssence()
    {
        CustomTabBarView.sharedCustomTabBar().touchDownAction((CustomTabBarView.sharedCustomTabBar().btnMuArr as NSMutableArray).objectAtIndex(1) as! UIButton)
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
