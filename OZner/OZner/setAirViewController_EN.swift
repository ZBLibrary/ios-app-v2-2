//
//  setSmallAirViewController.swift
//  OZner
//
//  Created by test on 15/12/19.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

import UIKit

class setAirViewController_EN: UIViewController,UIAlertViewDelegate {

    var myCurrentDevice:OznerDevice?
    let plistName:String=get_CurrSelectEquip()==4 ? "setSmallAir_EN":"setBigAir_EN"
    var plistData:NSMutableDictionary!
    var mainView:SetSmallAirViewXib!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title=loadLanguage("台式空气净化器")
        let savebutton=UIBarButtonItem(title: loadLanguage("保存"), style: .plain, target: self, action: #selector(SaveClick))
        let leftbutton=UIButton(frame: CGRect(x: 0, y: 0, width: 10, height: 21))
        leftbutton.setBackgroundImage(UIImage(named: "fanhui"), for: UIControlState())
        leftbutton.addTarget(self, action: #selector(back), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem=UIBarButtonItem(customView: leftbutton)
        self.navigationItem.rightBarButtonItem=savebutton
        NotificationCenter.default.addObserver(self, selector: #selector(setNameChange), name: NSNotification.Name(rawValue: "\(plistName)Name"), object: nil)
        initMainView()
       
        // Do any additional setup after loading the view.
    }

    
    //初始化视图
    func initMainView()
    {
        plistData=getPlistData(plistName)
        let ScrollView=UIScrollView(frame: CGRect(x: 0, y: 0, width: Screen_Width, height: Screen_Hight))
        ScrollView.backgroundColor=UIColor(red: 238/255, green: 239/255, blue: 240/255, alpha: 1)
        
         mainView=Bundle.main.loadNibNamed("SetSmallAirViewXib", owner: self, options: nil)?.last as! SetSmallAirViewXib//.loadNibNamed("setSmallAirViewXib", owner: nil, options: nil)?.last as! setSmallAirView
        mainView.frame=CGRect(x: 0, y: 0, width: Screen_Width, height: mainView.bounds.size.height)
        //loadDeviceData加载设备里面数据
        loadDeviceData()
        let name1 = plistData.object(forKey: "deviceName") as! String?
        let name2 = plistData.object(forKey: "deviceAttrib") as! String?
        mainView.nameValue.text=name1!+"("+name2!+")"
        mainView.toSetNameButton.addTarget(self, action: #selector(toSetDvName), for: .touchUpInside)
        mainView.operatingIntroducButton.addTarget(self, action: #selector(toOperatingIntroduc), for: .touchUpInside)
        //mainView.operatingDemoButton.addTarget(self, action: #selector(toOperatingDemo"), forControlEvents: .TouchUpInside)
        mainView.commonQestion.addTarget(self, action: #selector(tocommonQestion), for: .touchUpInside)
        mainView.clearButton.addTarget(self, action: #selector(ClearClick), for: .touchUpInside)
        mainView.clearButton.layer.borderWidth=1
        mainView.clearButton.layer.cornerRadius=20
        mainView.clearButton.layer.masksToBounds=true
        mainView.clearButton.layer.borderColor=UIColor(red: 247/255, green: 188/255, blue: 196/255, alpha: 1).cgColor
        if get_CurrSelectEquip()==4
        {
            self.title=loadLanguage("台式空气净化器")
            mainView.nameLabel.text=loadLanguage("台式空气净化器")
        }
        else
        {
            self.title=loadLanguage("立式空气净化器")
            mainView.nameLabel.text=loadLanguage("立式空气净化器")
        }
        ScrollView.contentSize=CGSize(width: 0, height: (mainView.bounds.size.height<self.view.height ? self.view.height:mainView.bounds.size.height))
        ScrollView.addSubview(mainView)
        self.view.addSubview(ScrollView)
    }
    //加载设备里面数据
    func loadDeviceData()
    {
        if get_CurrSelectEquip()==4
        {
        
            let airBlue = self.myCurrentDevice as! AirPurifier_Bluetooth
            //名称体重饮水量
            var nameStr=airBlue.settings.name
            if nameStr?.characters.contains("(")==false
            {
                nameStr=nameStr!+"(客厅)"
            }
            plistData.setValue((nameStr?.substring(to: (nameStr?.characters.index(of: "(")!)!))! as String, forKey: "deviceName")
            
            let i1 = nameStr?.unicodeScalars.index(after: (nameStr?.unicodeScalars.index(of: "(")!)!)
            let i2 = nameStr?.unicodeScalars.index(of: ")")!
            
            let substring = nameStr?.unicodeScalars[i1!..<i2!]
            
            plistData.setValue(substring?.description, forKey: "deviceAttrib")
        }
        else
        {
            let airMx = self.myCurrentDevice as! AirPurifier_MxChip
            //名称体重饮水量
            var nameStr=airMx.settings.name as String
            if nameStr.characters.contains("(")==false
            {
                nameStr=nameStr+"(家)"
            }
            plistData.setValue((nameStr.substring(to: (nameStr.characters.index(of: "(")!))) as String, forKey: "deviceName")
            
            let i1 = nameStr.unicodeScalars.index(after: nameStr.unicodeScalars.index(of: "(")!)
            let i2 = nameStr.unicodeScalars.index(of: ")")!
            
            let substring = nameStr.unicodeScalars[i1..<i2]
            
            plistData.setValue(substring.description, forKey: "deviceAttrib")
        }
        
        
    }
    //自定义函数，处理点击和回调事件
    //返回
    func back(){
        let alert=UIAlertView(title: "", message: loadLanguage("是否保存？"), delegate: self, cancelButtonTitle: loadLanguage("否"), otherButtonTitles: loadLanguage("是"))
        alert.tag=1
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


    func toSetDvName(){
        let setnamecontroller=setDeviceNameViewController_EN(nibName: "setDeviceNameViewController_EN", bundle: nil)
        setnamecontroller.dataPlist=plistData
        self.navigationController?.pushViewController(setnamecontroller, animated: true)
    }
    func setNameChange(_ text:Notification){
        plistData.setValue((text as NSNotification).userInfo!["name"], forKey: "deviceName")
        plistData.setValue((text as NSNotification).userInfo!["attr"], forKey: "deviceAttrib")
        var tmpstring=((text as NSNotification).userInfo!["name"] as! String)+"("
        tmpstring+=((text as NSNotification).userInfo!["attr"] as! String)+")"
        mainView.nameValue.text=tmpstring
        
    }
    func SaveClick(){
        //写入本地
        setPlistData(plistData, fileName: plistName)
        if get_CurrSelectEquip()==4
        {
            
            let airBlue = self.myCurrentDevice as! AirPurifier_Bluetooth
            //名称体重饮水量
            
         airBlue.settings.name=(plistData.object(forKey: "deviceName") as! String)+"("+(plistData.object(forKey: "deviceAttrib") as! String)+")"
            OznerManager.instance().save(airBlue)
        }
        else
        {
            let airMx = self.myCurrentDevice as! AirPurifier_MxChip
            airMx.settings.name=(plistData.object(forKey: "deviceName") as! String)+"("+(plistData.object(forKey: "deviceAttrib") as! String)+")"
            OznerManager.instance().save(airMx)
            
        }
    //侧边栏更新
        NotificationCenter.default.post(name: Notification.Name(rawValue: "updateDeviceInfo"), object: nil)
        _ = navigationController?.popViewController(animated: true)    }
    
    func toOperatingIntroduc()
    {
        let lonImage=LongImageViewController_EN(nibName: "LongImageViewController_EN", bundle: nil)
        lonImage.iswhitch=0
        self.navigationController?.pushViewController(lonImage, animated: true)
    }
//    func toOperatingDemo()
//    {
//        let alert=UIAlertView(title: "", message: "对不起，暂时此功能还未开通", delegate: self, cancelButtonTitle: "确定")
//        alert.show()
//    }
    func tocommonQestion()
    {
        let lonImage=LongImageViewController_EN(nibName: "LongImageViewController_EN", bundle: nil)
        lonImage.iswhitch=1
        self.navigationController?.pushViewController(lonImage, animated: true)
    }
    func ClearClick()
    {
        
        let alert=UIAlertView(title: "", message: loadLanguage("删除此设备"), delegate: self, cancelButtonTitle: loadLanguage("否"), otherButtonTitles: loadLanguage("是"))
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
        NotificationCenter.default.post(name: Notification.Name(rawValue: "removDeviceByZB"), object: nil)
        _=self.navigationController?.popViewController(animated: true)
    }
    
  
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
