//
//  YZNewsTableViewController.swift
//  My
//
//  Created by test on 15/11/26.
//  Copyright © 2015年 HAOZE. All rights reserved.
//

import UIKit
//验证消息列表
struct myYZNews {
    var mobile=""
    var FriendMobile=""
    var RequestContent = ""
    var Status = -1
    var FriendName = ""
    var FriendimgUrl = ""
    var ID = -1
    
}
class YZNewsTableViewController: UITableViewController {

    var YZNews=[myYZNews]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title=loadLanguage("验证消息")
        YZMess()
        let leftbutton=UIButton(frame: CGRect(x: 0, y: 0, width: 10, height: 21))
        leftbutton.setBackgroundImage(UIImage(named: "fanhui"), for: UIControlState())
        leftbutton.addTarget(self, action: #selector(back), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem=UIBarButtonItem(customView: leftbutton)
        self.tableView.rowHeight = 102
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden=true
    }
    func back()
    {
        _ = navigationController?.popViewController(animated: true)
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
        return YZNews.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("YanZhengCell", owner: self, options: nil)?.last as! YanZhengCell

        cell.AddButton.addTarget(self, action: #selector(AddClick), for: .touchUpInside)
        cell.AddButton.tag=(indexPath as NSIndexPath).row
        cell.headimage.image=YZNews[(indexPath as NSIndexPath).row].FriendimgUrl=="" ? UIImage(named: "DefaultHeadImage") : UIImage(data: try! Data(contentsOf: URL(string: YZNews[(indexPath as NSIndexPath).row].FriendimgUrl)!))
        cell.name.text=YZNews[(indexPath as NSIndexPath).row].FriendName=="" ? YZNews[(indexPath as NSIndexPath).row].FriendMobile : YZNews[(indexPath as NSIndexPath).row].FriendName
        cell.YZmess.text=YZNews[(indexPath as NSIndexPath).row].RequestContent
        switch (YZNews[(indexPath as NSIndexPath).row].Status)
        {
        case 1:
            cell.AddButton.isEnabled=true
            cell.AddButton.setTitle(loadLanguage("添加"), for: UIControlState())
            break
//        case 1:
//            cell.AddButton.enabled=false
//            cell.AddButton.setTitle(loadLanguage("已发送"), forState: .Normal)
//            cell.AddButton.backgroundColor=UIColor.clearColor()
//            cell.AddButton.setTitleColor(UIColor.grayColor(), forState: .Normal)
//            break
        case 2:
            cell.AddButton.isEnabled=false
            cell.AddButton.setTitle(loadLanguage("已添加"), for: UIControlState())
            cell.AddButton.backgroundColor=UIColor.clear
            cell.AddButton.setTitleColor(UIColor.gray, for: UIControlState())
            break
        default:
            break
            
        }
        // Configure the cell...

        cell.selectionStyle=UITableViewCellSelectionStyle.none
        
        return cell
    }
    func AddClick(_ button:UIButton)
    {
        let werbservice = UserInfoActionWerbService()
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let tmpid = String(YZNews[button.tag].ID)
        print(tmpid)
        werbservice.acceptUserVerify(tmpid){ (data,statusManager) -> Void in
            MBProgressHUD.hide(for: self.view, animated: true)
            if statusManager?.networkStatus==kSuccessStatus
            {
                let state=(data as AnyObject).object(forKey: "state") as! Int
                if state>0
                {
                    button.backgroundColor=UIColor.clear
                    button.isEnabled=false
                    button.setTitle(loadLanguage("已添加"), for: UIControlState())
                    button.setTitleColor(UIColor(red: 109/255, green: 110/255, blue: 111/255, alpha: 1), for: UIControlState())
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "OtherAcceptMeNews"), object: nil)//.addObserver(self, selector: Selector("updateFriendList"), name: "OtherAcceptMeNews", object: nil)
                }
                else
                {
                    let alert=UIAlertView(title: "", message:loadLanguage("添加失败，请重试！"), delegate: self, cancelButtonTitle: "ok")
                    alert.show()
                }
            }
            else
            {
                let alert=UIAlertView(title: "", message:loadLanguage("网络请求失败"), delegate: self, cancelButtonTitle: "ok")
                alert.show()
            }
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

    func YZMess()
    {
        let werbservice = UserInfoActionWerbService()
        MBProgressHUD.showAdded(to: self.view, animated: true)
        werbservice.getUserVerifMessage({ (response,statusManager) -> Void in
            MBProgressHUD.hide(for: self.view, animated: true)
            if statusManager?.networkStatus==kSuccessStatus
            {
                let responseObject = response as AnyObject
                let state=responseObject.object(forKey: "state") as! Int
                
                if state>0
                {
                    let YZmsg=responseObject.object(forKey: "msglist") as! NSMutableArray
                    for i in 0...(YZmsg.count-1)
                    {
                        var myYZNewss = myYZNews()
                        myYZNewss.mobile=get_Phone()
                        myYZNewss.FriendimgUrl=""
                        let tmpMsg = YZmsg[i] as AnyObject
                        myYZNewss.FriendMobile=tmpMsg.object(forKey: "FriendMobile") as! String
                        if tmpMsg.object(forKey: "Nickname") != nil
                        {
                            myYZNewss.FriendName=tmpMsg.object(forKey: "Nickname") as! String
                        }
                        if tmpMsg.object(forKey: "Icon") != nil
                        {
                            myYZNewss.FriendimgUrl=tmpMsg.object(forKey: "Icon") as! String
                        }
                        
                        myYZNewss.ID=tmpMsg.object(forKey: "ID") as! Int
                        let tmpphone=tmpMsg.object(forKey: "Mobile") as! String
                        if tmpphone != myYZNewss.mobile
                        {
                            myYZNewss.FriendMobile=tmpMsg.object(forKey: "Mobile") as! String
                        }
                        
                        
                    myYZNewss.RequestContent=tmpMsg.object(forKey: "RequestContent") as! String
                        myYZNewss.Status = tmpMsg.object(forKey: "Status") as! Int
                        self.YZNews.append(myYZNewss)
                    }
                    self.tableView.reloadData()
                }
                
            }
            
        })
    }

}
