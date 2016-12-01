//
//  WaterPurTDSDetailController.swift
//  OZner
//
//  Created by 赵兵 on 16/2/18.
//  Copyright © 2016年 sunlinlin. All rights reserved.
//

import UIKit

class WaterPurTDSDetailController_EN: UITableViewController {
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

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden=true
        (CustomTabBarView.sharedCustomTabBar() as AnyObject).hideOverTabBar()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if((indexPath as NSIndexPath).row == 0)
        {
            return 194;
        }
        else if((indexPath as NSIndexPath).row == 1)
        {
            return 256;
        }
        return SCREEN_HEIGHT>584 ? (SCREEN_HEIGHT-450):134;
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }

    var secondCell:WaterPurTDSDetailCell2_EN!
    var fristCell:WaterPurTDSDetailCell1_EN!
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath as NSIndexPath).row
        {
        case 0:
            fristCell = Bundle.main.loadNibNamed("WaterPurTDSDetailCell1_EN", owner: self, options: nil)?.last as! WaterPurTDSDetailCell1_EN
            fristCell.backButton.addTarget(self, action: #selector(toBack), for: .touchUpInside)
            fristCell.shareButton.addTarget(self, action: #selector(toShare), for: .touchUpInside)
            fristCell.toWhatTDS.addTarget(self, action: #selector(toWhatIsTDS), for: .touchUpInside)
            fristCell.toChat.addTarget(self, action: #selector(toChat), for: .touchUpInside)
            getFriendTdsRank()
            fristCell.selectionStyle=UITableViewCellSelectionStyle.none
            return fristCell
        case 1:
            secondCell = Bundle.main.loadNibNamed("WaterPurTDSDetailCell2_EN", owner: self, options: nil)?.last as! WaterPurTDSDetailCell2_EN
            getWeekMonthData()//获取周月数据
            secondCell.selectionStyle=UITableViewCellSelectionStyle.none
            return secondCell
        default:
            let wCell = Bundle.main.loadNibNamed("TDSFooterCellzb", owner: self, options: nil)?.last as! TDSFooterCellzb
            //wCell.waterKnowButton.addTarget(self, action: #selector(toWaterKnow), forControlEvents: .TouchUpInside)
            //wCell.toStoreButton.addTarget(self, action: #selector(toBuyClick), forControlEvents: .TouchUpInside)
            wCell.selectionStyle=UITableViewCellSelectionStyle.none
            return wCell

        }
        
    }
    //获取好友圈排名
    func getFriendTdsRank()
    {
        self.fristCell.updateCell(Int(max((self.myCurrentDevice?.sensor.tds1)!, (self.myCurrentDevice?.sensor.tds2)!)), tdsAfter: Int(min((self.myCurrentDevice?.sensor.tds1)!, (self.myCurrentDevice?.sensor.tds2)!)), friendsRank: 0)
        
        let manager = AFHTTPRequestOperationManager()
        let url = StarURL_New+"/OznerDevice/TdsFriendRank"
        let params:NSDictionary = ["usertoken":get_UserToken(),"type":(myCurrentDevice?.type)!]
//        manager.post(url, parameters: params, success: { (operation, responseObject) in
//            <#code#>
//            }) { (<#AFHTTPRequestOperation#>, <#Error#>) in
//                <#code#>
//        }
        manager.post(url,
            parameters: params,
            success: { (operation,
                response) in
                let responseObject=response as AnyObject
                let state=responseObject.object(forKey: "state") as! Int
                if state > 0
                {
                    let needRank=((responseObject.object(forKey: "data") as AnyObject).object(at: 0) as AnyObject).object(forKey: "rank") as! Int
                    self.fristCell.updateCell(Int(max((self.myCurrentDevice?.sensor.tds1)!, (self.myCurrentDevice?.sensor.tds2)!)), tdsAfter: Int(min((self.myCurrentDevice?.sensor.tds1)!, (self.myCurrentDevice?.sensor.tds2)!)), friendsRank: needRank)
                }
                
            },
            failure: { (operation,
                error) in
                print("Error: " + error.localizedDescription)
        })
        
        
    }
    //获取周月数据
    func getWeekMonthData()
    {
        let Service=DeviceWerbservice()
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Service.getDeviceTdsFenBu(myCurrentDevice?.identifier) { (weekArr, monthArr, status) -> Void in
            MBProgressHUD.hide(for: self.view, animated: true)
            if status?.networkStatus==kSuccessStatus
            {
                print(weekArr)
                let weekArray=NSMutableArray()
                for i in 0..<(weekArr?.count ?? 0)
                {
                    let tmpdic=(weekArr as AnyObject).object(at: i) as! NSDictionary
                    let tmprecord=CupRecord()
                    tmprecord.start=self.toDate(tmpdic.object(forKey: "stime") as! String)
                    tmprecord.tds_Bad = (tmpdic.object(forKey: "beforetds") as! NSNumber).int32Value
                    tmprecord.tds_Good=(tmpdic.object(forKey: "tds") as! NSNumber).int32Value
                    tmprecord.tds_Bad=max(tmprecord.tds_Bad, tmprecord.tds_Good)
                    tmprecord.tds_Good=min(tmprecord.tds_Bad, tmprecord.tds_Good)
                    weekArray.add(tmprecord)
                }
                let monthArray=NSMutableArray()
                print(monthArr)
                for i in 0..<(monthArr?.count ?? 0)
                {
                    let tmpdic=(monthArr as AnyObject).object(at: i) as! NSDictionary
                    let tmprecord=CupRecord()
                    tmprecord.start=self.toDate(tmpdic.object(forKey: "stime") as! String)
                    tmprecord.tds_Bad=(tmpdic.object(forKey: "beforetds") as! NSNumber).int32Value
                    tmprecord.tds_Good=(tmpdic.object(forKey: "tds") as! NSNumber).int32Value
                    tmprecord.tds_Bad=max(tmprecord.tds_Bad, tmprecord.tds_Good)
                    tmprecord.tds_Good=min(tmprecord.tds_Bad, tmprecord.tds_Good)
                    monthArray.add(tmprecord)
                }
                self.secondCell.weekArray=weekArray
                self.secondCell.monthArray=monthArray
            }
            self.secondCell.updateChartView(0)
            
        }
    }
    func toDate(_ timestr:String)->Date
    {
        var str:NSString = timestr as NSString
        str=str.substring(from: 6) as NSString
        str=str.substring(to: str.length-2) as NSString
        let tmpLong = (str as NSString).longLongValue/1000+28800
        return Date(timeIntervalSince1970: TimeInterval(tmpLong))
  
    }
    //返回
    func toBack()
    {
        _ = navigationController?.popViewController(animated: true)
    }
    //分享
    func toShare()
    {
        let shareImgClass = getshareImageClass()
        //int beatzb=100-(int)((100*(double)self.defeatRank)/((double)self.defeatValue));
        //NSLog(@"%d",self.defeatValue);
        
        let image = shareImgClass.getshareImagezb(3, type: 1, value: 8, beat: 18, maxWater: 0) //getshareImagezb:self.defeatRank type:1 value:self.tdsValue beat:beatzb maxWater:0];
        
        //微信朋友圈
        ShareManager.shareManagerInstance().sendShare(toWeChat: WXSceneTimeline, urt: "", title: "浩泽净水家", shareImg: image)
        
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
        let button = ((CustomTabBarView.sharedCustomTabBar() as AnyObject).btnMuArr as AnyObject).object(at: 2) as! UIButton
        (CustomTabBarView.sharedCustomTabBar() as AnyObject).touchDownAction(button)
    }
    //健康水知道
    func toWaterKnow()
    {
        let URLController=WeiXinURLViewController_EN(nibName: "WeiXinURLViewController_EN", bundle: nil)
        URLController.title=loadLanguage("健康水知道")
        self.present(URLController, animated: true, completion: nil)
    }
    //购买净水器
    func toBuyClick()
    {
        let button = ((CustomTabBarView.sharedCustomTabBar() as AnyObject).btnMuArr as AnyObject).object(at: 1) as! UIButton
        (CustomTabBarView.sharedCustomTabBar() as AnyObject).touchDownAction(button)
        
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
