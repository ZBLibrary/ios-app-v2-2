//
//  ZanMeTableViewController.swift
//  My
//
//  Created by test on 15/11/26.
//  Copyright © 2015年 HAOZE. All rights reserved.
//

import UIKit

class ZanMeTableViewController: UITableViewController {

    var deviceType=""
    var ZanMeArrayCell=[ZanMeTableViewCell]()
    override func viewDidLoad() {
        super.viewDidLoad()

        let leftbutton=UIButton(frame: CGRect(x: 0, y: 0, width: 10, height: 21))
        leftbutton.setBackgroundImage(UIImage(named: "fanhui"), for: UIControlState())
        leftbutton.addTarget(self, action: #selector(back), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem=UIBarButtonItem(customView: leftbutton)
        self.tableView.rowHeight = 75
        self.loadDatafunc()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        (CustomTabBarView.sharedCustomTabBar() as AnyObject).hideOverTabBar()
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
        return ZanMeArrayCell.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return ZanMeArrayCell[(indexPath as NSIndexPath).row]
    }
    

    func loadDatafunc()
    {
        let werbservice = UserInfoActionWerbService()
        MBProgressHUD.showAdded(to: self.view, animated: true)
        werbservice.whoLikeMe(deviceType, return: { (data1, status) -> Void in
            if status?.networkStatus == kSuccessStatus
            {
                let data = data1 as AnyObject
                
                let state=data.object(forKey: "state") as! Int
                if state>0
                {
                    
                    let rankcount=data.object(forKey: "data") as! NSMutableArray
                    print(rankcount)
                    for i in 0...(rankcount.count-1)
                    {
                        let tmpZanCell=Bundle.main.loadNibNamed("ZanMeTableViewCell", owner: self, options: nil)?.last as! ZanMeTableViewCell
                        
                        let tmprankData=rankcount[i] as! NSMutableDictionary
                        
                        
                        
                        
                        tmpZanCell.zanMeName.text=tmprankData.object(forKey: "Nickname")==nil ? "无名" : (tmprankData.object(forKey: "Nickname") as! String)
                        
                        var likeTime=tmprankData.object(forKey: "liketime") as! NSString
                        likeTime=dateStampToString(likeTime as String, format: "MM-dd")
//                        likeTime=likeTime.substringFromIndex(6)
//                        likeTime=likeTime.substringToIndex(likeTime.length-2)
//                        let  formatter = NSDateFormatter()
//                        formatter.dateStyle = NSDateFormatterStyle.MediumStyle
//                        formatter.timeStyle = NSDateFormatterStyle.ShortStyle
//                        formatter.dateFormat="MM-dd"
//                        
//                        let date = formatter.dateFromString(likeTime as String)
                        tmpZanCell.zanMeTime.text="\(likeTime)"
                        
                        let imgUrl=tmprankData.object(forKey: "Icon")==nil ? "" : (tmprankData.object(forKey: "Icon") as! String)
                        if tmprankData.object(forKey: "Icon")==nil
                        {
                            tmpZanCell.zanMeImage.image=UIImage(named: "DefaultHeadImage")
                        }
                        else
                        {
                            tmpZanCell.zanMeImage.image=UIImage(data: try! Data(contentsOf: URL(string: imgUrl)!))
                        }
                        tmpZanCell.selectionStyle=UITableViewCellSelectionStyle.none
                        self.ZanMeArrayCell.append(tmpZanCell)
                    }
                    self.tableView.reloadData()
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
