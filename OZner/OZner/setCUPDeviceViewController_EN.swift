//
//  setCUPDeviceViewController_EN.swift
//  OZner
//
//  Created by test on 15/12/9.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

import UIKit

class setCUPDeviceViewController_EN: UIViewController,UIPickerViewDelegate,UIAlertViewDelegate{

    var colorWheel:YJHColorPickerHSWheel!
    var colorWheel2:YJHColorPickerHSWheel2!
    var myCurrentDevice:OznerDevice?
    var _colorCenterView:UIView!
    //let colorWheel = YJHColorPickerHSWheel2(frame: CGRectMake(40, 15, 224, 224))
    //var timeSpacePKView:UIPickerView!
    var grayview:UIView!
    var mainView:setDev_CupView_EN!
    var dataPicker:NSMutableDictionary=NSMutableDictionary(capacity: 5)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title=loadLanguage("智能杯")
        let ScrollView=UIScrollView(frame: CGRect(x: 0, y: 0, width: Screen_Width, height: Screen_Hight))
        ScrollView.backgroundColor=UIColor(red: 238/255, green: 239/255, blue: 240/255, alpha: 1)
    mainView=Bundle.main.loadNibNamed("setDev_CupView_EN", owner: nil, options: nil)?.last as! setDev_CupView_EN
        mainView.frame=CGRect(x: 0, y: 0, width: Screen_Width, height: mainView.bounds.size.height)
        //加载数据
        mainView.myCurrentDevice=self.myCurrentDevice
        mainView.initload()
        
        mainView.AboutCupbutton.addTarget(self, action: #selector(ToAboutCup), for: .touchUpInside)
        mainView.CupNamebutton.addTarget(self, action: #selector(ToSetCupName), for: .touchUpInside)
        mainView.setCupTime.addTarget(self, action: #selector(ToSetCupTime), for: .touchUpInside)
        mainView.aetCuptimeSpace.addTarget(self, action: #selector(SetCupTimeSpace), for: .touchUpInside)
        ScrollView.contentSize=CGSize(width: 0, height: mainView.bounds.size.height)
        ScrollView.addSubview(mainView)
        self.view.addSubview(ScrollView)
        let savebutton=UIBarButtonItem(title:loadLanguage("保存") , style: .plain, target: self, action: #selector(SaveClick))
        let leftbutton=UIButton(frame: CGRect(x: 0, y: 0, width: 10, height: 21))
        leftbutton.setBackgroundImage(UIImage(named: "fanhui"), for: UIControlState())
        leftbutton.addTarget(self, action: #selector(back), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem=UIBarButtonItem(customView: leftbutton)
        self.navigationItem.rightBarButtonItem=savebutton
        //pickerview
        grayview=UIView(frame: CGRect(x: 0, y: 0, width: Screen_Width, height: Screen_Hight-64))
        grayview.backgroundColor=UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        //pickercancel
        let cancelbutton=UIButton(frame: CGRect(x: 0, y: Screen_Hight-230, width: 60, height: 30))
        cancelbutton.setTitle(loadLanguage("取消"), for: UIControlState())
        cancelbutton.addTarget(self, action: #selector(PickerCancel), for: .touchUpInside)
        //cancelbutton.backgroundColor=UIColor.whiteColor()
        grayview.addSubview(cancelbutton)
        //pickerok
        let okbutton=UIButton(frame: CGRect(x: Screen_Width-60, y: Screen_Hight-230, width: 60, height: 30))
        okbutton.setTitle(loadLanguage("确定"), for: UIControlState())
        okbutton.addTarget(self, action: #selector(PickerOK), for: .touchUpInside)
        //okbutton.backgroundColor=UIColor.whiteColor()
        grayview.addSubview(okbutton)
        //picker
        let timeSpacePKView=UIPickerView(frame: CGRect(x: 0, y: Screen_Hight-200, width: Screen_Width, height: 150))
        timeSpacePKView.backgroundColor=UIColor.white
        timeSpacePKView.delegate=self
       
        timeSpacePKView.showsSelectionIndicator=true
        
        grayview.addSubview(timeSpacePKView)
        grayview.isHidden=true
        self.view.addSubview(grayview)

        dataPicker=["0":loadLanguage("15分钟"),"1":loadLanguage("30分钟"),"2":loadLanguage("45分钟"),"3":loadLanguage("1小时"),"4":loadLanguage("2小时")]
        //取色板
        _colorCenterView=UIView(frame: CGRect(x: 80, y: 80, width: 64, height: 64))
        _colorCenterView.backgroundColor=UIColor.white
        _colorCenterView.layer.masksToBounds=true;
        _colorCenterView.layer.cornerRadius=32;
        let wheel2 = YJHColorPickerHSWheel2(frame: CGRect(x: Screen_Width/2-112, y: mainView.getColorBoard.frame.height/2-112, width: 224, height: 224))
        
        self.colorWheel2 = wheel2
        
        wheel2.confirmBlock = {(color) in
            self._colorCenterView.backgroundColor = color

            let components = (color?.cgColor)?.components
            var tmpColor = (components?[0])!*255*256*256
            tmpColor+=(components?[1])!*255*256+(components?[2])!*255
            print(tmpColor)
            setCupStructdata["haloColor"] = tmpColor
            let cup = self.myCurrentDevice as! Cup
            cup.settings.haloColor=(setCupStructdata["haloColor"] as! NSNumber).uint32Value
            OznerManager.instance().save(cup)
            
        }
        wheel2.addSubview(_colorCenterView)
        mainView.getColorBoard.addSubview(wheel2)
        //删除操作
        mainView.ClearButton.addTarget(self, action: #selector(clearDeviceClick), for: .touchUpInside)
        
        //色环颜色初始化
        let tmpCgcolor=setCupStructdata["haloColor"] as! UInt
      
        self._colorCenterView.backgroundColor = UIColorFromRGB(tmpCgcolor)//
    }
    
       //删除设备
    func clearDeviceClick()
    {
        let alert=UIAlertView(title: "", message: loadLanguage("删除此设备"), delegate: self, cancelButtonTitle: loadLanguage("否"), otherButtonTitles: loadLanguage("是"))
        alert.show()
        
    }
    //返回
    func back(){
        let alert=UIAlertView(title: "", message: loadLanguage("是否保存？"), delegate: self, cancelButtonTitle: loadLanguage("取消"), otherButtonTitles: loadLanguage("保存"))
        alert.show()

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
        _=self.navigationController?.popViewController(animated: true)
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
       
        cup.settings.remindInterval=(setCupStructdata["remindInterval"] as! NSNumber).uint32Value
        //提醒开始时间
        cup.settings.remindStart=(setCupStructdata["remindStart"] as! NSNumber).uint32Value
        //提醒结束时间
        cup.settings.remindEnd=(setCupStructdata["remindEnd"] as! NSNumber).uint32Value
        //
        //cup.settings.haloMode=(3).unsignedIntValue
        cup.settings.haloSpeed=144
        cup.settings.haloConter=128
        cup.settings.beepMode=144
        
        //是否提醒
        cup.settings.remindEnable=mainView.cup_voice.isOn
        cup.settings.put("phoneVoice", value: mainView.phone_voice.isOn)
        if mainView.phone_voice.isOn==true
        {
            setPhoneVoice((setCupStructdata["remindStart"] as! NSNumber).uint32Value, endTime: (setCupStructdata["remindEnd"] as! NSNumber).uint32Value, repeatTime: (setCupStructdata["remindInterval"] as! NSNumber).uint32Value)
        }
        else
        {
            cancelPhoneVoice()
        }
        OznerManager.instance().save(cup)
        
    NotificationCenter.default.post(name: Notification.Name(rawValue: "updateDeviceInfo"), object: nil)
        _=self.navigationController?.popViewController(animated: true)
    }
    func ToAboutCup()
    {
        let aboutcup=AboutDeviceViewController_EN(nibName: "AboutDeviceViewController_EN", bundle: nil)
        aboutcup.title=loadLanguage("关于智能杯")
        aboutcup.urlstring="http://cup.ozner.net/app/gyznb/gyznb.html"
        self.navigationController?.pushViewController(aboutcup, animated: true)
    }
    func ToSetCupName()
    {
        let setCupName=setCupNameViewController_EN(nibName: "setCupNameViewController_EN", bundle: nil)
        self.navigationController?.pushViewController(setCupName, animated: true)
    }
    func ToSetCupTime()
    {
        let setCupTime=setCuoTimeViewController_EN(nibName: "setCuoTimeViewController_EN", bundle: nil)
        self.navigationController?.pushViewController(setCupTime, animated: true)
    }
    func SetCupTimeSpace()
    {
        //CustomTabBarView.sharedCustomTabBar().hideOverTabBar()
        grayview.isHidden=false
    }
    //PickerOK
    func PickerCancel()
    {
        //CustomTabBarView.sharedCustomTabBar().showAllMyTabBar()
        grayview.isHidden=true
    }
    //PickerOK
    //
    var currentPicker=0
    func PickerOK()
    {
        //CustomTabBarView.sharedCustomTabBar().showAllMyTabBar()
        grayview.isHidden=true
        if currentPicker != 0
        {
            let tmpstr=(currentPicker/60==0 ? "":"\(currentPicker/60)\(loadLanguage("小时"))")+(currentPicker%60==0 ? "":"\(currentPicker%60)\(loadLanguage("分钟"))")
            mainView.cup_remindspace.text=tmpstr
            setCupStructdata["remindInterval"]=currentPicker
        }
    }
    func numberOfComponentsInPickerView(_ pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //dynamic delegate methods using pickerviewObj.tag
        return dataPicker.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataPicker.object(forKey: "\(row)") as? String
    }
   
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
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
    func setPhoneVoice(_ starTime:uint,endTime:uint,repeatTime:uint)
    {
        if endTime<starTime
        {
            return
        }
        print((endTime-starTime)/repeatTime)
        for i in 0...(endTime-starTime)/repeatTime/60
        {
            let formatter = DateFormatter()
            
            formatter.dateFormat = "HH:mm"
            let tmptime=starTime/60+i*repeatTime
            
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
                
                noti.alertBody = loadLanguage("该喝水了,亲");
                
                //显示在icon上的红色圈中的数子
                
                noti.applicationIconBadgeNumber = 1;
                
                //设置userinfo 方便在之后需要撤销的时候使用
                
                //NSDictionary *infoDic = [NSDictionary dictionaryWithObject:@"name" forKey:@"key"];
                
                //noti.userInfo = infoDic;
                
                //添加推送到uiapplication        
                
                UIApplication.shared.scheduleLocalNotification(noti)
                
            }
        }
        
    }
    func cancelPhoneVoice()
    {
        UIApplication.shared.cancelAllLocalNotifications()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainView.updateData()
        self.navigationController?.isNavigationBarHidden=false
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(named: "bg_clear_gray"), for: UIBarMetrics.default)
        self.navigationController!.navigationBar.shadowImage =  UIImage(named: "bg_clear_black")
        //CustomTabBarView.sharedCustomTabBar().showAllMyTabBar()
    }

}
