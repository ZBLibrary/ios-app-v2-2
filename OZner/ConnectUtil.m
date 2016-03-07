//
//  ConnectUtil.m
//  BlackRoom
//
//  Created by Mac Mini 1 on 14-10-11.
//  Copyright (c) 2014年 sunlinlin. All rights reserved.

#import "ConnectUtil.h"
#import "ASIFormDataRequest.h"

#define TIMEOUT 15

@implementation ConnectUtil

//网络请求
+ (ASIFormDataRequest *)request:(REQUESTTYPE)requestType NetworkEntrance:(NetworkEntrance *)networkEntrance returnBlock:(void(^)(NSData *data,BOOL bISsuccess))handler
{
    __block ASIFormDataRequest* request;
    
    if (requestType == kCustomRequest) {
        request = [ConnectUtil fetcherWithURLString:[networkEntrance urlStringFromEntrance] dataParams:[networkEntrance postDataFromEntrance] fileParams:[networkEntrance fileArrFromEntrance]];
    
    }
    else
    {
        request = [ConnectUtil fetcherWithURLString:[networkEntrance urlStringFromEntrance] dicParams:[networkEntrance bodyDicFromEntrance] fileParams:[networkEntrance fileArrFromEntrance]];
    }
    [request setCompletionBlock:^{
        BOOL success = YES;
        handler([request responseData],success);
    }];
    [request setFailedBlock:^{
        BOOL success = NO;
        [request clearDelegatesAndCancel];
        handler(nil,success);
    }];
    [request startAsynchronous];
    return request;
}

//从dic组装request
+ (ASIFormDataRequest *)fetcherWithURLString:(NSString *)urlString dicParams:(NSDictionary *)params fileParams:(NSArray *)fileArr
{
    ASIFormDataRequest* request = [ASIFormDataRequest  requestWithURL:[NSURL URLWithString:urlString]];
    [request setRequestMethod:@"POST"];
    [request setTimeOutSeconds:TIMEOUT];
    
    [request setPostFormat:ASIMultipartFormDataPostFormat];
    
    NSString * key;
    NSEnumerator * enumerator = [params keyEnumerator];
    while (key = [enumerator nextObject])
    {
        NSString * value = [params objectForKey:key];
        [request setPostValue:value forKey:key];
    }
    
    if([NetworkManager sharedInstance].sessionToken && [[NetworkManager sharedInstance].sessionToken length] > 0)
    {
        [request setPostValue:[NetworkManager sharedInstance].sessionToken forKey:@"usertoken"];
        NSLog(@"%@",[NetworkManager sharedInstance].sessionToken);
        [[NSUserDefaults standardUserDefaults] setObject:[NetworkManager sharedInstance].sessionToken forKey:@"UserToken"];// .standardUserDefaults().objectForKey("UserToken")
    }
    
    if ([fileArr count] > 0) {
        for (NSDictionary *fileDic in fileArr) {
            NSString * skey;
            NSEnumerator * senumerator = [fileDic keyEnumerator];
            while (skey = [senumerator nextObject])
            {
                NSString * svalue = [fileDic objectForKey:skey];
                [request setFile:svalue forKey:skey];
            }
        }
    }
    
    return request;
}

//从data组装request
+ (ASIFormDataRequest *)fetcherWithURLString:(NSString *)urlString dataParams:(NSData *)data fileParams:(NSArray *)fileArr
{
    ASIFormDataRequest* request = [ASIFormDataRequest  requestWithURL:[NSURL URLWithString:urlString]];
    [request setRequestMethod:@"POST"];
    [request setTimeOutSeconds:TIMEOUT];
    //普通form表单
    //[request setRequestHeaders:[NSMutableDictionary dictionaryWithObject:@"application/x-www-form-urlencoded; charset=utf-8" forKey:@"Content-Type"]];
    //json格式
    //[request setRequestHeaders:[NSMutableDictionary dictionaryWithObject:@"application/json" forKey:@"Content-Type"]];
    [request setRequestHeaders:[NSMutableDictionary dictionaryWithObject:@"application/json; android" forKey:@"Content-Type"]];
    
//    if([NetworkManager sharedInstance].sessionToken && [[NetworkManager sharedInstance].sessionToken length] > 0)
//    {
//        [request setPostValue:[NetworkManager sharedInstance].sessionToken forKey:@"usertoken"];
//    }

    [request appendPostData:data ];
    if ([fileArr count] > 0) {
        for (NSDictionary *fileDic in fileArr) {
            NSString * skey;
            NSEnumerator * senumerator = [fileDic keyEnumerator];
            while (skey = [senumerator nextObject])
            {
                NSString * svalue = [fileDic objectForKey:skey];
                [request setFile:svalue forKey:skey];
            }
        }
    }
    
    return request;
}

@end











