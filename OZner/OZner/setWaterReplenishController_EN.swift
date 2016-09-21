//
//  setWaterReplenishController_EN.swift
//  OZner
//
//  Created by 赵兵 on 16/3/7.
//  Copyright © 2016年 sunlinlin. All rights reserved.
//

import UIKit

class setWaterReplenishController_EN: UITableViewController,UIAlertViewDelegate {
    
    
    var settingDic:NSMutableDictionary?=getPlistData("setWaterReplenish_EN")
    var myCurrentDevice:WaterReplenishmentMeter?
    var MainViewCell:mainOfSetWaterReplenCell_EN!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title=loadLanguage("智能补水仪")
        let savebutton=UIBarButtonItem(title: loadLanguage("保存"), style: .plain, target: self, action: #selector(SaveClick))
        let leftbutton=UIButton(frame: CGRect(x: 0, y: 0, width: 10, height: 21))
        leftbutton.setBackgroundImage(UIImage(named: "fanhui"), for: UIControlState())
        leftbutton.addTarget(self, action: #selector(back), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem=UIBarButtonItem(customView: leftbutton)
        self.navigationItem.rightBarButtonItem=savebutton
        tableView.backgroundColor=UIColor(red: 239.0/255.0, green: 239.0/255.0, blue: 246.0/255.0, alpha: 1)
        //去掉cell下面的黑色线条
        tableView.separatorStyle=UITableViewCellSeparatorStyle.none
        //名称改变通知
        NotificationCenter.default.addObserver(self, selector:
            #selector(setNameChange), name: NSNotification.Name(rawValue: "setWaterReplenishName"), object: nil)
        //初始化设置数组
        if myCurrentDevice != nil
        {
        settingDic?.setValue(myCurrentDevice?.settings.name, forKey: "deviceName")
        settingDic?.setValue(myCurrentDevice?.settings.get("deviceAttrib", default: loadLanguage("办公室")), forKey: "deviceAttrib")
        settingDic?.setValue(myCurrentDevice?.settings.get("checktime1", default: 30600), forKey: "checktime1")
        settingDic?.setValue(myCurrentDevice?.settings.get("checktime2", default: 52200), forKey: "checktime2")
        settingDic?.setValue(myCurrentDevice?.settings.get("checktime3", default: 75600), forKey: "checktime3")
        settingDic?.setValue(myCurrentDevice?.settings.get("sex", default: loadLanguage("女")), forKey: "sex")
            
        }
    }
    //修改设备名称通知
    func setNameChange(_ text:Notification){
        settingDic!.setValue((text as NSNotification).userInfo!["name"], forKey: "deviceName")
        settingDic!.setValue((text as NSNotification).userInfo!["attr"], forKey: "deviceAttrib")
        var tmpstring=((text as NSNotification).userInfo!["name"] as! String)+"("
        tmpstring+=((text as NSNotification).userInfo!["attr"] as! String)+")"
        MainViewCell.NameAndAdress.text=tmpstring
        
    }
    //返回
    func back(){
        let alert=UIAlertView(title: "", message: loadLanguage("是否保存？"), delegate: self, cancelButtonTitle: loadLanguage("取消"), otherButtonTitles: loadLanguage("保存"))
        alert.show()
    }
    //保存
    func SaveClick()
    {
        if myCurrentDevice==nil
        {
            _ = navigationController?.popViewController(animated: true)
            return
        }

       myCurrentDevice?.settings.name=settingDic?.object(forKey: "deviceName") as! String
        myCurrentDevice?.settings.put("deviceAttrib", value: settingDic?.object(forKey: "deviceAttrib"))
        myCurrentDevice?.settings.put("checktime1", value: settingDic?.object(forKey: "checktime1"))
        myCurrentDevice?.settings.put("checktime2", value: settingDic?.object(forKey: "checktime2"))
        myCurrentDevice?.settings.put("checktime3", value: settingDic?.object(forKey: "checktime3"))
        myCurrentDevice?.settings.put("sex", value: settingDic?.object(forKey: "sex"))
        OznerManager.instance().save(myCurrentDevice)
        //设置手机补水提醒通知
        setPhoneVoice([(settingDic?.object(forKey: "checktime1"))!, (settingDic?.object(forKey: "checktime2"))!,(settingDic?.object(forKey: "checktime3"))!])
        NotificationCenter.default.post(name: Notification.Name(rawValue: "updateDeviceInfo"), object: nil)
        _ = navigationController?.popViewController(animated: true)
    }
    
    func setPhoneVoice(_ checkTime:NSArray)
    {
   
        for itemTime in checkTime
        {
            let tmpCheckTime = (itemTime as! NSNumber).uint32Value
            
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            let tmptime=tmpCheckTime/60
            var timeStr=(tmptime/60<10 ? "0\(tmptime/60)":"\(tmptime/60)")
            timeStr+=(":"+(tmptime%60<10 ? "0\(tmptime%60)":"\(tmptime%60)"))
            let date = formatter.date(from: timeStr) //触发通知的时间
            let noti = UILocalNotification()
            if (noti.isKind(of: NSNull.self)==false)
            {
                //设置推送时间
                
                noti.fireDate = date//=now
                //设置时区
                //noti.timeZone = TimeZone.local
                //设置重复间隔
                noti.repeatInterval = NSCalendar.Unit.day
                //推送声音
                noti.soundName = UILocalNotificationDefaultSoundName
                //内容
                noti.alertBody = loadLanguage("该补水了,亲");
                //显示在icon上的红色圈中的数子
                noti.applicationIconBadgeNumber = 1;
                UIApplication.shared.scheduleLocalNotification(noti)
            }
        }
        
    }
    func cancelPhoneVoice()
    {
        UIApplication.shared.cancelAllLocalNotifications()
    }
    //alert 点击事件
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if alertView.message==loadLanguage("是否保存？")
        {
            if buttonIndex==0
            {
                _ = navigationController?.popViewController(animated: true)
            }
            else
            {
                SaveClick()
            }
        }
        if alertView.message==loadLanguage("删除此设备")
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
        NotificationCenter.default.post(name: Notification.Name(rawValue: "removDeviceByZB"), object: nil)
        _ = navigationController?.popViewController(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(named: "bg_clear_gray"), for: UIBarMetrics.default)
        self.navigationController!.navigationBar.shadowImage =  UIImage(named: "bg_clear_black")
        self.navigationController?.isNavigationBarHidden=false
        (CustomTabBarView.sharedCustomTabBar() as AnyObject).hideOverTabBar()
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
        return 1
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 602
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        MainViewCell = Bundle.main.loadNibNamed("mainOfSetWaterReplenCell_EN", owner: self, options: nil)?.last as! mainOfSetWaterReplenCell_EN
        MainViewCell.toSetNameAndDressButton.addTarget(self, action: #selector(toSetNameAndDressButton), for: .touchUpInside)
        MainViewCell.toSetSexButton.addTarget(self, action: #selector(toSetSexButton), for: .touchUpInside)
        MainViewCell.toSetTimeRemind.addTarget(self, action: #selector(toSetTimeRemind), for: .touchUpInside)
        MainViewCell.toBugEssence.addTarget(self, action: #selector(toBugEssence), for: .touchUpInside)
        MainViewCell.toInstructions.addTarget(self, action: #selector(toInstructions), for: .touchUpInside)
        MainViewCell.toOperation.addTarget(self, action: #selector(toOperation), for: .touchUpInside)
        MainViewCell.clearButton.addTarget(self, action: #selector(clearButton), for: .touchUpInside)
        MainViewCell.selectionStyle=UITableViewCellSelectionStyle.none
        //数据初始化
        MainViewCell.NameAndAdress.text=(settingDic?.object(forKey: "deviceName") as? String)!+"("+(settingDic?.object(forKey: "deviceAttrib") as? String)!+")"
        MainViewCell.Sex.text=settingDic?.object(forKey: "sex") as? String

        return MainViewCell
    }
    func toSetNameAndDressButton()
    {
        let setnamecontroller=setDeviceNameViewController_EN(nibName: "setDeviceNameViewController_EN", bundle: nil)
        setnamecontroller.dataPlist=settingDic
        self.navigationController?.pushViewController(setnamecontroller, animated: true)
    }
    func toSetSexButton()
    {
        let setSexController=SetSexViewController_EN(nibName: "SetSexViewController_EN", bundle: nil)
        setSexController.tmpSex=settingDic?.object(forKey: "sex") as? String
        print(settingDic?.object(forKey: "sex"))
        setSexController.backClosure={ (inputText:String) -> Void in
            self.MainViewCell.Sex.text=inputText
            self.settingDic?.setValue(inputText, forKey: "sex")
        }
        self.navigationController?.pushViewController(setSexController, animated: true)
    }
    func toSetTimeRemind()
    {
        let setTimeController=SetRemindTimeController_EN(nibName: "SetRemindTimeController_EN", bundle: nil)
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
        let tmpURLController=WeiXinURLViewController_EN(nibName: "WeiXinURLViewController_EN", bundle: nil)
        tmpURLController.title=weiXinUrl.WaterReplenishOperation
        self.present(tmpURLController, animated: true, completion: nil)
        
    }
    func toOperation()
    {
    }
    func clearButton()
    {
        let alert=UIAlertView(title: "", message: loadLanguage("删除此设备"), delegate: self, cancelButtonTitle: loadLanguage("否"), otherButtonTitles: loadLanguage("是"))
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
