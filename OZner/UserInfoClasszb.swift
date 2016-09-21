//
//  UserInfoClasszb.swift
//  OZner
//
//  Created by 赵兵 on 16/1/23.
//  Copyright © 2016年 sunlinlin. All rights reserved.
//

import Foundation
import UIKit
typealias sendValueClosure=(_ string:Bool)->Void
class updateUserInfozb: NSObject,UIAlertViewDelegate {
    
    //声明一个闭包
    var myClosure:sendValueClosure?
    //下面这个方法需要传入上个界面的someFunctionThatTakesAClosure函数指针
 
    func bindBaiDu(_ closure:sendValueClosure?){
        //将函数指针赋值给myClosure闭包，该闭包中涵盖了someFunctionThatTakesAClosure函数中的局部变量等的引用
        myClosure = closure
        BPush.bindChannel { (result, error) -> Void in
            self.updateUserInfozb()
        }
    }

    //更新用户信息
    func updateUserInfozb()
    {
        let webServer=MyInfoWerbservice()
        webServer.updateUserInfo(["device_id"], valueArr: [BPush.getChannelId()], return: { (data, status) -> Void in
            
            if status?.networkStatus == kSuccessStatus
            {
                
                let state=(data as AnyObject).object(forKey: "state") as! Int
                if state>0
                {
                    self.myClosure!(true)
                    self.getWXUserInfo()
                    self.getuserOtherInfo()
                }
                else
                {
                    //判空
                    if (self.myClosure != nil){
                        //闭包隐式调用someFunctionThatTakesAClosure函数：回调。
                        self.myClosure!(false)
                    }
                }
                
            }
            else
            {
                //判空
                if (self.myClosure != nil){
                    //闭包隐式调用someFunctionThatTakesAClosure函数：回调。
                    self.myClosure!(false)
                }
            }
        })
       
    }

    func getWXUserInfo()
    {
        //获取用户信息
        let webServer=MyInfoWerbservice()
        webServer.getUserInfo { (userData, status) -> Void in
            if status?.networkStatus == kSuccessStatus
            {
                let userdata = userData as AnyObject
                let state=userdata.object(forKey: "state") as! Int
                if state>0
                {
                    let data1=userdata.object(forKey: "userinfo") as! NSDictionary
                    let tmpdic=NSMutableDictionary()
                    
                    var tmpTmp=(data1.object(forKey: "NickName") == nil) ? "":data1.object(forKey: "NickName")
                    tmpdic.setValue(tmpTmp, forKey: "NickName")
                    tmpTmp=(data1.object(forKey: "ImgPath") == nil) ? "":data1.object(forKey: "ImgPath")
                    tmpdic.setValue(tmpTmp, forKey: "ImgPath")
                    tmpTmp=(data1.object(forKey: "UserTalkCode") == nil) ? "":data1.object(forKey: "UserTalkCode")
                    tmpdic.setValue(tmpTmp, forKey: "UserTalkCode")
                    tmpTmp=(data1.object(forKey: "Language") == nil) ? "":data1.object(forKey: "Language")
                    tmpdic.setValue(tmpTmp, forKey: "Language")
                    tmpTmp=(data1.object(forKey: "Area") == nil) ? "":data1.object(forKey: "Area")
                    tmpdic.setValue(tmpTmp, forKey: "Area")
                    tmpTmp=(data1.object(forKey: "UserId") == nil) ? "":data1.object(forKey: "UserId")
                    tmpdic.setValue(tmpTmp, forKey: "UserId")
                    setPlistData(tmpdic, fileName: "userinfoURL")

                }
                
            }

            
        }
    }
    func getuserOtherInfo()
    {
        let webServer=MyInfoWerbservice()
        print(get_Phone())
        webServer.getUserNickImage([get_Phone()], return: { (data, status) -> Void in
            if status?.networkStatus == kSuccessStatus
            {
                print(data)
                let state=data?.object(forKey: "state") as! Int
                if state>0
                {
                    
                    let data1=(data?.object(forKey: "data") as AnyObject).object(at: 0) as! NSMutableDictionary
                    print(data)
                    setPlistData(data1, fileName: "userinfoImg")
                }
            }
        })
    }
   
}
