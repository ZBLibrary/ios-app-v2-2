//
//  setCUPDeviceViewController.swift
//  OZner
//
//  Created by test on 15/12/9.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

import UIKit

class setCUPDeviceViewController: UIViewController,UIPickerViewDelegate,UIAlertViewDelegate{

    var colorWheel:YJHColorPickerHSWheel!
    var colorWheel2:YJHColorPickerHSWheel2!
    var myCurrentDevice:OznerDevice?
    var _colorCenterView:UIView!
    //let colorWheel = YJHColorPickerHSWheel2(frame: CGRectMake(40, 15, 224, 224))
    //var timeSpacePKView:UIPickerView!
    var grayview:UIView!
    var mainView:setDev_CupView!
    var dataPicker:NSMutableDictionary=NSMutableDictionary(capacity: 5)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title=loadLanguage("智能杯")
        let ScrollView=UIScrollView(frame: CGRect(x: 0, y: 0, width: Screen_Width, height: Screen_Hight-65))
        ScrollView.backgroundColor=UIColor(red: 238/255, green: 239/255, blue: 240/255, alpha: 1)
    mainView=NSBundle.mainBundle().loadNibNamed("setDev_CupView", owner: nil, options: nil).last as! setDev_CupView
        mainView.frame=CGRect(x: 0, y: 0, width: Screen_Width, height: mainView.bounds.size.height)
        //加载数据
        mainView.myCurrentDevice=self.myCurrentDevice
        mainView.initload()
        
        mainView.AboutCupbutton.addTarget(self, action: #selector(ToAboutCup), forControlEvents: .TouchUpInside)
        mainView.CupNamebutton.addTarget(self, action: #selector(ToSetCupName), forControlEvents: .TouchUpInside)
        mainView.setCupTime.addTarget(self, action: #selector(ToSetCupTime), forControlEvents: .TouchUpInside)
        mainView.aetCuptimeSpace.addTarget(self, action: #selector(SetCupTimeSpace), forControlEvents: .TouchUpInside)
        ScrollView.contentSize=CGSize(width: 0, height: mainView.bounds.size.height)
        ScrollView.addSubview(mainView)
        self.view.addSubview(ScrollView)
        let savebutton=UIBarButtonItem(title:loadLanguage("保存") , style: .Plain, target: self, action: #selector(SaveClick))
        let leftbutton=UIButton(frame: CGRect(x: 0, y: 0, width: 10, height: 21))
        leftbutton.setBackgroundImage(UIImage(named: "fanhui"), forState: .Normal)
        leftbutton.addTarget(self, action: #selector(back), forControlEvents: .TouchUpInside)
        self.navigationItem.leftBarButtonItem=UIBarButtonItem(customView: leftbutton)
        self.navigationItem.rightBarButtonItem=savebutton
        //pickerview
        grayview=UIView(frame: CGRect(x: 0, y: 0, width: Screen_Width, height: Screen_Hight-64))
        grayview.backgroundColor=UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        //pickercancel
        let cancelbutton=UIButton(frame: CGRect(x: 0, y: Screen_Hight-230, width: 60, height: 30))
        cancelbutton.setTitle(loadLanguage("取消"), forState: .Normal)
        cancelbutton.addTarget(self, action: #selector(PickerCancel), forControlEvents: .TouchUpInside)
        //cancelbutton.backgroundColor=UIColor.whiteColor()
        grayview.addSubview(cancelbutton)
        //pickerok
        let okbutton=UIButton(frame: CGRect(x: Screen_Width-60, y: Screen_Hight-230, width: 60, height: 30))
        okbutton.setTitle(loadLanguage("确定"), forState: .Normal)
        okbutton.addTarget(self, action: #selector(PickerOK), forControlEvents: .TouchUpInside)
        //okbutton.backgroundColor=UIColor.whiteColor()
        grayview.addSubview(okbutton)
        //picker
        let timeSpacePKView=UIPickerView(frame: CGRect(x: 0, y: Screen_Hight-200, width: Screen_Width, height: 150))
        timeSpacePKView.backgroundColor=UIColor.whiteColor()
        timeSpacePKView.delegate=self
       
        timeSpacePKView.showsSelectionIndicator=true
        
        grayview.addSubview(timeSpacePKView)
        grayview.hidden=true
        self.view.addSubview(grayview)

        dataPicker=["0":"15分钟","1":"30分钟","2":"45分钟","3":"1小时","4":"2小时"]
        //取色板
        _colorCenterView=UIView(frame: CGRectMake(80, 80, 64, 64))
        _colorCenterView.backgroundColor=UIColor.whiteColor()
        _colorCenterView.layer.masksToBounds=true;
        _colorCenterView.layer.cornerRadius=32;
        let wheel2 = YJHColorPickerHSWheel2(frame: CGRectMake(Screen_Width/2-112, mainView.getColorBoard.frame.height/2-112, 224, 224))
        
        self.colorWheel2 = wheel2
        
        wheel2.confirmBlock = {(color:UIColor!) in
            self._colorCenterView.backgroundColor = color

            let components = CGColorGetComponents(color.CGColor)
            var tmpColor = components[0]*255*256*256
            tmpColor+=components[1]*255*256+components[2]*255
            print(tmpColor)
            setCupStructdata["haloColor"] = tmpColor
            let cup = self.myCurrentDevice as! Cup
            cup.settings.haloColor=(setCupStructdata["haloColor"] as! NSNumber).unsignedIntValue
            OznerManager.instance().save(cup)
            
        }
        wheel2.addSubview(_colorCenterView)
        mainView.getColorBoard.addSubview(wheel2)
        //删除操作
        mainView.ClearButton.addTarget(self, action: #selector(clearDeviceClick), forControlEvents: .TouchUpInside)
        
        //色环颜色初始化
        let tmpCgcolor=setCupStructdata["haloColor"] as! UInt
      
        self._colorCenterView.backgroundColor = UIColorFromRGB(tmpCgcolor)//
    }
    
       //删除设备
    func clearDeviceClick()
    {
        let alert=UIAlertView(title: "", message: "删除此设备", delegate: self, cancelButtonTitle: "否", otherButtonTitles: "是")
        alert.show()
        
    }
    //返回
    func back(){
        let alert=UIAlertView(title: "", message: "是否保存？", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "保存")
        alert.show()

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
    //ToSetCupName
    func SaveClick(){
        
        
        setCupStructdata["my_weight"]=mainView.my_weight.text! as String
        setCupStructdata["my_drinkwater"]=mainView.my_drinkwater.text! as String
        
        mainView.SaveData()
        //写入设备
        let cup = self.myCurrentDevice as! Cup
        //名称体重饮水量
        cup.settings.name=mainView.cup_name.text
        cup.settings.put("weight", value: mainView.my_weight.text! as String)
        cup.settings.put("my_drinkwater", value: mainView.my_drinkwater.text! as String)
        //今日状态
        cup.settings.put("todayState1", value: setCupStructdata["my_state1"])
        cup.settings.put("todayState2", value: setCupStructdata["my_state2"])
        cup.settings.put("todayState3", value: setCupStructdata["my_state3"])
        cup.settings.put("todayState4", value: setCupStructdata["my_state4"])
        //灯带颜色
        //cup.settings.haloColor=(setCupStructdata["haloColor"] as! NSNumber).unsignedIntValue
        //提醒时间间隔
       
        cup.settings.remindInterval=(setCupStructdata["remindInterval"] as! NSNumber).unsignedIntValue
        //提醒开始时间
        cup.settings.remindStart=(setCupStructdata["remindStart"] as! NSNumber).unsignedIntValue
        //提醒结束时间
        cup.settings.remindEnd=(setCupStructdata["remindEnd"] as! NSNumber).unsignedIntValue
        //
        //cup.settings.haloMode=(3).unsignedIntValue
        cup.settings.haloSpeed=(144).unsignedIntValue
        cup.settings.haloConter=(128).unsignedIntValue
        cup.settings.beepMode=(144).unsignedIntValue
        
        //是否提醒
        cup.settings.remindEnable=mainView.cup_voice.on
        cup.settings.put("phoneVoice", value: mainView.phone_voice.on)
        if mainView.phone_voice.on==true
        {
            setPhoneVoice((setCupStructdata["remindStart"] as! NSNumber).unsignedIntValue, endTime: (setCupStructdata["remindEnd"] as! NSNumber).unsignedIntValue, repeatTime: (setCupStructdata["remindInterval"] as! NSNumber).unsignedIntValue)
        }
        else
        {
            cancelPhoneVoice()
        }
        OznerManager.instance().save(cup)
        
    NSNotificationCenter.defaultCenter().postNotificationName("updateDeviceInfo", object: nil)
        self.navigationController?.popViewControllerAnimated(true)
    }
    func ToAboutCup()
    {
        let aboutcup=AboutDeviceViewController(nibName: "AboutDeviceViewController", bundle: nil)
        aboutcup.title=loadLanguage("关于智能杯")
        aboutcup.urlstring="http://cup.ozner.net/app/gyznb/gyznb.html"
        self.navigationController?.pushViewController(aboutcup, animated: true)
    }
    func ToSetCupName()
    {
        let setCupName=setCupNameViewController(nibName: "setCupNameViewController", bundle: nil)
        self.navigationController?.pushViewController(setCupName, animated: true)
    }
    func ToSetCupTime()
    {
        let setCupTime=setCuoTimeViewController(nibName: "setCuoTimeViewController", bundle: nil)
        self.navigationController?.pushViewController(setCupTime, animated: true)
    }
    func SetCupTimeSpace()
    {
        CustomTabBarView.sharedCustomTabBar().hideOverTabBar()
        grayview.hidden=false
    }
    //PickerOK
    func PickerCancel()
    {
        CustomTabBarView.sharedCustomTabBar().showAllMyTabBar()
        grayview.hidden=true
    }
    //PickerOK
    //
    var currentPicker=0
    func PickerOK()
    {
        CustomTabBarView.sharedCustomTabBar().showAllMyTabBar()
        grayview.hidden=true
        if currentPicker != 0
        {
            let tmpstr=(currentPicker/60==0 ? "":"\(currentPicker/60)小时")+(currentPicker%60==0 ? "":"\(currentPicker%60)分钟")
            mainView.cup_remindspace.text=tmpstr
            setCupStructdata["remindInterval"]=currentPicker
        }
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //dynamic delegate methods using pickerviewObj.tag
        return dataPicker.count
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataPicker.objectForKey("\(row)") as? String
    }
   
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch row
        {
        case 0:
            currentPicker=15
            break
        case 1:
            currentPicker=30
            break
        case 2:
            currentPicker=45
            break
        case 3:
            currentPicker=60
            break
        case 4:
            currentPicker=120
            break
        default:
            currentPicker=15
            break
        }
 
    }
    func setPhoneVoice(starTime:uint,endTime:uint,repeatTime:uint)
    {
        if endTime<starTime
        {
            return
        }
        print((endTime-starTime)/repeatTime)
        for i in 0...(endTime-starTime)/repeatTime/60
        {
            let formatter = NSDateFormatter()
            
            formatter.dateFormat = "HH:mm"
            let tmptime=starTime/60+i*repeatTime
            
            var timeStr=(tmptime/60<10 ? "0\(tmptime/60)":"\(tmptime/60)")
            timeStr+=(":"+(tmptime%60<10 ? "0\(tmptime%60)":"\(tmptime%60)"))
            
            let date = formatter.dateFromString(timeStr) //触发通知的时间
            let noti = UILocalNotification()
            if (noti.isKindOfClass(NSNull)==false)
            {
                //设置推送时间
                
                noti.fireDate = date//=now
                
                //设置时区
                
                noti.timeZone = NSTimeZone.defaultTimeZone()
                
                //设置重复间隔
                
                noti.repeatInterval = NSCalendarUnit.Day
                
                //推送声音
                
                noti.soundName = UILocalNotificationDefaultSoundName
                
                //内容
                
                noti.alertBody = "该喝水了,亲";
                
                //显示在icon上的红色圈中的数子
                
                noti.applicationIconBadgeNumber = 1;
                
                //设置userinfo 方便在之后需要撤销的时候使用
                
                //NSDictionary *infoDic = [NSDictionary dictionaryWithObject:@"name" forKey:@"key"];
                
                //noti.userInfo = infoDic;
                
                //添加推送到uiapplication        
                
                UIApplication.sharedApplication().scheduleLocalNotification(noti)
                
            }
        }
        
    }
    func cancelPhoneVoice()
    {
        UIApplication.sharedApplication().cancelAllLocalNotifications()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        mainView.updateData()
        self.navigationController?.navigationBarHidden=false
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(named: "bg_clear_gray"), forBarMetrics: UIBarMetrics.Default)
        self.navigationController!.navigationBar.shadowImage =  UIImage(named: "bg_clear_black")
        CustomTabBarView.sharedCustomTabBar().showAllMyTabBar()
    }

}
