//
//  LoginWerbService.m
//  OZner
//
//  Created by Mac Mini 1 on 15/12/28.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

#import "LoginWerbService.h"
#import "WebAssistant.h"
#import "LoginManager.h"

@implementation LoginWerbService

//登录 -- 手机号
- (ASIFormDataRequest*)login:(NSString*)userName psw:(NSString*)psw returnBlock:(void(^)(LoginUserInfo* userInfo, StatusManager* status))handler
{
    NetworkEntrance* entrance = [[NetworkEntrance alloc]init];
    
    [entrance addObject:userName forKey:@"UserName"];
    [entrance addObject:psw forKey:@"PassWord"];
    [entrance addObject:[[[UIDevice currentDevice] identifierForVendor] UUIDString] forKey:@"miei"];
    [entrance addObject:[[UIDevice currentDevice] name] forKey:@"devicename"];
    [entrance addURLString:WERB_URL_LOGIN];
    
    return [WebAssistant execNormalkRequest:entrance bodyBlock:^(NSDictionary *dicBody, StatusManager *status) {
        [LoginManager loginInstance].loginInfo.loginName = userName;
        [LoginManager loginInstance].loginInfo.password = psw;
        [LoginManager loginInstance].loginInfo.sessionToken = [dicBody objectForKey:@"usertoken"];
        [LoginManager loginInstance].loginInfo.userID = [dicBody objectForKey:@"userid"];
        [[LoginManager loginInstance]encodeParamObject];
        handler([[LoginManager loginInstance]loginInfo],status);
    } failedBlock:^(StatusManager *status) {
        handler(nil,status);
    }];
}

// 登录 -- 邮箱
- (ASIFormDataRequest*)loginByEmail:(NSString*)userName psw:(NSString*)psw returnBlock:(void(^)(LoginUserInfo* userInfo, StatusManager* status))handler
{
    NetworkEntrance* entrance = [[NetworkEntrance alloc]init];
    
    [entrance addObject:userName forKey:@"username"];
    [entrance addObject:psw forKey:@"passWord"];
    [entrance addObject:[[[UIDevice currentDevice] identifierForVendor] UUIDString] forKey:@"miei"];
    [entrance addObject:[[UIDevice currentDevice] name] forKey:@"devicename"];
    [entrance addURLString:EMAIL_URL_LOGIN];
    
    return [WebAssistant execNormalkRequest:entrance bodyBlock:^(NSDictionary *dicBody, StatusManager *status) {
        [LoginManager loginInstance].loginInfo.loginName = userName;
        [LoginManager loginInstance].loginInfo.password = psw;
        [LoginManager loginInstance].loginInfo.sessionToken = [dicBody objectForKey:@"usertoken"];
        [LoginManager loginInstance].loginInfo.userID = [dicBody objectForKey:@"userid"];
        [[LoginManager loginInstance]encodeParamObject];
        handler([[LoginManager loginInstance]loginInfo],status);
    } failedBlock:^(StatusManager *status) {
        handler(nil,status);
    }];
}

@end
