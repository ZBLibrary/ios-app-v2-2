//
//  NetworkManager.m
//  BlackRoom
//
//  Created by Mac Mini 1 on 14-10-11.
//  Copyright (c) 2014年 sunlinlin. All rights reserved.
#import "NetworkManager.h"

static NetworkManager *networkManager = nil;

@implementation NetworkManager

+ (NetworkManager *) sharedInstance
{
    @synchronized(self)
    {
        if (networkManager == nil)
        {
            networkManager = [[NetworkManager alloc] init];
        }
    }
    return networkManager;
}

+ (id) allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if (networkManager == nil) {
            networkManager = [super allocWithZone:zone];
            return networkManager;
        }
    }
    return networkManager;
    
}

- (id)copyWithZone:(NSZone *)zone
{
    return networkManager;
}

- (id) init
{
    if (self = [super init])
    {
    }
    
    return self;
}

- (void)dealloc
{
    [_aid release];                 //当前手机应用唯 一ID, 不同手机系统Aid也不相同
    [_sessionToken release];        //小黑屋验证码
    [_httpAdress release];          //网络地址头
    [super dealloc];
}

- (void)startWithAid:(NSString *)aid sesToken:(NSString*)sesToken httpAdress:(NSString *)httpAdress
{
    [aid retain];[_aid release];_aid = aid;
    [sesToken retain];[_sessionToken release];_sessionToken = sesToken;
    [httpAdress retain];[_httpAdress release];_httpAdress = httpAdress;
}

@end
