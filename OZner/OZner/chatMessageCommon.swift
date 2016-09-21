//
//  chatMessageCommon.swift
//  OZner
//
//  Created by test on 15/12/27.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

import Foundation

//存取plist文件
func getChatMessage()->NSMutableDictionary
{
    let documentpaths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
    //获取完整路径
    let documentsDirectory=documentpaths[0] as NSString
    let plistPath = documentsDirectory.appendingPathComponent("ChatMessagePlist.plist")
    let tmpData=NSMutableDictionary(contentsOfFile: plistPath)
    let fileManager:FileManager = FileManager.default
    if fileManager.fileExists(atPath: plistPath)
    {
        do
        {
          try fileManager.removeItem(atPath: plistPath)
        }catch
        {}
    }else
    {
        return NSMutableDictionary()
    }
    return tmpData!
}

func saveChatMessage(_ mess:String)
{
    let documentpaths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
    //获取完整路径
    let documentsDirectory=documentpaths[0] as NSString
    let plistPath = documentsDirectory.appendingPathComponent("ChatMessagePlist.plist")
    let tmpdic:NSMutableDictionary=getChatMessage()
    tmpdic.setValue(mess, forKey: "\(tmpdic.count)")
    tmpdic.write(toFile: plistPath, atomically: false)
}
