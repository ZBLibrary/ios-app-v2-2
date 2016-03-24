//
//  setTanTouNameViewController.swift
//  OZner
//
//  Created by test on 15/12/18.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

import UIKit

class setDeviceNameViewController: UIViewController,UITextFieldDelegate,UIAlertViewDelegate {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?){
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
        required init(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    var noticeName=""
    var dataPlist:NSDictionary!
    @IBOutlet var NameText: UITextField!
    @IBAction func setNameClick(sender: AnyObject) {
        NameText.enabled=true
        NameText.backgroundColor=UIColor.whiteColor()
        NameText.becomeFirstResponder()
    }
    
    @IBOutlet var setAdress1: UILabel!
    @IBOutlet var setAdress2: UILabel!
    @IBOutlet var setAdressImage1: UIImageView!
    @IBOutlet var setAdressImage2: UIImageView!
    
    @IBAction func setAdressButton1(sender: AnyObject) {
        setAdressImage1.hidden=false
        setAdressImage2.hidden=true
    }
    @IBAction func setAdressButton2(sender: AnyObject) {
        setAdressImage1.hidden=true
        setAdressImage2.hidden=false
    }
    
    @IBOutlet var Place: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="设备名称"
         Place.text=loadLanguage("使用地点")
        //初始化控件
        initCustomView()
        NameText.text=dataPlist.objectForKey("deviceName") as? String
        NameText.delegate=self
        let savebutton=UIBarButtonItem(title: loadLanguage("保存"), style: .Plain, target: self, action: #selector(SaveClick))
        let leftbutton=UIButton(frame: CGRect(x: 0, y: 0, width: 10, height: 21))
        leftbutton.setBackgroundImage(UIImage(named: "fanhui"), forState: .Normal)
        leftbutton.addTarget(self, action: #selector(back), forControlEvents: .TouchUpInside)
        self.navigationItem.leftBarButtonItem=UIBarButtonItem(customView: leftbutton)
        self.navigationItem.rightBarButtonItem=savebutton
        // Do any additional setup after loading the view.
    }

    //自定义函数
    //初始化控件
    
    func initCustomView(){
        var textstring=""
        switch(get_CurrSelectEquip())
        {
            //探头
        case 2:
            noticeName="setTanTouName"
            textstring=loadLanguage("洗手间")
            setAdress1.text=loadLanguage("洗手间")
            setAdress2.text=loadLanguage("厨房")
            break
            //净水器
        case 3:
            noticeName="setShuiJiName"
            textstring=loadLanguage("家")
            setAdress1.text=loadLanguage("家")
            setAdress2.text=loadLanguage("办公室")
            break
            //台式空气净化器
        case 4:
            noticeName="setSmallAirName"
            textstring=loadLanguage("客厅")
            setAdress1.text=loadLanguage("客厅")
            setAdress2.text=loadLanguage("卧室")
            break
            //立式空气净化器
        case 5:
            noticeName="setBigAirName"
            textstring=loadLanguage("客厅")
            setAdress1.text=loadLanguage("客厅")
            setAdress2.text=loadLanguage("卧室")
            break
        case 6:
            noticeName="setWaterReplenishName"
            textstring="办公室"
            setAdress1.text="办公室"
            setAdress2.text="家"
            break
        default:
            break
        }
        let tmpstring=dataPlist.objectForKey("deviceAttrib") as! String
        setAdressImage1.hidden=tmpstring==textstring ? false:true
        setAdressImage2.hidden=tmpstring==textstring ? true:false
    }
    //返回
    func back(){
        if (dataPlist.objectForKey("deviceName") as? String) != NameText.text!+"("+(setAdressImage1.hidden==false ? setAdress1.text:setAdress2.text)!+")"
        {
            let alert=UIAlertView(title: "", message: "是否保存？", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "保存")
            alert.show()
        }
        else
        {
           self.navigationController?.popViewControllerAnimated(true)
        }
    }
    //alert 点击事件
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex==0
        {
            self.navigationController?.popViewControllerAnimated(true)
        }
        else
        {
            SaveClick()
        }
    }
    //保存
    func SaveClick()
    {
        let attrtmp=setAdressImage1.hidden==false ? setAdress1.text:setAdress2.text
        NSNotificationCenter.defaultCenter().postNotificationName(noticeName, object: nil, userInfo: ["name":NameText.text!,"attr":attrtmp!])
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    //系统委托方法
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        textField.backgroundColor=UIColor.clearColor()
        textField.enabled=false
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden=false
        self.navigationController?.navigationBar.barTintColor=UIColor(red: 248/255, green: 249/255, blue: 250/255, alpha: 1)
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
