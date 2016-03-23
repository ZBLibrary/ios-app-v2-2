//
//  My_TDSTableViewController.swift
//  My
//
//  Created by test on 15/11/26.
//  Copyright © 2015年 HAOZE. All rights reserved.
//

import UIKit

class My_TDSTableViewController: UITableViewController {

    struct tdsRankstruct {
        var userid=""
        var rank=""
        var volume=""
        var Nickname=""
        var Icon=""
        //暂无
        var zanCount="22"
        var iszan=false
        var type=""
    }
    var deviceTypezb=""
    var tds_Maxzb=1000
    var tdsarray=[tdsRankstruct]()
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let leftbutton=UIButton(frame: CGRect(x: 0, y: 0, width: 10, height: 21))
        leftbutton.setBackgroundImage(UIImage(named: "fanhui"), forState: .Normal)
        leftbutton.addTarget(self, action: #selector(back), forControlEvents: .TouchUpInside)
        self.navigationItem.leftBarButtonItem=UIBarButtonItem(customView: leftbutton)
        self.tableView.rowHeight = 82
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        print(deviceTypezb)
        loadDatafunc()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func back()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tdsarray.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = NSBundle.mainBundle().loadNibNamed("My_Rank_TDSCell", owner: self, options: nil).last as! My_Rank_TDSCell
        //加载数据
        cell.tdsrank.text=tdsarray[indexPath.row].rank
        cell.tdsName.text=tdsarray[indexPath.row].Nickname
        if tdsarray[indexPath.row].Icon != ""
        {
            cell.tdsHeadImg.image=UIImage(data: NSData(contentsOfURL: NSURL(fileURLWithPath: tdsarray[indexPath.row].Nickname))!)
        }
        cell.tds.text=tdsarray[indexPath.row].volume
        let tmpframe=cell.jinduImage.frame
        let tmpwidth=(cell.jinduImage.superview?.frame.width)!*CGFloat(Int(cell.tds.text!)!/tds_Maxzb)
        cell.jinduImage.frame=CGRect(x: 0, y: tmpframe.origin.y, width: tmpwidth, height: tmpframe.size.height)
        cell.zancount.text=tdsarray[indexPath.row].zanCount
        cell.zanimg.image=UIImage(named: tdsarray[indexPath.row].iszan==true ? "Rank_Zaned":"Rank_Zan")
        cell.zanButton.addTarget(self, action: #selector(zanClick), forControlEvents: .TouchUpInside)
        cell.zanButton.enabled = !tdsarray[indexPath.row].iszan
        cell.zanButton.tag=indexPath.row
        cell.selectionStyle=UITableViewCellSelectionStyle.None
        return cell
    }
    func zanClick(button:UIButton)
    {
        let werbservice = UserInfoActionWerbService()
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        werbservice.LikeOtherUser(deviceTypezb, type: tdsarray[button.tag].userid, returnBlock:{ (status:StatusManager!) -> Void in
            if status.networkStatus == kSuccessStatus
            {
                //let state=data.objectForKey("state") as! Int
                //self.tdsarray[button.tag].iszan=true
                self.tableView.reloadData()
            }
            else
            {
                let alert = UIAlertView(title: "", message: "网络不稳定，点赞失败", delegate: self, cancelButtonTitle: "ok")
                alert.show()
            }
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        })
        
        
    }
    func loadDatafunc()
    {
        
        print("type="+deviceTypezb+"&usertoken="+get_UserToken())
        let werbservice = UserInfoActionWerbService()
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        werbservice.TdsFriendRank(deviceTypezb, returnBlock: { (data:AnyObject!, status:StatusManager!) -> Void in
            if status.networkStatus == kSuccessStatus
            {
                if data==nil
                {
                    return
                }
                let state=data.objectForKey("state") as! Int
                if state>0
                {
                    
                    let rankcount=data.objectForKey("data") as! NSMutableArray
                    print(rankcount)
                    for i in 0...(rankcount.count-1)
                    {
                        var rankstrut=tdsRankstruct()
                        
                        let tmprankData=rankcount[i] as! NSMutableDictionary
                        rankstrut.rank=String(tmprankData.objectForKey("rank"))
                        rankstrut.volume=String(tmprankData.objectForKey("volume"))
                        rankstrut.Nickname=tmprankData.objectForKey("Nickname")?.isKindOfClass(NSNull)==true ? "" : (tmprankData.objectForKey("Nickname") as! String)
                        rankstrut.Icon=tmprankData.objectForKey("Icon")?.isKindOfClass(NSNull)==true ? "" : (tmprankData.objectForKey("Icon") as! String)
                        rankstrut.userid=String(tmprankData.objectForKey("userid"))
                        
                        rankstrut.zanCount=String(tmprankData.objectForKey("LikeCount"))
                        rankstrut.iszan=String(tmprankData.objectForKey("isLike"))=="1" ? true:false
                        
                        self.tdsarray.append(rankstrut)
                    }
                }
                
            }
            MBProgressHUD.hideHUDForView(self.view, animated: true)

            })
        
        
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
