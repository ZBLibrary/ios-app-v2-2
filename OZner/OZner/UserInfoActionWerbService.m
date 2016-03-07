//
//  UserInfoActionWerbService.m
//  OZner
//
//  Created by Mac Mini 1 on 15/12/26.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

#import "UserInfoActionWerbService.h"
#import "WebAssistant.h"

@implementation UserInfoActionWerbService
//获取语音验证码
- (ASIFormDataRequest*)GetVoicePhoneCode:(NSString*)mobile returnBlock:(void(^)(id data,StatusManager* status))handle
{
    NetworkEntrance* entrance = [[NetworkEntrance alloc]init];
    
    [entrance addObject:mobile forKey:@"phone"];
    [entrance addURLString:Get_Voice_Phone_Code];
    return [WebAssistant execNormalkRequest:entrance bodyBlock:^(NSDictionary *dicBody, StatusManager *status) {
        NSLog(@"%@",dicBody);
        handle(dicBody,status);
    } failedBlock:^(StatusManager *status) {
        handle(nil,status);
    }];

}
//百度推送
- (ASIFormDataRequest*)baiDuPush:(NSString*)mobile con:(NSString*)con title:(NSString*)title returnBlock:(void(^)(StatusManager* status))handle
{
    NetworkEntrance* entrance = [[NetworkEntrance alloc]init];
    
    [entrance addObject:mobile forKey:@"mobile"];
    [entrance addObject:con forKey:@"con"];
    [entrance addObject:title forKey:@"title"];
    [entrance addURLString:WERB_URL_BAI_DU_PUSH];
    
    return [WebAssistant execNormalkRequest:entrance bodyBlock:^(NSDictionary *dicBody, StatusManager *status) {
        handle(status);
    } failedBlock:^(StatusManager *status) {
        handle(status);
    }];
}

//提交建议
- (ASIFormDataRequest*)submitOpition:(NSString*)message returnBlock:(void(^)(StatusManager* status))handle
{
    NetworkEntrance* entrance= [[NetworkEntrance alloc]init];
    
    [entrance addObject:message forKey:@"message"];
    [entrance addURLString:WERB_URL_SUBMIT_OPTION];
    
    return [WebAssistant execNormalkRequest:entrance bodyBlock:^(NSDictionary *dicBody, StatusManager *status) {
        handle(status);
    } failedBlock:^(StatusManager *status) {
        handle(status);
    }];
}

//搜索好友
- (ASIFormDataRequest*)searchFriend:(NSString*)mobile returnBlock:(void(^)(id data, StatusManager* status))handle
{
    NetworkEntrance* entrance = [[NetworkEntrance alloc]init];
    
    [entrance addObject:mobile forKey:@"mobile"];
    [entrance addURLString:WERB_URL_SEARCH_FRIEND];
    
    return [WebAssistant execNormalkRequest:entrance bodyBlock:^(NSDictionary *dicBody, StatusManager *status) {
        handle(dicBody,status);
    } failedBlock:^(StatusManager *status) {
        handle(nil,status);
    }];
}

//添加好友
- (ASIFormDataRequest*)addFriend:(NSString*)mobile content:(NSString*)content returnBlock:(void(^)(StatusManager* status))handle
{
    NetworkEntrance* entrance = [[NetworkEntrance alloc]init];
    
    [entrance addObject:mobile forKey:@"mobile"];
    [entrance addObject:content forKey:@"content"];
    [entrance addURLString:WERB_URL_ADD_FRIEND];
    
    return [WebAssistant execNormalkRequest:entrance bodyBlock:^(NSDictionary *dicBody, StatusManager *status) {
        handle(status);
    } failedBlock:^(StatusManager *status) {
        handle(status);
    }];
}

//获取用户验证信息列表
- (ASIFormDataRequest*)getUserVerifMessage:(void(^)(id data,StatusManager* status))handle
{
    NetworkEntrance* entrance = [[NetworkEntrance alloc]init];
    
    [entrance addURLString:WERB_URL_GET_USER_VERIF_MESSAGE];
    
    return [WebAssistant execNormalkRequest:entrance bodyBlock:^(NSDictionary *dicBody, StatusManager *status) {
        handle(dicBody,status);
    } failedBlock:^(StatusManager *status) {
        handle(nil,status);
    }];
}

//接受验证请求
- (ASIFormDataRequest*)acceptUserVerify:(NSString*)msgId returnBlock:(void(^)(id data,StatusManager* status))handle
{
    NetworkEntrance* entrance = [[NetworkEntrance alloc]init];
    
    [entrance addObject:msgId forKey:@"ID"];
    [entrance addURLString:WERB_URL_ACCEPT_USER_VERIFY];
    
    return [WebAssistant execNormalkRequest:entrance bodyBlock:^(NSDictionary *dicBody, StatusManager *status) {
        handle(dicBody,status);
    } failedBlock:^(StatusManager *status) {
        handle(nil,status);
    }];
}

//获取好友列表
- (ASIFormDataRequest*)getFriendList:(void(^)(id muArr, StatusManager* status))handle
{
    NetworkEntrance* entrance = [[NetworkEntrance alloc]init];
    
    [entrance addURLString:WERB_URL_FRIEND_LIST];
    
    return [WebAssistant execNormalkRequest:entrance bodyBlock:^(NSDictionary *dicBody, StatusManager *status) {
        handle(dicBody,status);
    } failedBlock:^(StatusManager *status) {
        handle(nil,status);
    }];
}

//朋友圈内的饮水量实时排名
- (ASIFormDataRequest*)VolumeFriendRank:(void(^)(id muArr, StatusManager* status))handle
{
    NetworkEntrance* entrance = [[NetworkEntrance alloc]init];
    
    [entrance addURLString:WERB_URL_Volume_Friend_Rank];
    
    return [WebAssistant execNormalkRequest:entrance bodyBlock:^(NSDictionary *dicBody, StatusManager *status) {
        handle(dicBody,status);
    } failedBlock:^(StatusManager *status) {
        handle(nil,status);
    }];
}
//对其他用户点赞
- (ASIFormDataRequest*)LikeOtherUser:(NSString*)likeuserid type:(NSString*)type returnBlock:(void(^)(StatusManager* status))handle{
    NetworkEntrance* entrance = [[NetworkEntrance alloc]init];
    [entrance addObject:likeuserid forKey:@"likeuserid"];
    [entrance addObject:type forKey:@"type"];
    [entrance addURLString:WERB_URL_Like_Other_User];
    
    return [WebAssistant execNormalkRequest:entrance bodyBlock:^(NSDictionary *dicBody, StatusManager *status) {
        handle(status);
    } failedBlock:^(StatusManager *status) {
        handle(status);
    }];
}
//获取未读排名通知
- (ASIFormDataRequest*)GetRankNotify:(void(^)(id muArr, StatusManager* status))handle{
    NetworkEntrance* entrance = [[NetworkEntrance alloc]init];
    
    [entrance addURLString:WERB_URL_Get_Rank_Notify];
    
    return [WebAssistant execNormalkRequest:entrance bodyBlock:^(NSDictionary *dicBody, StatusManager *status) {
        handle(dicBody,status);
    } failedBlock:^(StatusManager *status) {
        handle(nil,status);
    }];
}
//朋友圈内的TDS实时排名
- (ASIFormDataRequest*)TdsFriendRank:(NSString*)type returnBlock:(void(^)(id muArr, StatusManager* status))handle{
    NetworkEntrance* entrance = [[NetworkEntrance alloc]init];
    [entrance addObject:type forKey:@"type"];
    [entrance addURLString:WERB_URL_Tds_Friend_Rank];
    
    return [WebAssistant execNormalkRequest:entrance bodyBlock:^(NSDictionary *dicBody, StatusManager *status) {
        handle(dicBody,status);
    } failedBlock:^(StatusManager *status) {
        handle(nil,status);
    }];
}

//赞我的人/OznerDevice/WhoLikeMe
- (ASIFormDataRequest*)WhoLikeMe:(NSString*)type returnBlock:(void(^)(id muArr, StatusManager* status))handle
{
    NetworkEntrance* entrance = [[NetworkEntrance alloc]init];
    [entrance addObject:type forKey:@"type"];
    [entrance addURLString:WERB_URL_Who_Like_Me];
    
    return [WebAssistant execNormalkRequest:entrance bodyBlock:^(NSDictionary *dicBody, StatusManager *status) {
        handle(dicBody,status);
    } failedBlock:^(StatusManager *status) {
        handle(nil,status);
    }];
}

//获取留言历史记录/OznerDevice/GetHistoryMessage
- (ASIFormDataRequest*)GetHistoryMessage:(NSString*)otheruserid returnBlock:(void(^)(id muArr, StatusManager* status))handle
{
    NetworkEntrance* entrance = [[NetworkEntrance alloc]init];
    [entrance addObject:otheruserid forKey:@"otheruserid"];
    [entrance addURLString:WERB_URL_Get_History_Message];
    
    return [WebAssistant execNormalkRequest:entrance bodyBlock:^(NSDictionary *dicBody, StatusManager *status) {
        handle(dicBody,status);
    } failedBlock:^(StatusManager *status) {
        handle(nil,status);
    }];
}

//发送留言/OznerDevice/LeaveMessage
- (ASIFormDataRequest*)LeaveMessage:(NSString*)otheruserid message:(NSString*)message returnBlock:(void(^)(id muArr, StatusManager* status))handle
{
    NetworkEntrance* entrance = [[NetworkEntrance alloc]init];
    [entrance addObject:otheruserid forKey:@"otheruserid"];
    [entrance addObject:message forKey:@"message"];
    [entrance addURLString:WERB_URL_Leave_Message];
    
    return [WebAssistant execNormalkRequest:entrance bodyBlock:^(NSDictionary *dicBody, StatusManager *status) {
        handle(dicBody,status);
    } failedBlock:^(StatusManager *status) {
        handle(nil,status);
    }];
}

@end
