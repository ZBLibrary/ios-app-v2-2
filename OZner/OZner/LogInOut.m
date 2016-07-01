//
//  LogInOut.m
//  BlackRoom
//
//  Created by Mac Mini 1 on 14-10-14.
//  Copyright (c) 2014年 sunlinlin. All rights reserved.
//

#import "LogInOut.h"
#import "LoginWerbService.h"
#import "LoginManager.h"
#import <string.h>
#import "OZner-swift.h"
static LogInOut* g_LoginInOutManager = nil;

@implementation LogInOut
@synthesize logInoutDelegate;

+(LogInOut*)loginInOutInstance
{
    if(g_LoginInOutManager == nil)
    {
        g_LoginInOutManager = [[LogInOut alloc] init];
    }
    
    return g_LoginInOutManager;
}

//登录
- (void)loginWithAccount:(NSString*)loginName
                password:(NSString*)password
             currentView:(UIView*)currentView
{
    LoginWerbService* werbservice = [[LoginWerbService alloc]init];
    
    [werbservice login:loginName psw:password returnBlock:^(LoginUserInfo *userInfo, StatusManager *status) {
        
        if(status.networkStatus == kSuccessStatus)
        {
            //成功获取到用户信息，成功更新那个百度设备号，才算登录成功
            //获取到用户信息
            //更新用户心里面的百度设备号
            [[NetworkManager sharedInstance] startWithAid:nil sesToken:userInfo.sessionToken httpAdress:HTTP_ADDRESS];
            [[NSUserDefaults standardUserDefaults] setObject:userInfo.sessionToken forKey:@"UserToken"];
//            updateUserInfozb* update=[[updateUserInfozb alloc] init];
//            [update bindBaiDu:^(BOOL istrue) {
//                if (istrue) {
//                    NSLog(@"%@",self.logInoutDelegate);
                    if(self.logInoutDelegate && [self.logInoutDelegate respondsToSelector:@selector(onLoginSuccess: currentView:)])
                    {
                        
                        [self.logInoutDelegate onLoginSuccess:userInfo currentView:currentView];
                        
                    }
                    
//                }
//                else
//                {
//                    if(self.logInoutDelegate && [self.logInoutDelegate respondsToSelector:@selector(onLoginFailed:currentView:)])
//                    {
//                        [LoginManager loginInstance].loginInfo.loginName = nil;
//                        [LoginManager loginInstance].loginInfo.password = nil;
//                        [LoginManager loginInstance].loginInfo.sessionToken = nil;
//                        [LoginManager loginInstance].loginInfo.userID = nil;
//                        [[LoginManager loginInstance]encodeParamObject];
//                        
//                        
//                        [self.logInoutDelegate onLoginFailed:status.errDesc currentView:currentView];
//                    }
//                }
            //}];
        }
        else
        {
            if(self.logInoutDelegate && [self.logInoutDelegate respondsToSelector:@selector(onLoginFailed:currentView:)])
            {
                [self.logInoutDelegate onLoginFailed:status.errDesc currentView:currentView];
            }
        }
        
    }];
}

//登陆成功
- (void)loginSuccess:(UIView*)currentView
{
    if(self.logInoutDelegate && [self.logInoutDelegate respondsToSelector:@selector(onLoginSuccess: currentView:)])
    {
        [self.logInoutDelegate onLoginSuccess:[[LoginManager loginInstance]loginInfo] currentView:currentView];
    }
}

- (void)loginFailed:(UIView*)currentView
{
    if(self.logInoutDelegate && [self.logInoutDelegate respondsToSelector:@selector(onLoginFailed:currentView:)])
    {
        [self.logInoutDelegate onLoginFailed:0 currentView:currentView];
    }
}
//不登陆
- (void)noNeedLogin:(UIView*)currentView
{
    if(self.logInoutDelegate && [self.logInoutDelegate respondsToSelector:@selector(onNoNeedLogin:)])
    {
        [self.logInoutDelegate onNoNeedLogin:currentView];
    }
}

// 登出
- (void)loginOutUser
{
    if(self.logInoutDelegate && [self.logInoutDelegate respondsToSelector:@selector(onLogout)])
    {
        [self.logInoutDelegate onLogout];
    }
}

- (void)dealloc
{
    [super dealloc];
}

@end
