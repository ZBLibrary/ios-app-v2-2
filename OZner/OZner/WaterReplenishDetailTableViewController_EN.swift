//
//  WaterReplenishDetailTableViewController.swift
//  OZner
//
//  Created by 赵兵 on 16/3/8.
//  Copyright © 2016年 sunlinlin. All rights reserved.
//

import UIKit

class WaterReplenishDetailTableViewController_EN: UITableViewController {

    var HeadView:HeadOfWaterReplenishDetailCell_EN!
    var FooterView:FooterOfWaterReplenishDetailCell_EN!
    var currentBodyPart=BodyParts.Face
    var WaterReplenishDevice:WaterReplenishmentMeter?
    override func viewDidLoad() {
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets=false
        
        HeadView = Bundle.main.loadNibNamed("HeadOfWaterReplenishDetailCell_EN", owner: self, options: nil)?.last as!  HeadOfWaterReplenishDetailCell_EN
        HeadView.selectionStyle=UITableViewCellSelectionStyle.none
        HeadView.backButton.addTarget(self, action: #selector(backClick), for: .touchUpInside)
        HeadView.shareButton.addTarget(self, action: #selector(shareClick), for: .touchUpInside)
        
        FooterView = Bundle.main.loadNibNamed("FooterOfWaterReplenishDetailCell_EN", owner: self, options: nil)?.last as!  FooterOfWaterReplenishDetailCell_EN
        FooterView.toWhatYoufen.addTarget(self, action: #selector(toWhatOfYou), for: .touchUpInside)
        FooterView.toWhatWater.addTarget(self, action: #selector(toWhatOfWater), for: .touchUpInside)
        FooterView.toChatButton.addTarget(self, action: #selector(toChatButton), for: .touchUpInside)
        FooterView.toBuyEssence.addTarget(self, action: #selector(toBuyEssence), for: .touchUpInside)
        HeadView.delegate=FooterView//头部视图器官切换代理
        
        
        //初始化数据
        getAllWeakAndMonthData()
        FooterView.selectionStyle=UITableViewCellSelectionStyle.none
        
    }
   
    func getAllWeakAndMonthData()
    {
        //测试数据
        let tmpIndex=[BodyParts.Face:0,BodyParts.Eyes:1,BodyParts.Hands:2,BodyParts.Neck:3][currentBodyPart]!
        var dataDic=[String:HeadOfWaterReplenishStruct]()
        //下载周月数据
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let deviceService=DeviceWerbservice()
        deviceService.getBuShuiFenBu(WaterReplenishDevice?.identifier, action: currentBodyPart.rawValue) { [weak self](dataArr1, Status) in
            MBProgressHUD.hide(for: self!.view, animated: true)
            if Status?.networkStatus==kSuccessStatus
            {
                
                let tmpKeyArr=["FaceSkinValue","EyesSkinValue","HandSkinValue","NeckSkinValue"]
                
                let dataArr = dataArr1 as AnyObject
                
                let tmpData = dataArr.object(forKey: "data") as AnyObject
                
                let weekArray=NSMutableDictionary()
                let monthArray=NSMutableDictionary()
                for i in 0...3
                {
                    let tmpWeek=NSMutableArray()
                    let tmpMonth=NSMutableArray()
                    let tempBody=tmpData.object(forKey: tmpKeyArr[i]) as AnyObject
                    
                    
                    
                    //周数据
                    for item in (tempBody.object(forKey: "week") as! NSArray)
                    {
                        let record=CupRecord()
                        record.tds_Bad=((item as AnyObject).object(forKey: "ynumber") as! NSNumber).int32Value//油分
                        record.tds_Good=((item as AnyObject).object(forKey: "snumber") as! NSNumber).int32Value//水分
                        let dateStr=dateStampToString(((item as AnyObject).object(forKey: "updatetime") as! String), format: "yyyy-MM-dd")
                        record.start=dateFromString(dateStr, format: "yyyy-MM-dd")
                        tmpWeek.add(record)
                        //item.objectForKey("times")
                    }
                    //月数据
                    var maxTimes=0
                    var todayValue:Double=0
                    var lastValue:Double=0
                    var totolValue:Double=0
                    for item1 in (tempBody.object(forKey: "monty") as! NSArray)
                    {
                        let item=item1 as AnyObject
                        let record=CupRecord()
                        record.tds_Bad=(item.object(forKey: "ynumber") as! NSNumber).int32Value//油分
                        record.tds_Good=(item.object(forKey: "snumber") as! NSNumber).int32Value//水分
                        totolValue+=Double(record.tds_Good)
                        let dateStr=dateStampToString((item.object(forKey: "updatetime") as! String), format: "yyyy-MM-dd")
                        record.start=dateFromString(dateStr, format: "yyyy-MM-dd")
                        tmpMonth.add(record)
                        print(stringFromDate(Date(), format: "yyyy-MM-dd"))
                        if stringFromDate(record.start, format: "yyyy-MM-dd")==stringFromDate(Date(), format: "yyyy-MM-dd")
                        {
                            todayValue=Double(record.tds_Good)
                        }
                        maxTimes=max(maxTimes,item.object(forKey: "times") as! Int)
                    }
                    
                    let tmpCount=(tempBody.object(forKey: "monty") as! NSArray).count
                    if tmpCount<=1
                    {
                        lastValue=todayValue
                    }
                    else{
                        let LastData=(tempBody.object(forKey: "monty") as AnyObject).object(at: tmpCount-2)
                        lastValue=(LastData as AnyObject).object(forKey: "snumber") as! Double
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
        _ = navigationController?.popViewController(animated: true)
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
        let button = ((CustomTabBarView.sharedCustomTabBar() as AnyObject).btnMuArr as AnyObject).object(at: 2) as! UIButton
        
        (CustomTabBarView.sharedCustomTabBar() as AnyObject).touchDownAction(button)
    }
    func toBuyEssence()
    {
        let button = ((CustomTabBarView.sharedCustomTabBar() as AnyObject).btnMuArr as AnyObject).object(at: 1) as! UIButton
        
        (CustomTabBarView.sharedCustomTabBar() as AnyObject).touchDownAction(button)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath as NSIndexPath).row==0
        {
            return 332
        }
        else
        {
            return 470
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath as NSIndexPath).row==0
        {
            return HeadView
        }else
        {
            return FooterView
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        (CustomTabBarView.sharedCustomTabBar() as AnyObject).hideOverTabBar()
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
