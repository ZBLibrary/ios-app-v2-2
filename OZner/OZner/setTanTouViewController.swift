//
//  setTanTouViewController.swift
//  OZner
//
//  Created by test on 15/12/18.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

import UIKit

class setTanTouViewController: UIViewController ,UIAlertViewDelegate{

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?){
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    var plistData:NSMutableDictionary=getPlistData("setTanTou")
    var datePickerView:uiDatePickerView!
    let currentWindow = UIApplication.sharedApplication().keyWindow
    var currentselect = 0
    var myCurrentDevice:OznerDevice?
    @IBOutlet var DeviceName: UILabel!
    @IBAction func setTanTouName(sender: AnyObject) {
       let setnamecontroller=setDeviceNameViewController(nibName: "setDeviceNameViewController", bundle: nil)
        setnamecontroller.dataPlist=plistData
       self.navigationController?.pushViewController(setnamecontroller, animated: true)
    }
    @IBOutlet var checkImage1: UIImageView!
    @IBOutlet var checkLabel1: UILabel!
    @IBOutlet var checkValue1: UILabel!
    @IBAction func checkButton1(sender: AnyObject) {
        checkImage1.hidden=false
        currentselect=0
        currentWindow?.addSubview(datePickerView)
        datePickerView.datePicker.date=curLabelTime(checkValue1.text!)
    }
    @IBOutlet var checkImage2: UIImageView!
    @IBOutlet var checkLabel2: UILabel!
    @IBOutlet var checkValue2: UILabel!
    @IBAction func checkButton2(sender: AnyObject) {
        checkImage2.hidden=false
        currentselect=1
        currentWindow?.addSubview(datePickerView)
        datePickerView.datePicker.date=curLabelTime(checkValue2.text!)
    }
    @IBAction func toAboutDevice(sender: AnyObject) {
        let aboutDevice=AboutDeviceViewController(nibName: "AboutDeviceViewController", bundle: nil)
        aboutDevice.title=loadLanguage("关于水探头")
        aboutDevice.urlstring="http://cup.ozner.net/app/gystt/gystt.html"
        self.navigationController?.pushViewController(aboutDevice, animated: true)
    }
    @IBOutlet var deleteDeviceButton: UIButton!
    @IBAction func deleteDevice(sender: AnyObject) {
        let alert=UIAlertView(title: "", message: "删除此设备", delegate: self, cancelButtonTitle: "否", otherButtonTitles: "是")
        alert.show()
    }
    
    @IBOutlet var DeviceNameLable: UILabel!
    @IBOutlet var checkLable: UILabel!
    @IBOutlet var AccordingLable: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DeviceNameLable.text=loadLanguage("我的水探头")
        checkLable.text=loadLanguage("检测时间")
        checkLabel1.text=loadLanguage("检测时间1")
        checkLabel2.text=loadLanguage("检测时间2")
        AccordingLable.text=loadLanguage("滤芯不足10天会显示提醒")
        deleteDeviceButton.setTitle(loadLanguage("删除此设备"), forState: .Normal)
        
        self.title=loadLanguage("水探头")
        let savebutton=UIBarButtonItem(title: loadLanguage("保存"), style: .Plain, target: self, action: #selector(SaveClick))
        let leftbutton=UIButton(frame: CGRect(x: 0, y: 0, width: 10, height: 21))
        leftbutton.setBackgroundImage(UIImage(named: "fanhui"), forState: .Normal)
        leftbutton.addTarget(self, action: #selector(back), forControlEvents: .TouchUpInside)
        self.navigationItem.leftBarButtonItem=UIBarButtonItem(customView: leftbutton)
        self.navigationItem.rightBarButtonItem=savebutton
        deleteDeviceButton.layer.borderWidth=1
        deleteDeviceButton.layer.borderColor=UIColor(red: 1, green: 92/255, blue: 102/255, alpha: 1).CGColor
        deleteDeviceButton.layer.cornerRadius=20
        deleteDeviceButton.layer.masksToBounds=true
        //loadDeviceData加载设备里面数据
        loadDeviceData()
        DeviceName.text=(plistData.objectForKey("deviceName") as! String)+"("+(plistData.objectForKey("deviceAttrib") as! String)+")"
        var tmp=plistData.objectForKey("checktime1") as! Int
        
        checkValue1.text=(tmp/3600<10 ? "0\(tmp/3600)":"\(tmp/3600)")+":"+(tmp%3600/60<10 ? "0\(tmp%3600/60)":"\(tmp%3600/60)")
        if checkValue1.text=="00:00"
        {
            checkValue1.text="10:00"
        }
        tmp=plistData.objectForKey("checktime2") as! Int
        checkValue2.text=(tmp/3600<10 ? "0\(tmp/3600)":"\(tmp/3600)")+":"+(tmp%3600/60<10 ? "0\(tmp%3600/60)":"\(tmp%3600/60)")
        if checkValue2.text=="00:00"
        {
            checkValue2.text="18:00"
        }
        if checkValue1.text==checkValue2.text
        {
            checkValue1.text="10:00"
            checkValue2.text="18:00"
        }
        //名称改变通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(setNameChange), name: "setTanTouName", object: nil)
        //
        //pickerview
       datePickerView=NSBundle.mainBundle().loadNibNamed("uiDatePickerView", owner: nil, options: nil).last as! uiDatePickerView
        //取消
        datePickerView.frame=CGRect(x: 0, y: 0, width: Screen_Width, height: Screen_Hight)
        datePickerView.cancelButton.addTarget(self, action: #selector(PickerCancel), forControlEvents: .TouchUpInside)
        //确定
        datePickerView.OKButton.addTarget(self, action: #selector(PickerOK), forControlEvents: .TouchUpInside)
        
        // Do any additional setup after loading the view.
    }

    //加载设备里面数据
    func loadDeviceData()
    {
        let tap = self.myCurrentDevice as! Tap
        //名称体重饮水量
        var nameStr=tap.settings.name
        if nameStr.characters.contains("(")==false
        {
            nameStr=nameStr+"(厨房)"
        }
        plistData.setValue(nameStr.substringToIndex(nameStr.characters.indexOf("(")!) as String, forKey: "deviceName")
        let tmpname=plistData.objectForKey("deviceName") as! String
        let nameStr2=(nameStr as NSString).substringWithRange(NSMakeRange(tmpname.characters.count+1, nameStr.characters.count-tmpname.characters.count-2))
        plistData.setValue(nameStr2, forKey: "deviceAttrib")

        print(tap.settings.DetectTime1)
        print(tap.settings.DetectTime2)
        plistData.setValue(tap.settings.DetectTime1, forKey: "checktime1")
        plistData.setValue(tap.settings.DetectTime2, forKey: "checktime2")

    }
    //自定义方法
    //设置时间
    func curLabelTime(timeStr:String)->NSDate
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat="YYYY-MM-DD"
        var nowStr=dateFormatter.stringFromDate(NSDate())
        nowStr=nowStr+" "+timeStr+":00"
        dateFormatter.dateFormat="YYYY-MM-DD hh:mm:ss"
        let tmpDate=dateFormatter.dateFromString(nowStr)! as NSDate
        print(tmpDate)
        
        return tmpDate
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
    //PickerCancel
    func PickerCancel()
    {
        checkImage1.hidden=true
        checkImage2.hidden=true
        datePickerView.removeFromSuperview()
    }
    //PickerOK
    func PickerOK()
    {
        checkImage1.hidden=true
        checkImage2.hidden=true
        let select = datePickerView.datePicker.date
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let dateAndTime =  dateFormatter.stringFromDate(select)
        if currentselect==0
        {
            checkValue1.text=dateAndTime
            let tmpstring=dateAndTime as NSString
          plistData.setValue((Int(tmpstring.substringToIndex(2))!*3600+Int(tmpstring.substringFromIndex(3))!*60), forKey: "checktime1")
            
        }
        else
        {
            checkValue2.text=dateAndTime
            let tmpstring=dateAndTime as NSString
            plistData.setValue((Int(tmpstring.substringToIndex(2))!*3600+Int(tmpstring.substringFromIndex(3))!*60), forKey: "checktime2")
        }
        datePickerView.removeFromSuperview()
    }
    //设置名字属性完成后传值痒
    func setNameChange(text:NSNotification){
        plistData.setValue(text.userInfo!["name"], forKey: "deviceName")
        plistData.setValue(text.userInfo!["attr"], forKey: "deviceAttrib")
        var tmpstring=(text.userInfo!["name"] as! String)+"("
        tmpstring+=(text.userInfo!["attr"] as! String)+")"
        DeviceName.text=tmpstring
        
    }
    
    func SaveClick(){
        //写入本地
        setPlistData(plistData, fileName: "setTanTou")
        //写入设备
        let tap = self.myCurrentDevice as! Tap
        tap.settings.name=plistData.objectForKey("deviceName") as! String
        tap.settings.isDetectTime1=true
        tap.settings.isDetectTime2=true
        tap.settings.DetectTime1=plistData.objectForKey("checktime1") as! NSTimeInterval
        tap.settings.DetectTime2=plistData.objectForKey("checktime2") as!
        NSTimeInterval
        
        OznerManager.instance().save(tap)
        print(tap.settings.name)
        print(tap.settings.DetectTime1)
        print(tap.settings.DetectTime2)
        print(tap.settings.isDetectTime1)
        print(tap.settings.isDetectTime2)
        NSNotificationCenter.defaultCenter().postNotificationName("updateDeviceInfo", object: nil)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //系统自带
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden=false
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(named: "bg_clear_gray"), forBarMetrics: UIBarMetrics.Default)
        self.navigationController!.navigationBar.shadowImage =  UIImage(named: "bg_clear_black")
        CustomTabBarView.sharedCustomTabBar().hideOverTabBar()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
