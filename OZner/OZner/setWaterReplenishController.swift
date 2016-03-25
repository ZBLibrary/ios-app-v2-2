//
//  setWaterReplenishController.swift
//  OZner
//
//  Created by 赵兵 on 16/3/7.
//  Copyright © 2016年 sunlinlin. All rights reserved.
//

import UIKit

class setWaterReplenishController: UITableViewController,UIAlertViewDelegate {
    
    
    var settingDic:NSMutableDictionary?=getPlistData("setWaterReplenish")
    var myCurrentDevice:WaterReplenishmentMeter?
    var MainViewCell:mainOfSetWaterReplenCell!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title="智能补水仪"
        let savebutton=UIBarButtonItem(title: loadLanguage("保存"), style: .Plain, target: self, action: #selector(SaveClick))
        let leftbutton=UIButton(frame: CGRect(x: 0, y: 0, width: 10, height: 21))
        leftbutton.setBackgroundImage(UIImage(named: "fanhui"), forState: .Normal)
        leftbutton.addTarget(self, action: #selector(back), forControlEvents: .TouchUpInside)
        self.navigationItem.leftBarButtonItem=UIBarButtonItem(customView: leftbutton)
        self.navigationItem.rightBarButtonItem=savebutton
        tableView.backgroundColor=UIColor(red: 239.0/255.0, green: 239.0/255.0, blue: 246.0/255.0, alpha: 1)
        //去掉cell下面的黑色线条
        tableView.separatorStyle=UITableViewCellSeparatorStyle.None
        //名称改变通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector:
            #selector(setNameChange), name: "setWaterReplenishName", object: nil)
        //初始化设置数组
        if myCurrentDevice != nil
        {
        settingDic?.setValue(myCurrentDevice?.settings.name, forKey: "deviceName")
        settingDic?.setValue(myCurrentDevice?.settings.get("deviceAttrib", default: "办公室"), forKey: "deviceAttrib")
        settingDic?.setValue(myCurrentDevice?.settings.get("checktime1", default: 30600), forKey: "checktime1")
        settingDic?.setValue(myCurrentDevice?.settings.get("checktime2", default: 52200), forKey: "checktime2")
        settingDic?.setValue(myCurrentDevice?.settings.get("checktime3", default: 75600), forKey: "checktime3")
        settingDic?.setValue(myCurrentDevice?.settings.get("sex", default: "女"), forKey: "sex")
        }
    }
    //修改设备名称通知
    func setNameChange(text:NSNotification){
        settingDic!.setValue(text.userInfo!["name"], forKey: "deviceName")
        settingDic!.setValue(text.userInfo!["attr"], forKey: "deviceAttrib")
        var tmpstring=(text.userInfo!["name"] as! String)+"("
        tmpstring+=(text.userInfo!["attr"] as! String)+")"
        MainViewCell.NameAndAdress.text=tmpstring
        
    }
    //返回
    func back(){
        let alert=UIAlertView(title: "", message: "是否保存？", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "保存")
        alert.show()
    }
    //保存
    func SaveClick()
    {
        if myCurrentDevice==nil
        {
            self.navigationController?.popViewControllerAnimated(true)
            return
        }
        //airMx.settings.name=(plistData.objectForKey("deviceName") as! String)+"("+(plistData.objectForKey("deviceAttrib") as! String)+")"
        myCurrentDevice?.settings.name=settingDic?.objectForKey("deviceName") as! String
        print(settingDic?.objectForKey("deviceAttrib"))
        myCurrentDevice?.settings.setValue(settingDic?.objectForKey("deviceAttrib"), forKey: "deviceAttrib")
        myCurrentDevice?.settings.setValue(settingDic?.objectForKey("checktime1"), forKey: "checktime1")
        myCurrentDevice?.settings.setValue(settingDic?.objectForKey("checktime2"), forKey: "checktime2")
        myCurrentDevice?.settings.setValue(settingDic?.objectForKey("checktime3"), forKey: "checktime3")
        myCurrentDevice?.settings.setValue(settingDic?.objectForKey("sex"), forKey: "sex")
        OznerManager.instance().save(myCurrentDevice)
        NSNotificationCenter.defaultCenter().postNotificationName("updateDeviceInfo", object: nil)
        self.navigationController?.popViewControllerAnimated(true)
    }
    //alert 点击事件
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if alertView.message=="是否保存？"
        {
            if buttonIndex==0
            {
                self.navigationController?.popViewControllerAnimated(true)
            }
            else
            {
                SaveClick()
            }
        }
        if alertView.message=="删除此设备"
        {
            if buttonIndex==1
            {
                //删除
                ClearClick_OK()
            }
        }
    }
    func ClearClick_OK()
    {

        print("－－－－－－删除前－－－－－－")
        print(OznerManager.instance().getDevices().count)
        OznerManager.instance().remove(myCurrentDevice)
        print("－－－－－－删除后－－－－－－")
        print(OznerManager.instance().getDevices().count)
        //发出通知
        NSNotificationCenter.defaultCenter().postNotificationName("removDeviceByZB", object: nil)
        self.navigationController?.popViewControllerAnimated(true)
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(named: "bg_clear_gray"), forBarMetrics: UIBarMetrics.Default)
        self.navigationController!.navigationBar.shadowImage =  UIImage(named: "bg_clear_black")
        self.navigationController?.navigationBarHidden=false
        CustomTabBarView.sharedCustomTabBar().hideOverTabBar()
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
        return 1
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 602
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        MainViewCell = NSBundle.mainBundle().loadNibNamed("mainOfSetWaterReplenCell", owner: self, options: nil).last as! mainOfSetWaterReplenCell
        MainViewCell.toSetNameAndDressButton.addTarget(self, action: #selector(toSetNameAndDressButton), forControlEvents: .TouchUpInside)
        MainViewCell.toSetSexButton.addTarget(self, action: #selector(toSetSexButton), forControlEvents: .TouchUpInside)
        MainViewCell.toSetTimeRemind.addTarget(self, action: #selector(toSetTimeRemind), forControlEvents: .TouchUpInside)
        MainViewCell.toBugEssence.addTarget(self, action: #selector(toBugEssence), forControlEvents: .TouchUpInside)
        MainViewCell.toInstructions.addTarget(self, action: #selector(toInstructions), forControlEvents: .TouchUpInside)
        MainViewCell.toOperation.addTarget(self, action: #selector(toOperation), forControlEvents: .TouchUpInside)
        MainViewCell.clearButton.addTarget(self, action: #selector(clearButton), forControlEvents: .TouchUpInside)
        MainViewCell.selectionStyle=UITableViewCellSelectionStyle.None
        //数据初始化
        MainViewCell.NameAndAdress.text=(settingDic?.objectForKey("deviceName") as? String)!+"("+(settingDic?.objectForKey("deviceAttrib") as? String)!+")"
        MainViewCell.Sex.text=settingDic?.objectForKey("sex") as? String
        
        print(settingDic)
        return MainViewCell
    }
    func toSetNameAndDressButton()
    {
        let setnamecontroller=setDeviceNameViewController(nibName: "setDeviceNameViewController", bundle: nil)
        setnamecontroller.dataPlist=settingDic
        self.navigationController?.pushViewController(setnamecontroller, animated: true)
    }
    func toSetSexButton()
    {
        let setSexController=SetSexViewController(nibName: "SetSexViewController", bundle: nil)
        setSexController.tmpSex=settingDic?.objectForKey("sex") as? String
        print(settingDic?.objectForKey("sex"))
        setSexController.backClosure={ (inputText:String) -> Void in
            self.MainViewCell.Sex.text=inputText
            self.settingDic?.setValue(inputText, forKey: "sex")
        }
        self.navigationController?.pushViewController(setSexController, animated: true)
    }
    func toSetTimeRemind()
    {
        let setTimeController=SetRemindTimeController(nibName: "SetRemindTimeController", bundle: nil)
        setTimeController.dicData=settingDic
        setTimeController.backClosure={ (BackData:NSMutableDictionary) -> Void in
            self.settingDic=BackData
        }
        self.navigationController?.pushViewController(setTimeController, animated: true)
    }
    func toBugEssence()
    {
    }
    func toInstructions()
    {
        let weiXinUrl=weiXinUrlNamezb()
        let tmpURLController=WeiXinURLViewController(nibName: "WeiXinURLViewController", bundle: nil)
        tmpURLController.title=weiXinUrl.WaterReplenishOperation
        self.presentViewController(tmpURLController, animated: true, completion: nil)
        
    }
    func toOperation()
    {
    }
    func clearButton()
    {
        let alert=UIAlertView(title: "", message: "删除此设备", delegate: self, cancelButtonTitle: "否", otherButtonTitles: "是")
        alert.show()
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
