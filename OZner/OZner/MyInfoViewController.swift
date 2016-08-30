//
//  FirstViewController.swift
//  My
//
//  Created by test on 15/11/24.
//  Copyright © 2015年 HAOZE. All rights reserved.
//

import UIKit

class MyInfoViewController: UIViewController {
    
    var mainView:My_MainView!
    var mainView_EN:My_MainView_EN!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationController?.navigationBar.barTintColor=UIColor(red: 248/255, green: 249/255, blue: 250/255, alpha: 1)
        
        
        let ScrollView=UIScrollView(frame: CGRect(x: 0, y: 0, width: Screen_Width, height: Screen_Hight-49))
        ScrollView.backgroundColor=UIColor(red: 238/255, green: 239/255, blue: 240/255, alpha: 1)
        mainView=NSBundle.mainBundle().loadNibNamed("My_MainView", owner: nil, options: nil).last as! My_MainView
        mainView_EN=NSBundle.mainBundle().loadNibNamed("My_MainView_EN", owner: nil, options: nil).last as! My_MainView_EN
        if  (NSUserDefaults.standardUserDefaults().objectForKey(CURRENT_LOGIN_STYLE) as! NSString).isEqualToString(LoginByPhone) {
            
            //添加数据和事件
            mainView.My_Equids_button.addTarget(self, action: #selector(EquidsClick), forControlEvents: .TouchUpInside)
            mainView.My_Friends.addTarget(self, action: #selector(My_FriendsClick), forControlEvents: .TouchUpInside)
            mainView.SuggestButton.addTarget(self, action: #selector(Suggest), forControlEvents: .TouchUpInside)
            mainView.Set.addTarget(self, action: #selector(SetApp), forControlEvents: .TouchUpInside)
            
            //我的小金库
            mainView.My_Money_button.addTarget(self, action: #selector(toURL), forControlEvents: .TouchUpInside)
            mainView.My_Money_button.tag=0
            //我的订单
            mainView.ShareButton.addTarget(self, action: #selector(toURL), forControlEvents: .TouchUpInside)
            mainView.ShareButton.tag=1
            //红包
            mainView.AgentButton.addTarget(self, action: #selector(toURL), forControlEvents: .TouchUpInside)
            mainView.AgentButton.tag=2
            //我的礼卷
            mainView.AwardButton.addTarget(self, action: #selector(toURL), forControlEvents: .TouchUpInside)
            mainView.AwardButton.tag=3
            //查看水质报告
            mainView.BaogaoButton.addTarget(self, action: #selector(toURL), forControlEvents: .TouchUpInside)
            mainView.BaogaoButton.tag=4
            
            mainView.My_login.addTarget(self, action: #selector(toLogin), forControlEvents: .TouchUpInside)
            //mainView.My_job.hidden=true
            mainView.NewsCount.hidden=true
            mainView.frame=CGRect(x: 0, y: -20, width: Screen_Width, height: 602)
            ScrollView.contentSize=CGSize(width: 0, height: 602)
            ScrollView.addSubview(mainView)
            self.view.addSubview(ScrollView)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(updateFriendCount), name: "OtherAcceptMeNews", object: nil)
            //初始化加载数据
            loadMyInfo()
            //更新朋友数量
            updateFriendCount()
        } else {
            
            //添加数据和事件
            mainView_EN.My_Equids_button.addTarget(self, action: #selector(My_FriendsClick), forControlEvents: .TouchUpInside)
            //        mainView.My_Friends.addTarget(self, action: #selector(My_FriendsClick), forControlEvents: .TouchUpInside)
            mainView_EN.SuggestButton.addTarget(self, action: #selector(Suggest), forControlEvents: .TouchUpInside)
            mainView_EN.Set.addTarget(self, action: #selector(SetApp), forControlEvents: .TouchUpInside)
            
            //            mainView_EN.My_login.addTarget(self, action: #selector(toLogin1), forControlEvents: .TouchUpInside)
            
            mainView_EN.frame=CGRect(x: 0, y: -20, width: Screen_Width, height: 602)
            //        ScrollView.contentSize=CGSize(width: 0, height: 602)
            ScrollView.backgroundColor = UIColor.whiteColor()
            ScrollView.addSubview(mainView_EN)
            self.view.addSubview(ScrollView)
            
            //初始化加载数据
            //            loadMyInfo()
        }
    }
    
    //新增朋友数量小红点数量
    func updateFriendCount()
    {
        let countNewFriend=NSUserDefaults.standardUserDefaults().objectForKey("OtherAcceptMeNews")==nil ? 0:NSUserDefaults.standardUserDefaults().objectForKey("OtherAcceptMeNews")
        if (countNewFriend as! Int) != 0
        {
            //mainView.NewsCount.text="\(countNewFriend as! Int)"
            mainView.NewsCount.hidden=false
        }
        else
        {
            mainView.NewsCount.hidden=true
        }
        
    }
    
    //个人信息
    func loadMyInfo()
    {
        //get_Phone()
        let werbservice = MyInfoWerbservice()
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        if get_Phone() == "null" ||  (NSUserDefaults.standardUserDefaults().objectForKey(CURRENT_LOGIN_STYLE) as! NSString).isEqualToString(LoginByEmail)  {
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            return
        }
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
                    var name:String=(data!.objectForKey("nickname") ?? "") as! String
                    
                    name=name=="" ? mobile : name
                    
                    StrongSelf.mainView.My_login.setTitle((name ?? "无名"), forState: .Normal)
                    var Score=data!.objectForKey("Score") as! String
                    Score=Score=="" ? "0" : Score
                    StrongSelf.mainView.My_Money.text=Score
                    let headimg=data!.objectForKey("headimg") as! String
                    let gradeName=(data!.objectForKey("GradeName") as! String)=="" ? "":((data!.objectForKey("GradeName") as! String))
                    
                    let tmpName=gradeName.stringByReplacingOccurrencesOfString("会员", withString: "代理会员")
                    StrongSelf.mainView.My_job.text = loadLanguage(tmpName)
                    
                    if !(headimg.containsString("http://") || headimg.containsString("https://"))
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
    
    
    //跳转
    func toURL(button:UIButton)
    {
        let weiXinUrl=weiXinUrlNamezb()
        let tmpURLController=WeiXinURLViewController_EN(nibName: "WeiXinURLViewController_EN", bundle: nil)
        switch button.tag
        {
        case 0:
            tmpURLController.title=weiXinUrl.myMoney
            
        case 1:
            tmpURLController.title=weiXinUrl.shareLiKa
            
        case 2:
            tmpURLController.title=weiXinUrl.callFriend
            
        case 3:
            tmpURLController.title=weiXinUrl.awardInfo
            
        case 4:
            tmpURLController.title=weiXinUrl.waterReport
            
        default:
            break
        }
        self.presentViewController(tmpURLController, animated: true, completion: nil)
        
    }
    
    
    
    func toLogin()
    {
        LogInOut.loginInOutInstance().loginOutUser()
        
    }
    func toLogin1()
    {
        LogInOut.loginInOutInstance().loginOutUser()
        
    }
    //已有设备
    func EquidsClick()
    {
        self.performSegueWithIdentifier("showEquids", sender: self)
    }
    //我的好友
    func My_FriendsClick()
    {
        NSUserDefaults.standardUserDefaults().setValue(0, forKey: "OtherAcceptMeNews")
        updateFriendCount()
        self.performSegueWithIdentifier("showFriends", sender: self)
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
        //        if  (NSUserDefaults.standardUserDefaults().objectForKey(CURRENT_LOGIN_STYLE) as! NSString).isEqualToString(LoginByPhone) {
        let devices=OznerManager.instance().getDevices() as [AnyObject!]
        mainView.My_EquipCount.text="\(devices.count)"
        self.navigationController?.navigationBarHidden=true
        CustomTabBarView.sharedCustomTabBar().showAllMyTabBar()
        //        } else {
        //            self.navigationController?.navigationBarHidden=false
        //            self.title = loadLanguage("个人设置")
        //            let leftButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_back@2x"), style: UIBarButtonItemStyle.Done, target: self, action: #selector(leftMethod))
        //            leftButton.tintColor = UIColor.darkGrayColor()
        //            self.navigationItem.leftBarButtonItem = leftButton;
        //    }
    }
    
    
    func leftMethod()
    {
        self.navigationController!.view .removeFromSuperview()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

