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
    var currentBodyPart=BodyParts.Face
    var WaterReplenishDevice:WaterReplenishmentMeter?
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
        
        
        //初始化数据
        getAllWeakAndMonthData()
        FooterView.selectionStyle=UITableViewCellSelectionStyle.None
        
    }
   
    func getAllWeakAndMonthData()
    {
        //测试数据
        let tmpIndex=[BodyParts.Face:0,BodyParts.Eyes:1,BodyParts.Hands:2,BodyParts.Neck:3][currentBodyPart]!
        var dataDic=[String:HeadOfWaterReplenishStruct]()
        //下载周月数据
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        let deviceService=DeviceWerbservice()
        deviceService.GetBuShuiFenBu(WaterReplenishDevice?.identifier, action: currentBodyPart.rawValue) { [weak self](dataArr, Status) in
            MBProgressHUD.hideHUDForView(self!.view, animated: true)
            if Status.networkStatus==kSuccessStatus
            {
                
                let tmpKeyArr=["FaceSkinValue","EyesSkinValue","HandSkinValue","NeckSkinValue"]
                let tmpData=dataArr.objectForKey("data")
                let weekArray=NSMutableDictionary()
                let monthArray=NSMutableDictionary()
                for i in 0...3
                {
                    let tmpWeek=NSMutableArray()
                    let tmpMonth=NSMutableArray()
                    let tempBody=tmpData?.objectForKey(tmpKeyArr[i])
                    
                    
                    
                    //周数据
                    for item in (tempBody?.objectForKey("week") as! NSArray)
                    {
                        let record=CupRecord()
                        record.TDS_Bad=(item.objectForKey("ynumber") as! NSNumber).intValue//油分
                        record.TDS_Good=(item.objectForKey("snumber") as! NSNumber).intValue//水分
                        let dateStr=dateStampToString((item.objectForKey("updatetime") as! String), format: "yyyy-MM-dd")
                        record.start=dateFromString(dateStr, format: "yyyy-MM-dd")
                        tmpWeek.addObject(record)
                        //item.objectForKey("times")
                    }
                    //月数据
                    var maxTimes=0
                    var todayValue:Double=0
                    var lastValue:Double=0
                    var totolValue:Double=0
                    for item in (tempBody?.objectForKey("monty") as! NSArray)
                    {
                        let record=CupRecord()
                        record.TDS_Bad=(item.objectForKey("ynumber") as! NSNumber).intValue//油分
                        record.TDS_Good=(item.objectForKey("snumber") as! NSNumber).intValue//水分
                        totolValue+=Double(record.TDS_Good)
                        let dateStr=dateStampToString((item.objectForKey("updatetime") as! String), format: "yyyy-MM-dd")
                        record.start=dateFromString(dateStr, format: "yyyy-MM-dd")
                        tmpMonth.addObject(record)
                        print(stringFromDate(NSDate(), format: "yyyy-MM-dd"))
                        if stringFromDate(record.start, format: "yyyy-MM-dd")==stringFromDate(NSDate(), format: "yyyy-MM-dd")
                        {
                            todayValue=Double(record.TDS_Good)
                        }
                        maxTimes=max(maxTimes,item.objectForKey("times") as! Int)
                    }
                    
                    let tmpCount=(tempBody?.objectForKey("monty") as! NSArray).count
                    if tmpCount<=1
                    {
                        lastValue=todayValue
                    }
                    else{
                        let LastData=tempBody?.objectForKey("monty")?.objectAtIndex(tmpCount-2)
                        lastValue=LastData?.objectForKey("snumber") as! Double
                    }
                    let tmpAveValue=tmpCount==0 ? 0:(totolValue/Double(tmpCount))
                    let tmpStru=HeadOfWaterReplenishStruct(skinValueOfToday: todayValue, lastSkinValue: lastValue, averageSkinValue:tmpAveValue, checkTimes: maxTimes)
                    dataDic["\(i)"]=tmpStru
                    weekArray.setValue(tmpWeek, forKey: "\(i)")
                    monthArray.setValue(tmpMonth, forKey: "\(i)")
                }
                //初始化传入数据
                self!.HeadView.dataDic=dataDic
                self!.HeadView.currentOrgan=tmpIndex
                //初始化传入数据
                self!.FooterView.updateCellData(weekArray, monthArr: monthArray, Organ: tmpIndex)
            
            }
        }
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
//        let toWhatControll=ToWhatViewController(nibName: "ToWhatViewController", bundle: nil)
//        toWhatControll.title="油分"
//        self.navigationController?.pushViewController(toWhatControll, animated: true)
    }
    func toWhatOfWater()
    {
//        let toWhatControll=ToWhatViewController(nibName: "ToWhatViewController", bundle: nil)
//        toWhatControll.title="水分"
//        self.navigationController?.pushViewController(toWhatControll, animated: true)
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
