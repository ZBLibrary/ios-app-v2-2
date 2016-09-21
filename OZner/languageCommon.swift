//
//  File.swift
//  OZner
//
//  Created by test on 15/12/28.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

import Foundation

func loadLanguage(_ text:String)->String
{
    return NSLocalizedString(text, comment: "")
}
//是否是手机号登录
func IsLoginByPhone() -> Bool {
    return (UserDefaults.standard.object(forKey: CURRENT_LOGIN_STYLE) as! NSString).isEqual(to: LoginByPhone)
}
        
