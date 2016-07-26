//
//  AppDelegate.swift
//  OZner
//
//  Created by Mac Mini 1 on 15/11/29.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

import UIKit
var appDelegate: AppDelegate {
    return UIApplication.sharedApplication().delegate as! AppDelegate
}
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate ,WXApiDelegate,UIAlertViewDelegate {

    var window: UIWindow?
    
    /// 网络状态
    var reachOfNetwork:Reachability?
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Override point for customization after application launch.
        
        NetworkManager.sharedInstance().startWithAid(nil, sesToken: nil, httpAdress: HTTP_ADDRESS) 
        let switchController = SwitchViewController(nibName: "SwitchViewController", bundle: nil)
        // myTabController
        self.window?.backgroundColor = UIColor(red: 236.0, green: 238.0, blue: 241.0, alpha: 1.0)
        self.window?.rootViewController = switchController;
        self.window?.makeKeyAndVisible()
        
        
        
        //注册微信
        //WXApi.registerApp("wx45a8cc642a2295b5", withDescription: "haoze")
        //百度推送
        // iOS8 下需要使用新的 API
        //let tmpStr=UIDevice.currentDevice().systemVersion
        
        //let fullNameArr = (tmpStr as NSString).substringToIndex(1)
        
        //print(fullNameArr)
//        if (Float(fullNameArr) >= 8.0){
//            //3.创建UIUserNotificationSettings，并设置消息的显示类类型
//            var myTypes=UIUserNotificationType()
//            myTypes.insert(UIUserNotificationType.Sound)
//            myTypes.insert(UIUserNotificationType.Badge)
//            myTypes.insert(UIUserNotificationType.Alert)
//            let userSetting = UIUserNotificationSettings(forTypes:myTypes, categories:nil)
//            
//            UIApplication.sharedApplication().registerUserNotificationSettings(userSetting)
//        }
//        else {
//            
//            var myTypes:UIRemoteNotificationType = UIRemoteNotificationType()
//            myTypes.insert(UIRemoteNotificationType.Alert)
//            myTypes.insert(UIRemoteNotificationType.Sound)
//            
//            UIApplication.sharedApplication().registerForRemoteNotificationTypes(myTypes)
//        }

        
        //BPush.registerChannel(launchOptions, apiKey: "7nGBGzSxkIgjpEHHusrgdobS", pushMode: BPushMode.Production, withFirstAction: nil, withSecondAction: nil, withCategory: nil, isDebug: true)
        //Bugly记录第三方库
        CrashReporter.sharedInstance().installWithAppId("900034009")
        //app图标
        UIApplication.sharedApplication().applicationIconBadgeNumber=0
        //设置启动页面时间
        NSThread.sleepForTimeInterval(2)
        //检查网络状况，无网络，wifi，普通网络三种情况实时变化通知
        reachOfNetwork = Reachability(hostName: "www.baidu.com")
        reachOfNetwork!.startNotifier()
        
        return true
    }
    


    //微信 star
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        return  WXApi.handleOpenURL(url, delegate: self)
    }
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        
        let isSuc = WXApi.handleOpenURL(url, delegate: self)
        print("url \(url) isSuc \(isSuc == true ? 1 : 0)")
        return  isSuc
    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        application.registerForRemoteNotifications()
    }
   
    func onReq(req: BaseReq!) {
      
        if(req.isKindOfClass(GetMessageFromWXReq.classForCoder()))
        {
            // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
            let strTitle = loadLanguage("微信请求App提供内容")
            let strMsg = loadLanguage("微信请求App提供内容，App要调用sendResp:GetMessageFromWXResp返回给微信")
            
            let alert = UIAlertView(title: strTitle, message: strMsg, delegate: self, cancelButtonTitle: "ok")
            
            alert.show()
            
        }
        else if(req.isKindOfClass(ShowMessageFromWXReq.classForCoder()))
        {
            let temp = req as! ShowMessageFromWXReq
            let msg:WXMediaMessage = temp.message
            
            //显示微信传过来的内容
            let obj = msg.mediaObject as! WXAppExtendObject
            
            let strTitle = loadLanguage("微信请求App显示内容")
            let strMsg = "\(loadLanguage("标题："))\(msg.title) \n \(loadLanguage("内容: "))：\(msg.title) \n \(loadLanguage("附带信息："))\(msg.description)\n \(loadLanguage("缩略图:"))\(msg.thumbData.length) bytes\n\n\(obj)"
            
            let alert = UIAlertView(title: strTitle, message: strMsg, delegate: self, cancelButtonTitle: "ok")
            
            alert.show()
            
        }
        else if(req.isKindOfClass(LaunchFromWXReq.classForCoder()))
        {
            //从微信启动App
            let strTitle = loadLanguage("从微信启动")
            let strMsg = loadLanguage("这是从微信启动的消息")
            
            let alert = UIAlertView(title: strTitle, message: strMsg, delegate: self, cancelButtonTitle: "ok")
            
            alert.show()
        }
    
    }
    
    func onResp(resp: BaseResp!) {
    
    }
    //微信 end
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        print("deviceToken:\(deviceToken)")
        BPush.registerDeviceToken(deviceToken)// 必须
        BPush.bindChannelWithCompleteHandler({ (result:AnyObject!, error:NSError!) -> Void in
            if ((result) != nil) {
                print(result)
                BPush.setTag("Mytag", withCompleteHandler: { (result:AnyObject!, error:NSError!) -> Void in
                    if ((result) != nil) {
                        NSLog("")
                    }
                })
            }
        })
    }
    
    // 当 DeviceToken 获取失败时，系统会回调此方法
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("DeviceToken 获取失败:\(error)")
        print("DeviceToken 获取失败:\(error)")
    }
    // 此方法是 用户点击了通知，应用在前台 或者开启后台并且应用在后台 时调起
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        completionHandler(UIBackgroundFetchResult.NewData)
        // 打印到日志 textView 中
        print(userInfo)
        //var userinfoString:String=""
//        var action_baidu=""
//        var data_baidu=""
//        for (k,v) in userInfo
//        {
//            if k == "action"
//            {
//                action_baidu=v as! String
//            }
//            
//            if k == "data"
//            {
//                data_baidu=v.isKindOfClass(NSNull)==true ? "":(v as! String)
//            }
//        }
//        UIApplication.sharedApplication().applicationIconBadgeNumber=0
//        // 应用在前台 或者后台开启状态下
//        if application.applicationState == UIApplicationState.Background || application.applicationState == UIApplicationState.Active
//        {
//            print("acitve or background")
//            let tmpIndex=CustomTabBarView.sharedCustomTabBar().currentSelectEdIndex_ZB
//            if action_baidu=="chat"&&(tmpIndex != 2)
//            {
//                let badgeLabel=(CustomTabBarView.sharedCustomTabBar().badgeMuArr as NSMutableArray).objectAtIndex(2) as! UILabel
//                let tmpstr=Int(badgeLabel.text! as String)
//                badgeLabel.text="\(tmpstr!+1)"
//                badgeLabel.hidden=false
//            }
//            
//        }
//        else//杀死状态下，直接跳转到跳转页面。
//        {
//            //跳转到聊天界面
//            if action_baidu=="chat"
//            {
//                let array=CustomTabBarView.sharedCustomTabBar().btnMuArr as NSMutableArray
//                let button=array.objectAtIndex(2) as! UIButton
//                CustomTabBarView.sharedCustomTabBar().touchDownAction(button)
//            }
//        }
//        if action_baidu=="chat"
//        {
//             saveChatMessage(data_baidu)
//             NSNotificationCenter.defaultCenter().postNotificationName("receiveMessageFromKF", object: nil, userInfo: userInfo)
//        }
//        if action_baidu=="NewFriend"
//        {
//            //别人接受我的请求－－－－通知
//            NSUserDefaults.standardUserDefaults().setValue(1, forKey: "OtherAcceptMeNews")
//            NSNotificationCenter.defaultCenter().postNotificationName("OtherAcceptMeNews", object: nil, userInfo: userInfo)
//        }
//        if action_baidu=="NewFriendVF"
//        {
//            //别人请求添加我为好友 －－－通知
//
//            let newFriendCount=(NSUserDefaults.standardUserDefaults().objectForKey("OtherRequestNews")==nil ? 0:NSUserDefaults.standardUserDefaults().objectForKey("OtherRequestNews")) as! Int
//            NSUserDefaults.standardUserDefaults().setValue(newFriendCount+1, forKey: "OtherRequestNews")
//            NSNotificationCenter.defaultCenter().postNotificationName("OtherRequestNews", object: nil, userInfo: userInfo)
//        }
//        //个人中心新留言通知
//        if action_baidu=="NewMessage"
//        {
//            //let liuyanCount=(NSUserDefaults.standardUserDefaults().objectForKey("NewMessageCount")==nil ? 0:NSUserDefaults.standardUserDefaults().objectForKey("NewMessageCount")) as! Int
//            NSUserDefaults.standardUserDefaults().setInteger(1, forKey: "NewMessageCount")
//            NSNotificationCenter.defaultCenter().postNotificationName("MyCenterNewMessageNotice", object: nil, userInfo: userInfo)
//        }
//        //个人中心有新排名通知
//        if action_baidu=="NewRank"
//        {
//            print(userInfo)
//            print(userInfo)
//        }
//        //有登录通知
//        if action_baidu=="LoginNotify"
//        {
//            print(LoginManager.loginInstance().loginInfo)
//            print(data_baidu)
//            if LoginManager.loginInstance().loginInfo.userID==nil
//            {
//                return
//            }
//            if data_baidu.containsString(LoginManager.loginInstance().loginInfo.userID)
//            {
//                if data_baidu.containsString(LoginManager.loginInstance().loginInfo.sessionToken)
//                {
//                    
//                }
//                else
//                {
//                    //账号被人登录了
//                    let alert=UIAlertView(title: loadLanguage("提示"), message: loadLanguage("账号在另一台设备上登录了，请重新登录"), delegate: self, cancelButtonTitle: loadLanguage("确定"))
//                    alert.show()
//                    LogInOut.loginInOutInstance().loginOutUser()
//                }
//                
//            }
//            
//        }
    
    }
        
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        UIApplication.sharedApplication().applicationIconBadgeNumber=0
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        UIApplication.sharedApplication().applicationIconBadgeNumber=0
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

