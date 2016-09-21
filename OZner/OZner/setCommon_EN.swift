//
//  setCommon_EN.swift
//  OZner
//
//  Created by test on 15/12/19.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

import Foundation

//------读取选择了那一个； 0代表哪个也没选  1 代表智能杯  2 代表水探头  3代表净水器 4 代表小空气净化器 5 代表大空气净化器---------
func set_CurrSelectEquip(_ CurrentEquip:Int)
{
    UserDefaults.standard.set(CurrentEquip, forKey: "CurrentSelectenEquip")
}
func get_CurrSelectEquip()->Int
{
    let tmpcurrentEquip=UserDefaults.standard.object(forKey: "CurrentSelectenEquip")
    let currentEquip=tmpcurrentEquip==nil ? 0 : tmpcurrentEquip
    
    return (currentEquip as! Int)
}

//存取plist文件
func getPlistData(_ fileName:String)->NSMutableDictionary
{
    let documentpaths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
    //获取完整路径
    let documentsDirectory=documentpaths[0] as NSString
    let plistPath = documentsDirectory.appendingPathComponent(fileName+".plist")
    var tmpData=NSMutableDictionary(contentsOfFile: plistPath)
    // print(setCupStructdata)
    if tmpData?.count==0||tmpData==nil
    {
        let bundle=Bundle.main
        //读取plist文件路径
        if let path=bundle.path(forResource: fileName, ofType: "plist")
        {
            tmpData=NSMutableDictionary(contentsOfFile: path)
        }
        else
        {
            return NSMutableDictionary()
        }
    }
    return tmpData!
}

func setPlistData(_ plistData:NSMutableDictionary,fileName:String)
{
    let documentpaths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
    //获取完整路径
    let documentsDirectory=documentpaths[0] as NSString
    let plistPath = documentsDirectory.appendingPathComponent(fileName+".plist")
    plistData.write(toFile: plistPath, atomically: true)
    print(plistData)
    let tmpData=NSMutableDictionary(contentsOfFile: plistPath) //(contentsOfFile: plistPath)
    print(tmpData)
    
}
