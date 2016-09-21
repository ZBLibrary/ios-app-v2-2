//
//  setTanTouNameViewController.swift
//  OZner
//
//  Created by test on 15/12/18.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

import UIKit

class setDeviceNameViewController_EN: UIViewController,UITextFieldDelegate,UIAlertViewDelegate {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    required init(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    var noticeName=""
    var dataPlist:NSDictionary!
    @IBOutlet var NameText: UITextField!
    @IBAction func setNameClick(_ sender: AnyObject) {
        NameText.isEnabled=true
        NameText.backgroundColor=UIColor.white
        NameText.becomeFirstResponder()
    }
    
    @IBOutlet var setAdress1: UILabel!
    @IBOutlet var setAdress2: UILabel!
    @IBOutlet var setAdressImage1: UIImageView!
    @IBOutlet var setAdressImage2: UIImageView!
    
    @IBAction func setAdressButton1(_ sender: AnyObject) {
        setAdressImage1.isHidden=false
        setAdressImage2.isHidden=true
    }
    @IBAction func setAdressButton2(_ sender: AnyObject) {
        setAdressImage1.isHidden=true
        setAdressImage2.isHidden=false
    }
    
    @IBOutlet var Place: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title=loadLanguage("设备名称")
        Place.text=loadLanguage("使用地点")
        //初始化控件
        initCustomView()
        NameText.text=dataPlist.object(forKey: "deviceName") as? String
        NameText.delegate=self
        let savebutton=UIBarButtonItem(title: loadLanguage("保存"), style: .plain, target: self, action: #selector(SaveClick))
        let leftbutton=UIButton(frame: CGRect(x: 0, y: 0, width: 10, height: 21))
        leftbutton.setBackgroundImage(UIImage(named: "fanhui"), for: UIControlState())
        leftbutton.addTarget(self, action: #selector(back), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem=UIBarButtonItem(customView: leftbutton)
        self.navigationItem.rightBarButtonItem=savebutton
        // Do any additional setup after loading the view.
    }
    
    //自定义函数
    //初始化控件
    let textDic:NSMutableArray = [["洗手间","家","客厅","客厅","办公室"],["厨房","办公室","卧室","卧室","家"]]
    
    func initCustomView(){
        switch(get_CurrSelectEquip())
        {
        //探头
        case 2:
            noticeName="setTanTouName"
            setAdress1.text=loadLanguage("洗手间")
            setAdress2.text=loadLanguage("厨房")
            break
        //净水器
        case 3:
            noticeName="setShuiJiName"
            setAdress1.text=loadLanguage("家")
            setAdress2.text=loadLanguage("办公室")
            break
        //台式空气净化器
        case 4:
            noticeName="setSmallAirName"
            setAdress1.text=loadLanguage("客厅")
            setAdress2.text=loadLanguage("卧室")
            break
        //立式空气净化器
        case 5:
            noticeName="setBigAirName"
            setAdress1.text=loadLanguage("客厅")
            setAdress2.text=loadLanguage("卧室")
            break
        case 6:
            noticeName="setWaterReplenishName"
            setAdress1.text=loadLanguage("办公室")
            setAdress2.text=loadLanguage("家")
            break
        default:
            break
        }
        let tmpstring=dataPlist.object(forKey: "deviceAttrib") as! String
        setAdressImage1.isHidden=tmpstring==(textDic.object(at: 0) as AnyObject).object(at: get_CurrSelectEquip()-2) as! String ? false:true
        setAdressImage2.isHidden=tmpstring==(textDic.object(at: 0) as AnyObject).object(at: get_CurrSelectEquip()-2) as! String ? true:false
    }
    //返回
    func back(){
        if (dataPlist.object(forKey: "deviceName") as? String) != NameText.text!+"("+(setAdressImage1.isHidden==false ? (textDic.object(at: 0) as AnyObject).object(at: get_CurrSelectEquip()-2) as! String:(textDic.object(at: 1) as AnyObject).object(at: get_CurrSelectEquip()-2) as! String)+")"
        {
            let alert=UIAlertView(title: "", message: loadLanguage("是否保存？"), delegate: self, cancelButtonTitle: loadLanguage("取消"), otherButtonTitles: loadLanguage("保存"))
            alert.show()
        }
        else
        {
            _=self.navigationController?.popViewController(animated: true)
        }
    }
    //alert 点击事件
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if buttonIndex==0
        {
            _=self.navigationController?.popViewController(animated: true)
        }
        else
        {
            SaveClick()
        }
    }
    //保存
    func SaveClick()
    {
        let attrtmp=setAdressImage1.isHidden==false ? ((textDic.object(at: 0) as AnyObject).object(at: get_CurrSelectEquip()-2) as! String):((textDic.object(at: 1) as AnyObject).object(at: get_CurrSelectEquip()-2) as! String)
        NotificationCenter.default.post(name: Notification.Name(rawValue: noticeName), object: nil, userInfo: ["name":NameText.text!,"attr":attrtmp])
        _=self.navigationController?.popViewController(animated: true)
    }
    
    
    //系统委托方法
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        textField.backgroundColor=UIColor.clear
        textField.isEnabled=false
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden=false
        self.navigationController?.navigationBar.barTintColor=UIColor(red: 248/255, green: 249/255, blue: 250/255, alpha: 1)
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
