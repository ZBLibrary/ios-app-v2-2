//
//  UserInfoActionWerbService.h
//  OZner
//
//  Created by Mac Mini 1 on 15/12/26.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConnectUtil.h"
#import "StatusManager.h"

@interface UserInfoActionWerbService : NSObject
//获取短信验证码
- (ASIFormDataRequest*)GetMessageCode:(NSString*)mobile returnBlock:(void(^)(id data,StatusManager* status))handle;
//获取语音验证码GetPost/OznerServer/GetVoicePhoneCode
- (ASIFormDataRequest*)GetVoicePhoneCode:(NSString*)mobile returnBlock:(void(^)(id data,StatusManager* status))handle;
//百度推送
- (ASIFormDataRequest*)baiDuPush:(NSString*)mobile con:(NSString*)con title:(NSString*)title returnBlock:(void(^)(StatusManager* status))handle;
//提交建议
- (ASIFormDataRequest*)submitOpition:(NSString*)message returnBlock:(void(^)(StatusManager* status))handle;
//搜索好友
- (ASIFormDataRequest*)searchFriend:(NSString*)mobile returnBlock:(void(^)(id data, StatusManager* status))handle;
//发送添加好友验证消息
- (ASIFormDataRequest*)addFriend:(NSString*)mobile content:(NSString*)content returnBlock:(void(^)(StatusManager* status))handle;
//获取用户验证信息列表
- (ASIFormDataRequest*)getUserVerifMessage:(void(^)(id data,StatusManager* status))handle;
//接受验证请求
- (ASIFormDataRequest*)acceptUserVerify:(NSString*)msgId returnBlock:(void(^)(id data,StatusManager* status))handle;
//获取好友列表
- (ASIFormDataRequest*)getFriendList:(void(^)(id muArr, StatusManager* status))handle;


//朋友圈内的饮水量实时排名
- (ASIFormDataRequest*)VolumeFriendRank:(void(^)(id muArr, StatusManager* status))handle;
//对其他用户点赞
- (ASIFormDataRequest*)LikeOtherUser:(NSString*)likeuserid type:(NSString*)type returnBlock:(void(^)(StatusManager* status))handle;
//获取未读排名通知
- (ASIFormDataRequest*)GetRankNotify:(void(^)(id muArr, StatusManager* status))handle;
//朋友圈内的TDS实时排名
- (ASIFormDataRequest*)TdsFriendRank:(NSString*)type returnBlock:(void(^)(id muArr, StatusManager* status))handle;

//赞我的人/OznerDevice/WhoLikeMe
- (ASIFormDataRequest*)WhoLikeMe:(NSString*)type returnBlock:(void(^)(id muArr, StatusManager* status))handle;

//获取留言历史记录/OznerDevice/GetHistoryMessage
- (ASIFormDataRequest*)GetHistoryMessage:(NSString*)otheruserid returnBlock:(void(^)(id muArr, StatusManager* status))handle;

//发送留言/OznerDevice/LeaveMessage
- (ASIFormDataRequest*)LeaveMessage:(NSString*)otheruserid message:(NSString*)message returnBlock:(void(^)(id muArr, StatusManager* status))handle;


@end
