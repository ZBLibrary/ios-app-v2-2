//
//  LogInOut.h
//  BlackRoom
//
//  Created by Mac Mini 1 on 14-10-14.
//  Copyright (c) 2014年 sunlinlin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StatusManager.h"

@protocol LoginOutDelegate <NSObject>

@optional
- (void)onLoginSuccess:(LoginUserInfo*)loginUserInfo currentView:(UIView*)currentView;
- (void)onNoNeedLogin:(UIView*)currentView;
- (void)onLoginFailed:(NSString*)errorStr currentView:(UIView*)currentView;
- (void) onLogout;

@end

@interface LogInOut : NSObject<LoginOutDelegate>

@property (nonatomic,assign) id<LoginOutDelegate> logInoutDelegate;

+(LogInOut*)loginInOutInstance;

//登录 - 手机
- (void)loginWithAccount:(NSString*)loginName
                password:(NSString*)password
             currentView:(UIView*)currentView;
//登录 - 邮箱
- (void)loginWithEmail:(NSString*)loginName
                password:(NSString*)password
             currentView:(UIView*)currentView;

//登陆成功
- (void)loginSuccess:(UIView*)currentView;
- (void)loginFailed:(UIView*)currentView;
//不登陆
- (void)noNeedLogin:(UIView*)currentView;
// 登出
- (void)loginOutUser;

@end
