//
//  MyInfoWerbservice.h
//  OZner
//
//  Created by test on 15/11/30.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConnectUtil.h"
#import "StatusManager.h"

@interface MyInfoWerbservice : NSObject

//获取用户信息  UserInfo* userInfo
- (ASIFormDataRequest*)getUserInfo:(void(^)(id userInfo, StatusManager* status))handle;
//获取用户昵称图片信息
- (ASIFormDataRequest*)getUserNickImage:(NSArray*)mobileArr returnBlock:(void(^)(NSMutableDictionary* userInfoArr, StatusManager* status))handle;
//更新用户信息
- (ASIFormDataRequest*)updateUserInfo:(NSArray*)keyArr valueArr:(NSArray*)valueArr returnBlock:(void(^)(id data,StatusManager* status))handle;

@end
