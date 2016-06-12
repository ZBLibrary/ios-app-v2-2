//
//  WaterPurTDSDetailController.swift
//  OZner
//
//  Created by 赵兵 on 16/2/18.
//  Copyright © 2016年 sunlinlin. All rights reserved.
//

import UIKit

class WaterPurTDSDetailController: UITableViewController {
    var myCurrentDevice:WaterPurifier?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.tableView.backgroundColor=UIColor(red: 162.0/255.0, green: 231.0/255.0, blue: 251.0/255.0, alpha: 1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden=true
        CustomTabBarView.sharedCustomTabBar().hideOverTabBar()
    }
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(indexPath.row == 0)
        {
            return 194;
        }
        else if(indexPath.row == 1)
        {
            return 256;
        }
        return SCREEN_HEIGHT>584 ? (SCREEN_HEIGHT-450):134;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }

    var secondCell:WaterPurTDSDetailCell2!
    var fristCell:WaterPurTDSDetailCell1!
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.row
        {
        case 0:
            fristCell = NSBundle.mainBundle().loadNibNamed("WaterPurTDSDetailCell1", owner: self, options: nil).last as! WaterPurTDSDetailCell1
            fristCell.backButton.addTarget(self, action: #selector(toBack), forControlEvents: .TouchUpInside)
            fristCell.shareButton.addTarget(self, action: #selector(toShare), forControlEvents: .TouchUpInside)
            fristCell.toWhatTDS.addTarget(self, action: #selector(toWhatIsTDS), forControlEvents: .TouchUpInside)
            fristCell.toChat.addTarget(self, action: #selector(toChat), forControlEvents: .TouchUpInside)
            getFriendTdsRank()
            fristCell.selectionStyle=UITableViewCellSelectionStyle.None
            return fristCell
        case 1:
            secondCell = NSBundle.mainBundle().loadNibNamed("WaterPurTDSDetailCell2", owner: self, options: nil).last as! WaterPurTDSDetailCell2
            getWeekMonthData()//获取周月数据
            secondCell.selectionStyle=UITableViewCellSelectionStyle.None
            return secondCell
        default:
            let wCell = NSBundle.mainBundle().loadNibNamed("TDSFooterCellzb", owner: self, options: nil).last as! TDSFooterCellzb
            //wCell.waterKnowButton.addTarget(self, action: #selector(toWaterKnow), forControlEvents: .TouchUpInside)
            //wCell.toStoreButton.addTarget(self, action: #selector(toBuyClick), forControlEvents: .TouchUpInside)
            wCell.selectionStyle=UITableViewCellSelectionStyle.None
            return wCell
        }
        
    }
    //获取好友圈排名
    func getFriendTdsRank()
    {
        self.fristCell.updateCell(Int(max((self.myCurrentDevice?.sensor.TDS1)!, (self.myCurrentDevice?.sensor.TDS2)!)), tdsAfter: Int(min((self.myCurrentDevice?.sensor.TDS1)!, (self.myCurrentDevice?.sensor.TDS2)!)), friendsRank: 0)
        
        let manager = AFHTTPRequestOperationManager()
        let url = StarURL_New+"/OznerDevice/TdsFriendRank"
        let params:NSDictionary = ["usertoken":get_UserToken(),"type":(myCurrentDevice?.type)!]
        manager.POST(url,
            parameters: params,
            success: { (operation: AFHTTPRequestOperation!,
                responseObject: AnyObject!) in
                print(responseObject)
                let state=responseObject.objectForKey("state") as! Int
                if state > 0
                {
                    let needRank=responseObject.objectForKey("data")?.objectAtIndex(0).objectForKey("rank") as! Int
                    self.fristCell.updateCell(Int(max((self.myCurrentDevice?.sensor.TDS1)!, (self.myCurrentDevice?.sensor.TDS2)!)), tdsAfter: Int(min((self.myCurrentDevice?.sensor.TDS1)!, (self.myCurrentDevice?.sensor.TDS2)!)), friendsRank: needRank)
                }
                
            },
            failure: { (operation: AFHTTPRequestOperation!,
                error: NSError!) in
                print("Error: " + error.localizedDescription)
        })
        
        
    }
    //获取周月数据
    func getWeekMonthData()
    {
        let Service=DeviceWerbservice()
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        Service.GetDeviceTdsFenBu(myCurrentDevice?.identifier) { (weekArr:[AnyObject]!, monthArr:[AnyObject]!, status:StatusManager!) -> Void in
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            if status.networkStatus==kSuccessStatus
            {
                print(weekArr)
                let weekArray=NSMutableArray()
                for i in 0..<weekArr.count
                {
                    let tmpdic=(weekArr as NSArray).objectAtIndex(i) as! NSDictionary
                    let tmprecord=CupRecord()
                    tmprecord.start=self.toDate(tmpdic.objectForKey("stime") as! String)
                    tmprecord.TDS_Bad = (tmpdic.objectForKey("beforetds") as! NSNumber).intValue
                    tmprecord.TDS_Good=(tmpdic.objectForKey("tds") as! NSNumber).intValue
                    tmprecord.TDS_Bad=max(tmprecord.TDS_Bad, tmprecord.TDS_Good)
                    tmprecord.TDS_Good=min(tmprecord.TDS_Bad, tmprecord.TDS_Good)
                    weekArray.addObject(tmprecord)
                }
                let monthArray=NSMutableArray()
                print(monthArr)
                for i in 0..<monthArr.count
                {
                    let tmpdic=(monthArr as NSArray).objectAtIndex(i) as! NSDictionary
                    let tmprecord=CupRecord()
                    tmprecord.start=self.toDate(tmpdic.objectForKey("stime") as! String)
                    tmprecord.TDS_Bad=(tmpdic.objectForKey("beforetds") as! NSNumber).intValue
                    tmprecord.TDS_Good=(tmpdic.objectForKey("tds") as! NSNumber).intValue
                    tmprecord.TDS_Bad=max(tmprecord.TDS_Bad, tmprecord.TDS_Good)
                    tmprecord.TDS_Good=min(tmprecord.TDS_Bad, tmprecord.TDS_Good)
                    monthArray.addObject(tmprecord)
                }
                self.secondCell.weekArray=weekArray
                self.secondCell.monthArray=monthArray
            }
            self.secondCell.updateChartView(0)
            
        }
    }
    func toDate(timestr:String)->NSDate
    {
        var str:NSString = timestr
        str=str.substringFromIndex(6)
        str=str.substringToIndex(str.length-2)
        let tmpLong = (str as NSString).longLongValue/1000+28800
        
        
        return NSDate(timeIntervalSince1970: NSTimeInterval(tmpLong))
  
    }
    //返回
    func toBack()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    //分享
    func toShare()
    {
        let shareImgClass = getshareImageClass()
        //int beatzb=100-(int)((100*(double)self.defeatRank)/((double)self.defeatValue));
        //NSLog(@"%d",self.defeatValue);
        
        let image = shareImgClass.getshareImagezb(3, type: 1, value: 8, beat: 18, maxWater: 0) //getshareImagezb:self.defeatRank type:1 value:self.tdsValue beat:beatzb maxWater:0];
        
        //微信朋友圈
        ShareManager.shareManagerInstance().sendShareToWeChat(WXSceneTimeline, urt: "", title: "浩泽净水家", shareImg: image)
        
    }
    //水质纯净值说明
    func toWhatIsTDS()
    {
//        let tdsState=ToWhatViewController(nibName: "ToWhatViewController", bundle: nil)
//        tdsState.title="什么是TDS?"
//        self.navigationController?.pushViewController(tdsState, animated: true)
    }
    //咨询
    func toChat()
    {
        CustomTabBarView.sharedCustomTabBar().touchDownAction((CustomTabBarView.sharedCustomTabBar().btnMuArr as NSMutableArray).objectAtIndex(2) as! UIButton)
    }
    //健康水知道
    func toWaterKnow()
    {
        let URLController=WeiXinURLViewController(nibName: "WeiXinURLViewController", bundle: nil)
        URLController.title="健康水知道"
        self.presentViewController(URLController, animated: true, completion: nil)
    }
    //购买净水器
    func toBuyClick()
    {
        CustomTabBarView.sharedCustomTabBar().touchDownAction((CustomTabBarView.sharedCustomTabBar().btnMuArr as NSMutableArray).objectAtIndex(1) as! UIButton)
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
