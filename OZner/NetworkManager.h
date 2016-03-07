//
//  NetworkManager.h
//  BlackRoom
//
//  Created by Mac Mini 1 on 14-10-11.
//  Copyright (c) 2014年 sunlinlin. All rights reserved.

#import <Foundation/Foundation.h>

@interface NetworkManager : NSObject<NSCopying>

+ (NetworkManager *) sharedInstance;

@property (nonatomic, retain,readonly) NSString *aid;            //当前手机应用唯 一ID, 不同手机系统Aid也不相同
@property (nonatomic, retain,readonly) NSString *sessionToken;   //小黑屋验证码

@property (nonatomic, retain) NSString *httpAdress;     //通用网络地址头

//--------------------init once------------------------
//程序启动后，进行初始化一次
//aid       当前手机应用唯 一ID, 不同手机系统Aid也不相同
//sesToken   //小黑屋验证码
- (void)startWithAid:(NSString *)aid sesToken:(NSString*)sesToken httpAdress:(NSString *)httpAdress;

@end
