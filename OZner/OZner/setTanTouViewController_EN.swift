//
//  setTanTouViewController_EN.swift
//  OZner
//
//  Created by test on 15/12/18.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

import UIKit

class setTanTouViewController_EN: UIViewController ,UIAlertViewDelegate{

    @IBOutlet weak var aboutContainer: UIView!
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    var plistData:NSMutableDictionary=getPlistData("setTanTou_EN")
    var datePickerView:uiDatePickerView_EN!
    let currentWindow = UIApplication.shared.keyWindow
    var currentselect = 0
    var myCurrentDevice:OznerDevice?
    @IBOutlet var DeviceName: UILabel!
    @IBAction func setTanTouName(_ sender: AnyObject) {
       let setnamecontroller=setDeviceNameViewController_EN(nibName: "setDeviceNameViewController_EN", bundle: nil)
        setnamecontroller.dataPlist=plistData
       self.navigationController?.pushViewController(setnamecontroller, animated: true)
    }
    @IBOutlet var checkImage1: UIImageView!
    @IBOutlet var checkLabel1: UILabel!
    @IBOutlet var checkValue1: UILabel!
    @IBAction func checkButton1(_ sender: AnyObject) {
        checkImage1.isHidden=false
        currentselect=0
        currentWindow?.addSubview(datePickerView)
        datePickerView.datePicker.date=curLabelTime(checkValue1.text!)
    }
    @IBOutlet var checkImage2: UIImageView!
    @IBOutlet var checkLabel2: UILabel!
    @IBOutlet var checkValue2: UILabel!
    @IBAction func checkButton2(_ sender: AnyObject) {
        checkImage2.isHidden=false
        currentselect=1
        currentWindow?.addSubview(datePickerView)
        datePickerView.datePicker.date=curLabelTime(checkValue2.text!)
    }
    @IBAction func toAboutDevice(_ sender: AnyObject) {
        let aboutDevice=AboutDeviceViewController_EN(nibName: "AboutDeviceViewController_EN", bundle: nil)
        aboutDevice.title=loadLanguage("关于水探头")
        aboutDevice.urlstring="http://cup.ozner.net/app/gystt/gystt.html"
        self.navigationController?.pushViewController(aboutDevice, animated: true)
    }
    @IBOutlet var deleteDeviceButton: UIButton!
    @IBAction func deleteDevice(_ sender: AnyObject) {
        let alert=UIAlertView(title: "", message: loadLanguage("删除此设备"), delegate: self, cancelButtonTitle: loadLanguage("否"), otherButtonTitles: loadLanguage("是"))
        alert.show()
    }
    
    @IBOutlet var DeviceNameLable: UILabel!
    @IBOutlet var checkLable: UILabel!
    @IBOutlet var AccordingLable: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //aboutContainer.hidden = !IsLoginByPhone()
        DeviceNameLable.text=loadLanguage("我的水探头")
        checkLable.text=loadLanguage("检测时间")
        checkLabel1.text=loadLanguage("检测时间1")
        checkLabel2.text=loadLanguage("检测时间2")
        AccordingLable.text=loadLanguage("滤芯不足10天会显示提醒")
        deleteDeviceButton.setTitle(loadLanguage("删除此设备"), for: UIControlState())
        
        self.title=loadLanguage("水探头")
        let savebutton=UIBarButtonItem(title: loadLanguage("保存"), style: .plain, target: self, action: #selector(SaveClick))
        let leftbutton=UIButton(frame: CGRect(x: 0, y: 0, width: 10, height: 21))
        leftbutton.setBackgroundImage(UIImage(named: "fanhui"), for: UIControlState())
        leftbutton.addTarget(self, action: #selector(back), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem=UIBarButtonItem(customView: leftbutton)
        self.navigationItem.rightBarButtonItem=savebutton
        deleteDeviceButton.layer.borderWidth=1
        deleteDeviceButton.layer.borderColor=UIColor(red: 1, green: 92/255, blue: 102/255, alpha: 1).cgColor
        deleteDeviceButton.layer.cornerRadius=20
        deleteDeviceButton.layer.masksToBounds=true
        //loadDeviceData加载设备里面数据
        loadDeviceData()
        DeviceName.text=(plistData.object(forKey: "deviceName") as! String)+"("+(plistData.object(forKey: "deviceAttrib") as! String)+")"
        var tmp=plistData.object(forKey: "checktime1") as! Int
        
        checkValue1.text=(tmp/3600<10 ? "0\(tmp/3600)":"\(tmp/3600)")+":"+(tmp%3600/60<10 ? "0\(tmp%3600/60)":"\(tmp%3600/60)")
        if checkValue1.text=="00:00"
        {
            checkValue1.text="10:00"
        }
        tmp=plistData.object(forKey: "checktime2") as! Int
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
        NotificationCenter.default.addObserver(self, selector: #selector(setNameChange), name: NSNotification.Name(rawValue: "setTanTouName"), object: nil)
        //
        //pickerview
       datePickerView=Bundle.main.loadNibNamed("uiDatePickerView_EN", owner: nil, options: nil)?.last as! uiDatePickerView_EN
        //取消
        datePickerView.frame=CGRect(x: 0, y: 0, width: Screen_Width, height: Screen_Hight)
        datePickerView.cancelButton.addTarget(self, action: #selector(PickerCancel), for: .touchUpInside)
        //确定
        datePickerView.OKButton.addTarget(self, action: #selector(PickerOK), for: .touchUpInside)
        
        // Do any additional setup after loading the view.
    }

    //加载设备里面数据
    func loadDeviceData()
    {
        let tap = self.myCurrentDevice as! Tap
        //名称体重饮水量
        var nameStr=tap.settings.name as String
        if nameStr.characters.contains("(")==false
        {
            nameStr = nameStr+loadLanguage("(厨房)")
        }
        plistData.setValue((nameStr.substring(to: (nameStr.characters.index(of: "(")!))) as String, forKey: "deviceName")
        let i1 = nameStr.unicodeScalars.index(after: nameStr.unicodeScalars.index(of: "(")!)
        let i2 = nameStr.unicodeScalars.index(of: ")")!
        
        let substring = nameStr.unicodeScalars[i1..<i2]
        //let tmpname=plistData.object(forKey: "deviceName") as! String
        //let nameStr2=nameStr.substring(with: NSMakeRange(tmpname.characters.count+1, (nameStr.characters.count)-tmpname.characters.count-2))
        plistData.setValue(substring.description, forKey: "deviceAttrib")

        plistData.setValue(tap.settings.detectTime1, forKey: "checktime1")
        plistData.setValue(tap.settings.detectTime2, forKey: "checktime2")

    }
    //自定义方法
    //设置时间
    func curLabelTime(_ timeStr:String)->Date
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat="YYYY-MM-dd"
        var nowStr:String=dateFormatter.string(from: Date())
        nowStr=nowStr+" "+timeStr+":00"
//        let value = "2016-07-27 18:00:00"
        dateFormatter.dateFormat="yyyy-MM-dd HH:mm:ss"
        let tmpDate=dateFormatter.date(from: nowStr)! as Date
        print(tmpDate)
        
        return tmpDate
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
                _=self.navigationController?.popViewController(animated: true)
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
    //PickerCancel
    func PickerCancel()
    {
        checkImage1.isHidden=true
        checkImage2.isHidden=true
        datePickerView.removeFromSuperview()
    }
    //PickerOK
    func PickerOK()
    {
        checkImage1.isHidden=true
        checkImage2.isHidden=true
        let select = datePickerView.datePicker.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let dateAndTime =  dateFormatter.string(from: select)
        if currentselect==0
        {
            checkValue1.text=dateAndTime
            let tmpstring=dateAndTime as NSString
          plistData.setValue((Int(tmpstring.substring(to: 2))!*3600+Int(tmpstring.substring(from: 3))!*60), forKey: "checktime1")
            
        }
        else
        {
            checkValue2.text=dateAndTime
            let tmpstring=dateAndTime as NSString
            plistData.setValue((Int(tmpstring.substring(to: 2))!*3600+Int(tmpstring.substring(from: 3))!*60), forKey: "checktime2")
        }
        datePickerView.removeFromSuperview()
    }
    //设置名字属性完成后传值痒
    func setNameChange(_ text:Notification){
        plistData.setValue((text as NSNotification).userInfo!["name"], forKey: "deviceName")
        plistData.setValue((text as NSNotification).userInfo!["attr"], forKey: "deviceAttrib")
        var tmpstring=((text as NSNotification).userInfo!["name"] as! String)+"("
        tmpstring+=((text as NSNotification).userInfo!["attr"] as! String)+")"
        DeviceName.text=tmpstring
        
    }
    
    func SaveClick(){
        //写入本地
        setPlistData(plistData, fileName: "setTanTou_EN")
        //写入设备
        let tap = self.myCurrentDevice as! Tap
        tap.settings.name=plistData.object(forKey: "deviceName") as! String
        tap.settings.get_isDetectTime1=true
        tap.settings.get_isDetectTime2=true
        tap.settings.detectTime1=plistData.object(forKey: "checktime1") as! TimeInterval
        tap.settings.detectTime2=plistData.object(forKey: "checktime2") as!
        TimeInterval
        
        OznerManager.instance().save(tap)
        print(tap.settings.name)
        print(tap.settings.detectTime1)
        print(tap.settings.detectTime2)
        print(tap.settings.get_isDetectTime1)
        print(tap.settings.get_isDetectTime2)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "updateDeviceInfo"), object: nil)
        _=self.navigationController?.popViewController(animated: true)
    }
    
    //系统自带
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden=false
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(named: "bg_clear_gray"), for: UIBarMetrics.default)
        self.navigationController!.navigationBar.shadowImage =  UIImage(named: "bg_clear_black")
        (CustomTabBarView.sharedCustomTabBar() as AnyObject).hideOverTabBar()
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
