//
//  MyInfoWerbservice.m
//  OZner
//
//  Created by test on 15/11/30.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

#import "MyInfoWerbservice.h"
#import "WebAssistant.h"

@implementation MyInfoWerbservice

//获取用户信息
- (ASIFormDataRequest*)getUserInfo:(void(^)(id userInfo, StatusManager* status))handle
{
    NetworkEntrance* entrance = [[NetworkEntrance alloc]init];
    
    [entrance addURLString:WERB_URL_GET_USER_INFO];
    
    return [WebAssistant execNormalkRequest:entrance bodyBlock:^(NSDictionary *dicBody, StatusManager *status) {
        handle(dicBody,status);
    } failedBlock:^(StatusManager *status) {
        handle(nil,status);
    }];
}
//更新用户信息
- (ASIFormDataRequest*)updateUserInfo:(NSArray*)keyArr valueArr:(NSArray*)valueArr returnBlock:(void(^)(id data,StatusManager* status))handle
{
    NetworkEntrance* entrance = [[NetworkEntrance alloc]init];
    
    [entrance addObject:[NSNumber numberWithInt:4] forKey:@"channel_id"];
    for(int i=0;i<keyArr.count;i++)
    {
        [entrance addObject:[valueArr objectAtIndex:i] forKey:[keyArr objectAtIndex:i]];
    }
    [entrance addURLString:WERB_URL_UPDATE_USERINFO];
    
    return [WebAssistant execNormalkRequest:entrance bodyBlock:^(NSDictionary *dicBody, StatusManager *status) {
        handle(dicBody,status);
    } failedBlock:^(StatusManager *status) {
        handle(nil,status);
    }];
}

//获取用户昵称图片信息
- (ASIFormDataRequest*)getUserNickImage:(NSArray*)mobileArr returnBlock:(void(^)(NSMutableDictionary * userInfoArr, StatusManager* status))handle
{
    NetworkEntrance* entrance = [[NetworkEntrance alloc]init];
    NSString* string = @"";
    for(int i=0;i<mobileArr.count;i++)
    {
        if(i == 0)
        {
            string = [mobileArr objectAtIndex:i];
        }
        else
        {
            string = [NSString stringWithFormat:@"%@%@",string,[mobileArr objectAtIndex:i]];
        }
    }
    
    [entrance addObject:string forKey:@"jsonmobile"];
    [entrance addURLString:WERB_URL_NICK_IMG_INFO];
    
    return [WebAssistant execNormalkRequest:entrance bodyBlock:^(NSDictionary *dicBody, StatusManager *status) {
        NSMutableDictionary* userInfoArr=(NSMutableDictionary*)dicBody;
        handle(userInfoArr,status);
    } failedBlock:^(StatusManager *status) {
        handle(nil,status);
    }];
}
@end
