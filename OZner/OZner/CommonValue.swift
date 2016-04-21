//
//  File.swift
//  My
//
//  Created by test on 15/11/26.
//  Copyright © 2015年 HAOZE. All rights reserved.
//

import Foundation
import UIKit

let TDS_Good_zb:Int = 50
let TDS_Middle_zb:Int = 200

//主要颜色
let color_main=UIColor(red: 74/255, green: 180/255, blue: 233/255, alpha: 1)
let color_gray=UIColor(red: 149/255, green: 149/255, blue: 149/255, alpha: 1)
let color_sblue=UIColor(red: 2/255, green: 118/255, blue: 176/255, alpha: 1)
let color_black=UIColor(red: 98/255, green: 98/255, blue: 98/255, alpha: 1)

//RGB
let color_BT_bg_ed=UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
func RGBA (r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat)->UIColor {
    return UIColor (red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
}
//颜色转化

func UIColorFromRGB(rgbValue: UInt) -> UIColor {
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}
//rank:Int 排名,5
//type:Int 类型 0代表饮水量，1代表tds,0
//value:Int 饮水量值,200
//beat:Int 打败了35%,35
//maxWater:Int
class getshareImageClass:NSObject
{
    func getshareImagezb(rank:Int,type:Int,value:Int,beat:Int,maxWater:Int)->UIImage
    {
        let shareView=NSBundle.mainBundle().loadNibNamed("ShareView_zb", owner: nil, options: nil).last as! ShareView_zb
        shareView.share_rank.text="排名\(rank==0 ? 1:rank)"
        shareView.share_title.text=type==0 ? "当前饮水量为":"当前水质纯净值为"
        shareView.share_value.text="\(value)"+(type==0 ? "ml":"")
        shareView.share_beat.text="击败了\(beat>=100 ? 99:beat)％的用户"
        if type==0&&maxWater>0
        {
            let water=Double(value)/Double(maxWater)>1 ? 1:Double(value)/Double(maxWater)
            switch water
            {
            case 0..<0.3333:
                shareView.share_stateImage.image=UIImage(named: "share_Water1")
                break
            case 0.3333..<0.6666:
                shareView.share_stateImage.image=UIImage(named: "share_Water2")
                break
            case 0.6666...1:
                shareView.share_stateImage.image=UIImage(named: "share_Water3")
                break
            default:
                break
            }
            shareView.share_beat.text=""
        }
        else if type==1
        {
            switch value
            {
            case 0..<TDS_Good_zb:
                shareView.share_stateImage.image=UIImage(named: "share_TDS3")
                break
            case TDS_Good_zb..<TDS_Middle_zb:
                shareView.share_stateImage.image=UIImage(named: "share_TDS2")
                break
            case TDS_Middle_zb..<100000000:
                shareView.share_stateImage.image=UIImage(named: "share_TDS1")
                break
            default:
                break
            }
        }
        //获取用户头像
        
        let myinfo=getPlistData("userinfoImg") as NSMutableDictionary
        if myinfo.count>0
        {
            
            let  imgUrl=myinfo.objectForKey("headimg") as! String
            shareView.share_OwnerImage.image=imgUrl=="" ? UIImage(named: "shareOwnerimg"):UIImage(data: NSData(contentsOfURL: NSURL(string: imgUrl)!)!)
            shareView.share_OwnerName.text=myinfo.objectForKey("nickname") as? String
            if shareView.share_OwnerName.text==""
            {
                shareView.share_OwnerName.text="浩小泽"
            }
        }
        else
        {
            shareView.share_OwnerImage.image=UIImage(named: "shareOwnerimg")
            shareView.share_OwnerName.text="浩小泽"
        }
        UIGraphicsBeginImageContext(shareView.bounds.size)//  (myView.bounds.size);
        shareView.layer.renderInContext(UIGraphicsGetCurrentContext()!) //[myView.layer renderInContext:UIGraphicsGetCurrentContext()];
        let viewImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return viewImage
    }

}



//接口开头
let StarURL_New="http://app.ozner.net:888"//"http://ozner.bynear.cn"
//let StarURL_Old=""

//-------------------获取设备大小-------------------------
//NavBar高度
let NavigationBar_HEIGHT=64
let TabBar_HEIGHT=49

//获取屏幕 宽度、高度
let SCREEN_WIDTH:CGFloat=(UIScreen.mainScreen().bounds.size.width)
let SCREEN_HEIGHT:CGFloat=(UIScreen.mainScreen().bounds.size.height)

func dateStampToString(timeStamp:NSString,format:String)->NSString {
    //print(timeStamp)
    var tmpstr1=(timeStamp).substringFromIndex(6) as NSString
    tmpstr1=NSString(string: tmpstr1.substringToIndex(tmpstr1.length-2))
    let date:NSDate = NSDate(timeIntervalSince1970: tmpstr1.doubleValue/1000)
    //print(date)
    let dfmatter = NSDateFormatter()
    //let timeZone = NSTimeZone.localTimeZone() //timeZoneWithName:@"Asia/Shanghai"];
    dfmatter.dateFormat=format
    //dfmatter.timeZone=timeZone
    print(dfmatter.stringFromDate(date))
    return dfmatter.stringFromDate(date)
}
func dateFromString(dateStr:NSString,format:String)->NSDate {
    let dfmatter = NSDateFormatter()
    dfmatter.dateFormat=format
    var tmpDate=dfmatter.dateFromString(dateStr as String)!
    tmpDate=NSDate(timeIntervalSince1970: tmpDate.timeIntervalSince1970+8*3600)
    print(tmpDate)
    return tmpDate
}
func stringFromDate(date:NSDate,format:String)->NSString {
    let dfmatter = NSDateFormatter()
    dfmatter.dateFormat=format
    return dfmatter.stringFromDate(date)
}
//---------------------读取文件--------------------------

//获取和保存本地TDS_Rank
func get_localTDSRank(dataArray:NSMutableArray)->NSMutableDictionary
{
    let documentpaths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
    //获取完整路径
    let documentsDirectory=documentpaths[0] as NSString
    let plistPath = documentsDirectory.stringByAppendingPathComponent("localTDSRank.plist")
    let tmpData=NSMutableDictionary(contentsOfFile: plistPath)
    let Count=tmpData?.count
    for i in 0...dataArray.count
    {
        tmpData?.setValue(dataArray[i], forKey: String(Count))
    }
    print(tmpData)
    tmpData?.writeToFile(plistPath, atomically: false)
    return tmpData==nil ? NSMutableDictionary():tmpData!
}
//---------------------设置--------------------------
//是否容许推送
//func set_allowTSzb(allowTS:Bool)
//{
//    NSUserDefaults.standardUserDefaults().setValue(allowTS, forKey: "allowTSzb")
//}
//func get_allowTSzb()->Bool
//{
//    let tmpuserToken=NSUserDefaults.standardUserDefaults().objectForKey("allowTSzb")
//    let allowTS=tmpuserToken==nil ? true : tmpuserToken
//    
//    return (allowTS as! Bool)
//}

//-------------------是否登录-------------------------
func set_islogin(userToken:Bool)
{
    NSUserDefaults.standardUserDefaults().setValue(userToken, forKey: "islogin")
}
func get_islogin()->Bool
{
    let tmpuserToken=NSUserDefaults.standardUserDefaults().objectForKey("islogin")
    let userToken=tmpuserToken==nil ? false : tmpuserToken
    
    return (userToken as! Bool)
}

//-------------------检查手机号格式-------------------------
func checkTel(str:NSString)->Bool
{
    if (str.length != 11) {
        
        return false
    }
    
    
    let regex = "^\\d{11}$"
    let pred = NSPredicate(format: "SELF MATCHES %@",regex)
    
    let isMatch = pred.evaluateWithObject(str)
    if (!isMatch) {
        return false
    }
    
    return true
    
}

//--------------------多语言加载文字------------------------
func TextLoad(text:String) -> String
{
    return NSLocalizedString(text, comment: "")
}
func set_Phone(userToken:String)
{
    NSUserDefaults.standardUserDefaults().setValue(userToken, forKey: "Phone")
}
func get_Phone()->String
{
    let tmpuserToken=NSUserDefaults.standardUserDefaults().objectForKey("Phone")
    let userToken=tmpuserToken==nil ? "null" : tmpuserToken
    
    return (userToken as! String)
}

func set_headimg(userToken:String)
{
    NSUserDefaults.standardUserDefaults().setValue(userToken, forKey: "headimg")
}
func get_headimg()->String
{
    let tmpuserToken=NSUserDefaults.standardUserDefaults().objectForKey("headimg")
    let userToken=tmpuserToken==nil ? "" : tmpuserToken
    return (userToken as! String)
}

//--------------------访问接口凭证 UserToken set/get----------
func set_UserToken(userToken:String)
{
    NSUserDefaults.standardUserDefaults().setValue(userToken, forKey: "UserToken")
}
func get_UserToken()->String
{
    let tmpuserToken=NSUserDefaults.standardUserDefaults().objectForKey("UserToken")
    let userToken=tmpuserToken==nil ? "null" : tmpuserToken
    
    return (userToken as! String)
}




//－－－－－－－－－－－－－－－－－个人中心－>设置－－－－－－－－－－－－－－－－
//温度
func set_MyInfoSet(Temperature:Int,WaterMeter:Int)
{
    NSUserDefaults.standardUserDefaults().setInteger(Temperature, forKey: "MyInfo_Temperature")
    NSUserDefaults.standardUserDefaults().setInteger(WaterMeter, forKey: "MyInfo_WaterMeter")
}
func get_MyInfoSet()->(Int,Int)
{
    let tmpTemperature=NSUserDefaults.standardUserDefaults().objectForKey("MyInfo_Temperature")
    let Temperature=tmpTemperature==nil ? 0 : tmpTemperature
    let tmpWaterMeter=NSUserDefaults.standardUserDefaults().objectForKey("MyInfo_WaterMeter")
    let WaterMeter=tmpWaterMeter==nil ? 0 : tmpWaterMeter
    return ((Temperature as! Int),(WaterMeter as! Int))
}

let Url_test_Star="http://test.oznerwater.com/lktnew/wsrv/Handlcustomer.ashx?AccessToken=6201507a981afb4ZZ6ac698ed3dd86e1a76a3bb051703"
let Screen_Width=UIScreen.mainScreen().bounds.size.width
let Screen_Hight=UIScreen.mainScreen().bounds.size.height
//let K_Width=Screen_Width/375
//let K_Hight=Screen_Hight/667

func stateSwitch(state:Int)->String
{
    var errorstring=""
    switch(state)
    {
    case 0 :
        errorstring=""
        break
    default:
        break
    }
    return errorstring
}
