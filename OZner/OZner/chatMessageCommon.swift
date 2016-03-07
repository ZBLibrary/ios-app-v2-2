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
    let documentpaths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
    //获取完整路径
    let documentsDirectory=documentpaths[0] as NSString
    let plistPath = documentsDirectory.stringByAppendingPathComponent("ChatMessagePlist.plist")
    let tmpData=NSMutableDictionary(contentsOfFile: plistPath)
    let fileManager:NSFileManager = NSFileManager.defaultManager()
    if fileManager.fileExistsAtPath(plistPath)
    {
        do
        {
          try fileManager.removeItemAtPath(plistPath)
        }catch
        {}
    }else
    {
        return NSMutableDictionary()
    }
    return tmpData!
}

func saveChatMessage(mess:String)
{
    let documentpaths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
    //获取完整路径
    let documentsDirectory=documentpaths[0] as NSString
    let plistPath = documentsDirectory.stringByAppendingPathComponent("ChatMessagePlist.plist")
    let tmpdic:NSMutableDictionary=getChatMessage()
    tmpdic.setValue(mess, forKey: "\(tmpdic.count)")
    tmpdic.writeToFile(plistPath, atomically: false)
}