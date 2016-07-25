//
//  MyInfoViewController_ENViewController.swift
//  OZner
//
//  Created by zhuguangyang on 16/7/25.
//  Copyright © 2016年 sunlinlin. All rights reserved.
//

import UIKit

class MyInfoViewController_EN: UIViewController {
    
    var mainView:My_MainView_EN!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor=UIColor(red: 248/255, green: 249/255, blue: 250/255, alpha: 1)
        
        let ScrollView=UIScrollView(frame: CGRect(x: 0, y: 0, width: Screen_Width, height: Screen_Hight-49))
        ScrollView.backgroundColor=UIColor(red: 238/255, green: 239/255, blue: 240/255, alpha: 1)
        
        mainView=NSBundle.mainBundle().loadNibNamed("My_MainView_EN", owner: nil, options: nil).last as! My_MainView_EN
        //添加数据和事件
        mainView.My_Equids_button.addTarget(self, action: #selector(EquidsClick), forControlEvents: .TouchUpInside)
        //        mainView.My_Friends.addTarget(self, action: #selector(My_FriendsClick), forControlEvents: .TouchUpInside)
        mainView.SuggestButton.addTarget(self, action: #selector(Suggest), forControlEvents: .TouchUpInside)
        mainView.Set.addTarget(self, action: #selector(SetApp), forControlEvents: .TouchUpInside)
        
        mainView.My_login.addTarget(self, action: #selector(toLogin), forControlEvents: .TouchUpInside)
        
        mainView.frame=CGRect(x: 0, y: -20, width: Screen_Width, height: 602)
        ScrollView.contentSize=CGSize(width: 0, height: 602)
        ScrollView.addSubview(mainView)
        self.view.addSubview(ScrollView)
        
        //初始化加载数据
        loadMyInfo()
        //更新朋友数量
        //        updateFriendCount()
    }
    
    
    //个人信息
    func loadMyInfo()
    {
        //get_Phone()
        let werbservice = MyInfoWerbservice()
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        werbservice.getUserNickImage([get_Phone()]){ [weak self](userinfo:NSMutableDictionary!, state:StatusManager!) -> Void in
            if let StrongSelf=self
            {
                MBProgressHUD.hideHUDForView(StrongSelf.view, animated: true)
                if state.networkStatus != kSuccessStatus
                {
                    return
                }
                if userinfo==nil||userinfo.count==0
                {
                    return
                }
                
                let state=userinfo.objectForKey("state") as! Int
                if state >= 0
                {
                    let data=userinfo.objectForKey("data")?.objectAtIndex(0)
                    print(data)
                    let mobile=data?.objectForKey("mobile") as! String
                    var name=data!.objectForKey("nickname") as! String
                    
                    name=name=="" ? mobile : name
                    
                    StrongSelf.mainView.My_login.setTitle((name ?? "无名"), forState: .Normal)
                    var Score=data!.objectForKey("Score") as! String
                    Score=Score=="" ? "0" : Score
                    //                    StrongSelf.mainView.My_Money.text=Score
                    let headimg=data!.objectForKey("headimg") as! String
                    //                    let gradeName=(data!.objectForKey("GradeName") as! String)=="" ? "":((data!.objectForKey("GradeName") as! String))
                    
                    //                    let tmpName=gradeName.stringByReplacingOccurrencesOfString("会员", withString: "代理会员")
                    //                    StrongSelf.mainView.My_job.text = loadLanguage(tmpName)
                    //                    print(StrongSelf.mainView.My_job.text)
                    if headimg == ""
                    {
                        StrongSelf.mainView.My_head.image=UIImage(named: "DefaultHeadImage")
                    }
                    else{
                        StrongSelf.mainView.My_head.image=UIImage(data: NSData(contentsOfURL: NSURL(string: headimg)!)!)
                    }
                    
                    StrongSelf.mainView.My_login.enabled=false
                    //self.loadDevices()
                    //self.getYZcount()
                }
            }
        }
        
    }
    //设备信息
    //    func loadDevices()
    //    {
    //        let manager = AFHTTPRequestOperationManager()
    //        let url = StarURL_New+"/OznerServer/GetDeviceList"
    //        let params:NSDictionary = ["usertoken":get_UserToken()]
    //        manager.POST(url,
    //            parameters: params,
    //            success: { (operation: AFHTTPRequestOperation!,
    //                responseObject: AnyObject!) in
    //                print(responseObject)
    //                let state=responseObject.objectForKey("state") as! Int
    //                if state >= 0
    //                {
    //                    self.mainView.My_EquipCount.text="\(state)"
    //                }
    //
    //            },
    //            failure: { (operation: AFHTTPRequestOperation!,
    //                error: NSError!) in
    //                print("Error: " + error.localizedDescription)
    //        })
    //    }
    func toLogin()
    {
        LogInOut.loginInOutInstance().loginOutUser()
        
    }
    //已有设备
    func EquidsClick()
    {
        self.performSegueWithIdentifier("showEquids", sender: self)
    }
    
    //我要提意见
    func Suggest()
    {
        self.performSegueWithIdentifier("showSuggest", sender: self)
    }
    //设置
    func SetApp()
    {
        self.performSegueWithIdentifier("showSet", sender: self)
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //我的设备数量
        let devices=OznerManager.instance().getDevices() as [AnyObject!]
        //        mainView.My_EquipCount.text="\(devices.count)"
        self.navigationController?.navigationBarHidden=true
        CustomTabBarView.sharedCustomTabBar().showAllMyTabBar()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


