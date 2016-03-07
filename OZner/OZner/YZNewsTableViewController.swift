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
        leftbutton.setBackgroundImage(UIImage(named: "fanhui"), forState: .Normal)
        leftbutton.addTarget(self, action: Selector("back"), forControlEvents: .TouchUpInside)
        self.navigationItem.leftBarButtonItem=UIBarButtonItem(customView: leftbutton)
        self.tableView.rowHeight = 102
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden=true
    }
    func back()
    {
        self.navigationController?.popViewControllerAnimated(true)
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
        return YZNews.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = NSBundle.mainBundle().loadNibNamed("YanZhengCell", owner: self, options: nil).last as! YanZhengCell

        cell.AddButton.addTarget(self, action: Selector("AddClick:"), forControlEvents: .TouchUpInside)
        cell.AddButton.tag=indexPath.row
        cell.headimage.image=YZNews[indexPath.row].FriendimgUrl=="" ? UIImage(named: "DefaultHeadImage") : UIImage(data: NSData(contentsOfURL: NSURL(string: YZNews[indexPath.row].FriendimgUrl)!)!)
        cell.name.text=YZNews[indexPath.row].FriendName=="" ? YZNews[indexPath.row].FriendMobile : YZNews[indexPath.row].FriendName
        cell.YZmess.text=YZNews[indexPath.row].RequestContent
        switch (YZNews[indexPath.row].Status)
        {
        case 1:
            cell.AddButton.enabled=true
            cell.AddButton.setTitle(loadLanguage("添加"), forState: .Normal)
            break
//        case 1:
//            cell.AddButton.enabled=false
//            cell.AddButton.setTitle(loadLanguage("已发送"), forState: .Normal)
//            cell.AddButton.backgroundColor=UIColor.clearColor()
//            cell.AddButton.setTitleColor(UIColor.grayColor(), forState: .Normal)
//            break
        case 2:
            cell.AddButton.enabled=false
            cell.AddButton.setTitle(loadLanguage("已添加"), forState: .Normal)
            cell.AddButton.backgroundColor=UIColor.clearColor()
            cell.AddButton.setTitleColor(UIColor.grayColor(), forState: .Normal)
            break
        default:
            break
            
        }
        // Configure the cell...

        cell.selectionStyle=UITableViewCellSelectionStyle.None
        
        return cell
    }
    func AddClick(button:UIButton)
    {
        let werbservice = UserInfoActionWerbService()
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        let tmpid = String(YZNews[button.tag].ID)
        print(tmpid)
        werbservice.acceptUserVerify(tmpid){ (data:AnyObject!,statusManager: StatusManager!) -> Void in
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            if statusManager.networkStatus==kSuccessStatus
            {
                let state=data.objectForKey("state") as! Int
                if state>0
                {
                    button.backgroundColor=UIColor.clearColor()
                    button.enabled=false
                    button.setTitle(loadLanguage("已添加"), forState: .Normal)
                    button.setTitleColor(UIColor(red: 109/255, green: 110/255, blue: 111/255, alpha: 1), forState: .Normal)
                    NSNotificationCenter.defaultCenter().postNotificationName("OtherAcceptMeNews", object: nil)//.addObserver(self, selector: Selector("updateFriendList"), name: "OtherAcceptMeNews", object: nil)
                }
                else
                {
                    let alert=UIAlertView(title: "", message: "添加失败，请重试！", delegate: self, cancelButtonTitle: "ok")
                    alert.show()
                }
            }
            else
            {
                let alert=UIAlertView(title: "", message: "网络请求失败", delegate: self, cancelButtonTitle: "ok")
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
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        werbservice.getUserVerifMessage({ (responseObject:AnyObject!,statusManager: StatusManager!) -> Void in
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            if statusManager.networkStatus==kSuccessStatus
            {
                let state=responseObject.objectForKey("state") as! Int
                print(responseObject)
                if state>0
                {
                    let YZmsg=responseObject.objectForKey("msglist") as! NSMutableArray
                    for i in 0...(YZmsg.count-1)
                    {
                        var myYZNewss = myYZNews()
                        myYZNewss.mobile=get_Phone()
                        myYZNewss.FriendimgUrl=""
                        myYZNewss.FriendMobile=YZmsg[i].objectForKey("FriendMobile") as! String
                        if YZmsg[i].objectForKey("Nickname")?.isKindOfClass(NSNull)==false
                        {
                            myYZNewss.FriendName=YZmsg[i].objectForKey("Nickname") as! String
                        }
                        if YZmsg[i].objectForKey("Icon")?.isKindOfClass(NSNull)==false
                        {
                            myYZNewss.FriendimgUrl=YZmsg[i].objectForKey("Icon") as! String
                        }
                        
                        myYZNewss.ID=YZmsg[i].objectForKey("ID") as! Int
                        let tmpphone=YZmsg[i].objectForKey("Mobile") as! String
                        if tmpphone != myYZNewss.mobile
                        {
                            myYZNewss.FriendMobile=YZmsg[i].objectForKey("Mobile") as! String
                        }
                        
                        
                    myYZNewss.RequestContent=YZmsg[i].objectForKey("RequestContent") as! String
                        myYZNewss.Status = YZmsg[i].objectForKey("Status") as! Int
                        self.YZNews.append(myYZNewss)
                    }
                    self.tableView.reloadData()
                }
                
            }
            
        })
    }

}
