//
//  RNGetSystemInfo.swift
//  OZner
//
//  Created by 婉卿容若 on 16/7/26.
//  Copyright © 2016年 sunlinlin. All rights reserved.
//  容若的简书地址:http://www.jianshu.com/users/274775e3d56d/latest_articles
//  容若的新浪微博:http://weibo.com/u/2946516927?refer_flag=1001030102_&is_hot=1

/*
 * 获取系统级信息
 */

import UIKit

class RNGetSystemInfo: NSObject {
    
    // 单例
    fileprivate static let sharedInstance = RNGetSystemInfo()
    class var sharedManager: RNGetSystemInfo {
        
        return sharedInstance
    }
    
    // 获取当前设备的系统语言
    // 中文 - zh-Hans-CN
    
    func getCurrentSystemLanguage() -> String{
        
        let languages = Locale.preferredLanguages
        let currentLanguage = languages[0]
        
        return currentLanguage
    }
    

}
