//
//  UserInfoClasszb.swift
//  OZner
//
//  Created by 赵兵 on 16/1/23.
//  Copyright © 2016年 sunlinlin. All rights reserved.
//

import Foundation
import UIKit
typealias sendValueClosure=(string:Bool)->Void
class updateUserInfozb: NSObject,UIAlertViewDelegate {
    
    //声明一个闭包
    var myClosure:sendValueClosure?
    //下面这个方法需要传入上个界面的someFunctionThatTakesAClosure函数指针
 
    func bindBaiDu(closure:sendValueClosure?){
        //将函数指针赋值给myClosure闭包，该闭包中涵盖了someFunctionThatTakesAClosure函数中的局部变量等的引用
        myClosure = closure
        BPush.bindChannelWithCompleteHandler { (result:AnyObject!, error:NSError!) -> Void in
            print(BPush.getChannelId())
            print("Method: \(BPushRequestMethodBind)\n\(result)")
            self.updateUserInfozb()
        }
    }
    func unbindBaiDu() {
        BPush.unbindChannelWithCompleteHandler { (result:AnyObject!, error:NSError!) -> Void in
            print("Method: \(BPushRequestMethodUnbind)\n\(result)")
        }
        
        
    }

    //更新用户信息
    func updateUserInfozb()
    {
        let webServer=MyInfoWerbservice()
        webServer.updateUserInfo(["device_id"], valueArr: [BPush.getChannelId()], returnBlock: { (data:AnyObject!, status:StatusManager!) -> Void in
            
            if status.networkStatus == kSuccessStatus
            {
                
                let state=data.objectForKey("state") as! Int
                if state>0
                {
                    self.getWXUserInfo()
                }
                else
                {
                    //判空
                    if (self.myClosure != nil){
                        //闭包隐式调用someFunctionThatTakesAClosure函数：回调。
                        self.myClosure!(string: false)
                    }
                }
                
            }
            else
            {
                //判空
                if (self.myClosure != nil){
                    //闭包隐式调用someFunctionThatTakesAClosure函数：回调。
                    self.myClosure!(string: false)
                }
            }
        })
       
    }

    func getWXUserInfo()
    {
        //获取用户信息
        let webServer=MyInfoWerbservice()
        webServer.getUserInfo { (userdata:AnyObject!, status:StatusManager!) -> Void in
            if status.networkStatus == kSuccessStatus
            {
            
                let state=userdata.objectForKey("state") as! Int
                    if state>0
                    {
                        let data1=userdata.objectForKey("userinfo") as! NSDictionary
                        let tmpdic=NSMutableDictionary()
                        print(data1)
                        print(data1.allValues)
                        print(data1.objectForKey("NickName"))
                        var tmpTmp=((data1.objectForKey("NickName")?.isKindOfClass(NSNull)) == true) ? "":data1.objectForKey("NickName")
                        tmpdic.setValue(tmpTmp, forKey: "NickName")
                        tmpTmp=((data1.objectForKey("ImgPath")?.isKindOfClass(NSNull)) == true) ? "":data1.objectForKey("ImgPath")
                        tmpdic.setValue(tmpTmp, forKey: "ImgPath")
                        tmpTmp=((data1.objectForKey("UserTalkCode")?.isKindOfClass(NSNull)) == true) ? "":data1.objectForKey("UserTalkCode")
                        tmpdic.setValue(tmpTmp, forKey: "UserTalkCode")
                        tmpTmp=((data1.objectForKey("Language")?.isKindOfClass(NSNull)) == true) ? "":data1.objectForKey("Language")
                        tmpdic.setValue(tmpTmp, forKey: "Language")
                        tmpTmp=((data1.objectForKey("Area")?.isKindOfClass(NSNull)) == true) ? "":data1.objectForKey("Area")
                        tmpdic.setValue(tmpTmp, forKey: "Area")
                        tmpTmp=((data1.objectForKey("UserId")?.isKindOfClass(NSNull)) == true) ? "":data1.objectForKey("UserId")
                        tmpdic.setValue(tmpTmp, forKey: "UserId")
                        setPlistData(tmpdic, fileName: "userinfoURL")
                        //判空
                        if (self.myClosure != nil){
                            //闭包隐式调用someFunctionThatTakesAClosure函数：回调。
                            self.myClosure!(string: true)
                            //后台下载用户信息
                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), { () -> Void in
                                self.getuserOtherInfo()
                            })
                            
                            
                        }
                       
                    }
                    else
                    {
                        //判空
                        if (self.myClosure != nil){
                            //闭包隐式调用someFunctionThatTakesAClosure函数：回调。
                            self.myClosure!(string: false)
                        }
                }
                
                
            }
            else
            {
                //判空
                if (self.myClosure != nil){
                    //闭包隐式调用someFunctionThatTakesAClosure函数：回调。
                    self.myClosure!(string: false)
                }
            }
            
        }
    }
    func getuserOtherInfo()
    {
        let webServer=MyInfoWerbservice()
        webServer.getUserNickImage([get_Phone()], returnBlock: { (data:NSMutableDictionary!, status:StatusManager!) -> Void in
            if status.networkStatus == kSuccessStatus
            {
                
                let state=data.objectForKey("state") as! Int
                if state>0
                {
                    
                    let data1=data.objectForKey("data")?.objectAtIndex(0) as! NSMutableDictionary
                    print(data)
                    setPlistData(data1, fileName: "userinfoImg")
                }
            }
        })
    }
   
}