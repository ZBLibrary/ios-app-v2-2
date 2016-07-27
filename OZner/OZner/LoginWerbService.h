//
//  LoginWerbService.h
//  OZner
//
//  Created by Mac Mini 1 on 15/12/28.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConnectUtil.h"
#import "StatusManager.h"

@interface LoginWerbService : NSObject

//登录 - 手机号
- (ASIFormDataRequest*)login:(NSString*)userName psw:(NSString*)psw returnBlock:(void(^)(LoginUserInfo* userInfo, StatusManager* status))handler;

//登录 - 邮箱
- (ASIFormDataRequest*)loginByEmail:(NSString*)userName psw:(NSString*)psw returnBlock:(void(^)(LoginUserInfo* userInfo, StatusManager* status))handler;

@end
