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
        leftbutton.setBackgroundImage(UIImage(named: "fanhui"), for: UIControlState())
        leftbutton.addTarget(self, action: #selector(back), for: .touchUpInside)
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
        _ = navigationController?.popViewController(animated: true)
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tdsarray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("My_Rank_TDSCell", owner: self, options: nil)?.last as! My_Rank_TDSCell
        //加载数据
        cell.tdsrank.text=tdsarray[(indexPath as NSIndexPath).row].rank
        cell.tdsName.text=tdsarray[(indexPath as NSIndexPath).row].Nickname
        if tdsarray[(indexPath as NSIndexPath).row].Icon != ""
        {
            cell.tdsHeadImg.image=UIImage(data: try! Data(contentsOf: URL(fileURLWithPath: tdsarray[(indexPath as NSIndexPath).row].Nickname)))
        }
        cell.tds.text=tdsarray[(indexPath as NSIndexPath).row].volume
        let tmpframe=cell.jinduImage.frame
        let tmpwidth=(cell.jinduImage.superview?.frame.width)!*CGFloat(Int(cell.tds.text!)!/tds_Maxzb)
        cell.jinduImage.frame=CGRect(x: 0, y: tmpframe.origin.y, width: tmpwidth, height: tmpframe.size.height)
        cell.zancount.text=tdsarray[(indexPath as NSIndexPath).row].zanCount
        cell.zanimg.image=UIImage(named: tdsarray[(indexPath as NSIndexPath).row].iszan==true ? "Rank_Zaned":"Rank_Zan")
        cell.zanButton.addTarget(self, action: #selector(zanClick), for: .touchUpInside)
        cell.zanButton.isEnabled = !tdsarray[(indexPath as NSIndexPath).row].iszan
        cell.zanButton.tag=(indexPath as NSIndexPath).row
        cell.selectionStyle=UITableViewCellSelectionStyle.none
        return cell
    }
    func zanClick(_ button:UIButton)
    {
        let werbservice = UserInfoActionWerbService()
        MBProgressHUD.showAdded(to: self.view, animated: true)
        werbservice.likeOtherUser(deviceTypezb, type: tdsarray[button.tag].userid, return:{ (status) -> Void in
            if status?.networkStatus == kSuccessStatus
            {
                //let state=data.objectForKey("state") as! Int
                //self.tdsarray[button.tag].iszan=true
                self.tableView.reloadData()
            }
            else
            {
                let alert = UIAlertView(title: "", message:loadLanguage("网络不稳定，点赞失败"), delegate: self, cancelButtonTitle: "ok")
                alert.show()
            }
            MBProgressHUD.hide(for: self.view, animated: true)
        })
        
        
    }
    func loadDatafunc()
    {
        
        print("type="+deviceTypezb+"&usertoken="+get_UserToken())
        let werbservice = UserInfoActionWerbService()
        MBProgressHUD.showAdded(to: self.view, animated: true)
        werbservice.tdsFriendRank(deviceTypezb, return: { (data1, status) -> Void in
            if status?.networkStatus == kSuccessStatus
            {
                if data1==nil
                {
                    return
                }
                let data = data1 as AnyObject
                let state=data.object(forKey: "state") as! Int
                if state>0
                {
                    
                    let rankcount=data.object(forKey: "data") as! NSMutableArray
                    print(rankcount)
                    for i in 0...(rankcount.count-1)
                    {
                        var rankstrut=tdsRankstruct()
                        
                        let tmprankData=rankcount[i] as! NSMutableDictionary
                        rankstrut.rank=String(describing: tmprankData.object(forKey: "rank"))
                        rankstrut.volume=String(describing: tmprankData.object(forKey: "volume"))
                        rankstrut.Nickname=tmprankData.object(forKey: "Nickname")==nil ? "" : (tmprankData.object(forKey: "Nickname") as! String)
                        rankstrut.Icon=tmprankData.object(forKey: "Icon")==nil ? "" : (tmprankData.object(forKey: "Icon") as! String)
                        rankstrut.userid=String(describing: tmprankData.object(forKey: "userid"))
                        
                        rankstrut.zanCount=String(describing: tmprankData.object(forKey: "LikeCount"))
                        rankstrut.iszan=String(describing: tmprankData.object(forKey: "isLike"))=="1" ? true:false
                        
                        self.tdsarray.append(rankstrut)
                    }
                }
                
            }
            MBProgressHUD.hide(for: self.view, animated: true)

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
