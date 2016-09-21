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
        mainView=Bundle.main.loadNibNamed("My_MainView", owner: nil, options: nil)?.last as! My_MainView
        
        mainView_EN=Bundle.main.loadNibNamed("My_MainView_EN", owner: nil, options: nil)?.last as! My_MainView_EN
        if  (UserDefaults.standard.object(forKey: CURRENT_LOGIN_STYLE) as! NSString).isEqual(to: LoginByPhone) {
            
            //添加数据和事件
            mainView.My_Equids_button.addTarget(self, action: #selector(EquidsClick), for: .touchUpInside)
            mainView.My_Friends.addTarget(self, action: #selector(My_FriendsClick), for: .touchUpInside)
            mainView.SuggestButton.addTarget(self, action: #selector(Suggest), for: .touchUpInside)
            mainView.Set.addTarget(self, action: #selector(SetApp), for: .touchUpInside)
            
            //我的小金库
            mainView.My_Money_button.addTarget(self, action: #selector(toURL), for: .touchUpInside)
            mainView.My_Money_button.tag=0
            //我的订单
            mainView.ShareButton.addTarget(self, action: #selector(toURL), for: .touchUpInside)
            mainView.ShareButton.tag=1
            //红包
            mainView.AgentButton.addTarget(self, action: #selector(toURL), for: .touchUpInside)
            mainView.AgentButton.tag=2
            //我的礼卷
            mainView.AwardButton.addTarget(self, action: #selector(toURL), for: .touchUpInside)
            mainView.AwardButton.tag=3
            //查看水质报告
            mainView.BaogaoButton.addTarget(self, action: #selector(toURL), for: .touchUpInside)
            mainView.BaogaoButton.tag=4
            
            mainView.My_login.addTarget(self, action: #selector(toLogin), for: .touchUpInside)
            //mainView.My_job.hidden=true
            mainView.NewsCount.isHidden=true
            mainView.frame=CGRect(x: 0, y: -20, width: Screen_Width, height: 602)
            ScrollView.contentSize=CGSize(width: 0, height: 602)
            ScrollView.addSubview(mainView)
            self.view.addSubview(ScrollView)
            NotificationCenter.default.addObserver(self, selector: #selector(updateFriendCount), name: NSNotification.Name(rawValue: "OtherAcceptMeNews"), object: nil)
            //初始化加载数据
            loadMyInfo()
            //更新朋友数量
            updateFriendCount()
        } else {
            
            //添加数据和事件
            mainView_EN.My_Equids_button.addTarget(self, action: #selector(EquidsClick), for: .touchUpInside)
            //        mainView.My_Friends.addTarget(self, action: #selector(My_FriendsClick), forControlEvents: .TouchUpInside)
            mainView_EN.SuggestButton.addTarget(self, action: #selector(Suggest), for: .touchUpInside)
            mainView_EN.Set.addTarget(self, action: #selector(SetApp), for: .touchUpInside)
            
            //            mainView_EN.My_login.addTarget(self, action: #selector(toLogin1), forControlEvents: .TouchUpInside)
            
            mainView_EN.frame=CGRect(x: 0, y: -20, width: Screen_Width, height: 602)
            //        ScrollView.contentSize=CGSize(width: 0, height: 602)
            ScrollView.backgroundColor = UIColor.white
            ScrollView.addSubview(mainView_EN)
            self.view.addSubview(ScrollView)
            
            //初始化加载数据
            //            loadMyInfo()
        }
    }
    
    //新增朋友数量小红点数量
    func updateFriendCount()
    {
        let countNewFriend=UserDefaults.standard.object(forKey: "OtherAcceptMeNews")==nil ? 0:UserDefaults.standard.object(forKey: "OtherAcceptMeNews")
        if (countNewFriend as! Int) != 0
        {
            //mainView.NewsCount.text="\(countNewFriend as! Int)"
            mainView.NewsCount.isHidden=false
        }
        else
        {
            mainView.NewsCount.isHidden=true
        }
        
    }
    
    //个人信息
    func loadMyInfo()
    {
        //get_Phone()
        let werbservice = MyInfoWerbservice()
        MBProgressHUD.showAdded(to: self.view, animated: true)
        if get_Phone() == "null" ||  (UserDefaults.standard.object(forKey: CURRENT_LOGIN_STYLE) as! NSString).isEqual(to: LoginByEmail)  {
            MBProgressHUD.hide(for: self.view, animated: true)
            return
        }
        werbservice.getUserNickImage([get_Phone()]){ [weak self](userinfo, status) -> Void in
            if let StrongSelf=self
            {
                MBProgressHUD.hide(for: StrongSelf.view, animated: true)
                if status?.networkStatus != kSuccessStatus || userinfo == nil
                {
                    return
                }
                
                //let json=userinfo// as AnyObject
                
                let state=userinfo?.object(forKey: "state") as! Int//json["state"].intValue
                if state >= 0
                {
                    let data1=userinfo?.object(forKey: "data") as! NSArray
                    let data=data1.object(at: 0) as! NSDictionary
                    let mobile=data.object(forKey: "mobile") ?? ""
                    var name=data.object(forKey: "nickname")
                    name=name==nil ? mobile : name
                    
                    StrongSelf.mainView.My_login.setTitle(name as! String?, for: UIControlState())
                    var Score=data.object(forKey: "Score")
                    Score=Score==nil ? "0" : Score
                    StrongSelf.mainView.My_Money.text=Score as! String?
                    
                    let headimg=data.object(forKey: "headimg") as! String?//data["headimg"].stringValue
                    let gradeName=data.object(forKey: "GradeName") as! String?//data["GradeName"].stringValue
                    
                    let tmpName=gradeName?.replacingOccurrences(of: "会员", with: "代理会员")
                    StrongSelf.mainView.My_job.text = loadLanguage(tmpName!)
                    
                    if !((headimg?.contains("http://"))! || (headimg?.contains("https://"))!)
                    {
                        StrongSelf.mainView.My_head.image=UIImage(named: "DefaultHeadImage")
                    }
                    else{
                        StrongSelf.mainView.My_head.image=UIImage(data: try! Data(contentsOf: URL(string: headimg!)!))
                    }
                    StrongSelf.mainView.My_login.isEnabled=false
                }
            }
        }
        
    }
    
    
    //跳转
    func toURL(_ button:UIButton)
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
        self.present(tmpURLController, animated: true, completion: nil)
        
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
        self.performSegue(withIdentifier: "showEquids", sender: self)
    }
    //我的好友
    func My_FriendsClick()
    {
        UserDefaults.standard.setValue(0, forKey: "OtherAcceptMeNews")
        updateFriendCount()
        self.performSegue(withIdentifier: "showFriends", sender: self)
    }
    //我要提意见
    func Suggest()
    {
        self.performSegue(withIdentifier: "showSuggest", sender: self)
    }
    //设置
    func SetApp()
    {
        self.performSegue(withIdentifier: "showSet", sender: self)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //我的设备数量
        if  (UserDefaults.standard.object(forKey: CURRENT_LOGIN_STYLE) as! NSString).isEqual(to: LoginByPhone) {
            let devices=OznerManager.instance().getDevices() as [AnyObject?]
            mainView.My_EquipCount.text="\(devices.count)"
            self.navigationController?.isNavigationBarHidden=true
            (CustomTabBarView.sharedCustomTabBar() as AnyObject).showAllMyTabBar()
        } else {
            self.navigationController?.isNavigationBarHidden=false
            self.title = loadLanguage("个人设置")
            let leftButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_back@2x"), style: UIBarButtonItemStyle.done, target: self, action: #selector(leftMethod))
            leftButton.tintColor = UIColor.darkGray
            self.navigationItem.leftBarButtonItem = leftButton;
        }
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

