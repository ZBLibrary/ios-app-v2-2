//
//  setShuiJiViewController.swift
//  OZner
//
//  Created by test on 15/12/18.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

import UIKit

class setShuiJiViewController: UIViewController,UIAlertViewDelegate {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?){
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    convenience  init() {
        
        var nibNameOrNil = String?("RootViewController")
        
        //考虑到xib文件可能不存在或被删，故加入判断
        
        if NSBundle.mainBundle().pathForResource(nibNameOrNil, ofType: "xib") == nil
            
        {
            
            nibNameOrNil = nil
            
        }
        
        self.init(nibName: nibNameOrNil, bundle: nil)
        
    }
    required init(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    var plistData:NSMutableDictionary=getPlistData("setShuiJi")
   
    var myCurrentDevice:OznerDevice?
 
    @IBOutlet var DeviceName: UILabel!
 
    @IBAction func toSetDvName(sender: AnyObject) {
        let setnamecontroller=setDeviceNameViewController(nibName: "setDeviceNameViewController", bundle: nil)
        setnamecontroller.dataPlist=plistData
        self.navigationController?.pushViewController(setnamecontroller, animated: true)
    }
    @IBAction func toAboutDevice(sender: AnyObject) {
        let aboutDevice=AboutDeviceViewController(nibName: "AboutDeviceViewController", bundle: nil)
        aboutDevice.title=loadLanguage("关于净水器")
        aboutDevice.urlstring="http://cup.ozner.net/app/gyysj/gyysj.html"
        self.navigationController?.pushViewController(aboutDevice, animated: true)
    }
    
    @IBOutlet var deleteDeviceButton: UIButton!
    @IBAction func deleteDeviceClick(sender: AnyObject) {
        let alert=UIAlertView(title: "", message: "删除此设备", delegate: self, cancelButtonTitle: "否", otherButtonTitles: "是")
        alert.show()
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
    @IBOutlet var DeviceNameLable: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        DeviceNameLable.text=loadLanguage("我的净水器" )
       deleteDeviceButton.setTitle(loadLanguage("删除此设备"), forState: .Normal)
        self.title=loadLanguage("净水器")
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
        //
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(setNameChange), name: "setShuiJiName", object: nil)
        // Do any additional setup after loading the view.
    }

    
    //加载设备里面数据
    func loadDeviceData()
    {
        let water = self.myCurrentDevice as! WaterPurifier
        //名称体重饮水量
        var nameStr=water.settings.name
        if nameStr.characters.contains("(")==false
        {
            nameStr=nameStr+"(家)"
        }
        plistData.setValue(nameStr.substringToIndex(nameStr.characters.indexOf("(")!) as String, forKey: "deviceName")
        let tmpname=plistData.objectForKey("deviceName") as! String
        let nameStr2=(nameStr as NSString).substringWithRange(NSMakeRange(tmpname.characters.count+1, nameStr.characters.count-tmpname.characters.count-2))
        plistData.setValue(nameStr2, forKey: "deviceAttrib")
        

        
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

    func setNameChange(text:NSNotification){
        plistData.setValue(text.userInfo!["name"], forKey: "deviceName")
        plistData.setValue(text.userInfo!["attr"], forKey: "deviceAttrib")
        var tmpstring=(text.userInfo!["name"] as! String)+"("
        tmpstring+=(text.userInfo!["attr"] as! String)+")"
        DeviceName.text=tmpstring
        
    }
    func SaveClick(){
        //写入本地
        setPlistData(plistData, fileName: "setShuiJi")
            //写入设备
        let water = self.myCurrentDevice as! WaterPurifier
        water.settings.name=(plistData.objectForKey("deviceName") as! String)+"("+(plistData.objectForKey("deviceAttrib") as! String)+")"
        OznerManager.instance().save(water)
        NSNotificationCenter.defaultCenter().postNotificationName("updateDeviceInfo", object: nil)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
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
