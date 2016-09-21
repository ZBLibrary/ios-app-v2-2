//
//  File.swift
//  My
//
//  Created by test on 15/11/26.
//  Copyright © 2015年 HAOZE. All rights reserved.
//

import Foundation
import UIKit

let TDS_Good_Int = Int(tds_good)//Tds
let TDS_Bad_Int = Int(tds_bad)

//主要颜色
let color_main=UIColor(red: 74/255, green: 180/255, blue: 233/255, alpha: 1)
let color_gray=UIColor(red: 149/255, green: 149/255, blue: 149/255, alpha: 1)
let color_sblue=UIColor(red: 2/255, green: 118/255, blue: 176/255, alpha: 1)
let color_black=UIColor(red: 98/255, green: 98/255, blue: 98/255, alpha: 1)

//RGB
let color_BT_bg_ed=UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
func RGBA (_ r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat)->UIColor {
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
    func getshareImagezb(_ rank:Int,type:Int,value:Int,beat:Int,maxWater:Int)->UIImage
    {
        let shareView=Bundle.main.loadNibNamed("ShareView_zb_EN", owner: nil, options: nil)?.last as! ShareView_zb_EN
        shareView.share_rank.text="\(loadLanguage("排名"))\(rank==0 ? 1:rank)"
        shareView.share_title.text=type==0 ? loadLanguage("当前饮水量为"):loadLanguage("当前水质纯净值为")
        shareView.share_value.text="\(value)"+(type==0 ? "ml":"")
        shareView.share_beat.text="\(loadLanguage("击败了"))\(beat>=100 ? 99:beat)％\(loadLanguage("的用户"))"
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
            case 0..<TDS_Good_Int:
                shareView.share_stateImage.image=UIImage(named: "share_TDS3")
                break
            case TDS_Good_Int..<TDS_Bad_Int:
                shareView.share_stateImage.image=UIImage(named: "share_TDS2")
                break
            case TDS_Bad_Int..<100000000:
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
            
            let  imgUrl=myinfo.object(forKey: "headimg") as! String
            shareView.share_OwnerImage.image=imgUrl=="" ? UIImage(named: "shareOwnerimg"):UIImage(data: try! Data(contentsOf: URL(string: imgUrl)!))
            shareView.share_OwnerName.text=myinfo.object(forKey: "nickname") as? String
            if shareView.share_OwnerName.text==""
            {
                shareView.share_OwnerName.text=loadLanguage("浩小泽")
            }
        }
        else
        {
            shareView.share_OwnerImage.image=UIImage(named: "shareOwnerimg")
            shareView.share_OwnerName.text = loadLanguage("浩小泽")
        }
        UIGraphicsBeginImageContext(shareView.bounds.size)//  (myView.bounds.size);
        shareView.layer.render(in: UIGraphicsGetCurrentContext()!) //[myView.layer renderInContext:UIGraphicsGetCurrentContext()];
        let viewImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return viewImage!
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
let SCREEN_WIDTH:CGFloat=(UIScreen.main.bounds.size.width)
let SCREEN_HEIGHT:CGFloat=(UIScreen.main.bounds.size.height)

func dateStampToString(_ timeStamp:String,format:String)->NSString {
    //print(timeStamp)
    let i1 = timeStamp.unicodeScalars.index(after: timeStamp.unicodeScalars.index(of: "(")!)
    let i2 = timeStamp.unicodeScalars.index(of: ")")!
    
    let substring = timeStamp.unicodeScalars[i1..<i2]
    let tmpstr=String(describing: substring.description)
    //有问题
    let date:Date = Date(timeIntervalSince1970: Double(tmpstr)!/1000)
    let dfmatter = DateFormatter()
        dfmatter.dateFormat=format
    
    print(dfmatter.string(from: date))
    return dfmatter.string(from: date) as NSString
}
func dateFromString(_ dateStr:NSString,format:String)->Date {
    let dfmatter = DateFormatter()
    dfmatter.dateFormat=format
    var tmpDate=dfmatter.date(from: dateStr as String)!
    tmpDate=Date(timeIntervalSince1970: tmpDate.timeIntervalSince1970+8*3600)
    print(tmpDate)
    return tmpDate
}
func stringFromDate(_ date:Date,format:String)->NSString {
    let dfmatter = DateFormatter()
    dfmatter.dateFormat=format
    return dfmatter.string(from: date) as NSString
}
//---------------------读取文件--------------------------

//获取和保存本地TDS_Rank
func get_localTDSRank(_ dataArray:NSMutableArray)->NSMutableDictionary
{
    let documentpaths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
    //获取完整路径
    let documentsDirectory=documentpaths[0] as NSString
    let plistPath = documentsDirectory.appendingPathComponent("localTDSRank.plist")
    let tmpData=NSMutableDictionary(contentsOfFile: plistPath)
    let Count=tmpData?.count
    for i in 0...dataArray.count
    {
        tmpData?.setValue(dataArray[i], forKey: String(describing: Count))
    }
    print(tmpData)
    tmpData?.write(toFile: plistPath, atomically: false)
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
func set_islogin(_ userToken:Bool)
{
    UserDefaults.standard.setValue(userToken, forKey: "islogin")
}
func get_islogin()->Bool
{
    let tmpuserToken=UserDefaults.standard.object(forKey: "islogin")
    let userToken=tmpuserToken==nil ? false : tmpuserToken
    
    return (userToken as! Bool)
}

//-------------------检查手机号格式-------------------------
func checkTel(_ str:NSString)->Bool
{
    if (str.length != 11) {
        
        return false
    }
    
    
    let regex = "^\\d{11}$"
    let pred = NSPredicate(format: "SELF MATCHES %@",regex)
    
    let isMatch = pred.evaluate(with: str)
    if (!isMatch) {
        return false
    }
    
    return true
    
}

//--------------------多语言加载文字------------------------
func TextLoad(_ text:String) -> String
{
    return NSLocalizedString(text, comment: "")
}
func set_Phone(_ userToken:String)
{
    UserDefaults.standard.setValue(userToken, forKey: "Phone")
}
func get_Phone()->String
{
    let tmpuserToken=UserDefaults.standard.object(forKey: "Phone")
    let userToken=tmpuserToken==nil ? "null" : tmpuserToken
    
    return (userToken as! String)
}

func set_headimg(_ userToken:String)
{
    UserDefaults.standard.setValue(userToken, forKey: "headimg")
}
func get_headimg()->String
{
    let tmpuserToken=UserDefaults.standard.object(forKey: "headimg")
    let userToken=tmpuserToken==nil ? "" : tmpuserToken
    return (userToken as! String)
}

//--------------------访问接口凭证 UserToken set/get----------
func set_UserToken(_ userToken:String)
{
    UserDefaults.standard.setValue(userToken, forKey: "UserToken")
}
func get_UserToken()->String
{
    let tmpuserToken=UserDefaults.standard.object(forKey: "UserToken")
    let userToken=tmpuserToken==nil ? "null" : tmpuserToken
    
    return (userToken as! String)
}




//－－－－－－－－－－－－－－－－－个人中心－>设置－－－－－－－－－－－－－－－－
//温度
func set_MyInfoSet(_ Temperature:Int,WaterMeter:Int)
{
    UserDefaults.standard.set(Temperature, forKey: "MyInfo_Temperature")
    UserDefaults.standard.set(WaterMeter, forKey: "MyInfo_WaterMeter")
}
func get_MyInfoSet()->(Int,Int)
{
    let tmpTemperature=UserDefaults.standard.object(forKey: "MyInfo_Temperature")
    let Temperature=tmpTemperature==nil ? 0 : tmpTemperature
    let tmpWaterMeter=UserDefaults.standard.object(forKey: "MyInfo_WaterMeter")
    let WaterMeter=tmpWaterMeter==nil ? 0 : tmpWaterMeter
    return ((Temperature as! Int),(WaterMeter as! Int))
}

let Screen_Width=UIScreen.main.bounds.size.width
let Screen_Hight=UIScreen.main.bounds.size.height
//let K_Width=Screen_Width/375
//let K_Hight=Screen_Hight/667

func stateSwitch(_ state:Int)->String
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
