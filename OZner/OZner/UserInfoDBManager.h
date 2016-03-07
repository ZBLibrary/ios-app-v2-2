//
//  UserInfoDBManager.h
//  OZner
//
//  Created by Mac Mini 1 on 15/12/26.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoDBManager : NSObject

//添加用户信息
- (BOOL)addUserInfo:(UserInfo*)userInfo;
//根据userId查询用户信息
- (UserInfo*)queryUserInfoByUserId:(NSString*)userId;

//添加用户头像昵称信息
- (BOOL)addUserNickImgInfo:(UserNickImgInfo*)userInfo;
//根据mobile查询用户头像昵称信息
- (UserNickImgInfo*)queryUserNickImgInfoByMobile:(NSString*)mobile;

@end
