//
//  UserActionDBManager.h
//  OZner
//
//  Created by Mac Mini 1 on 15/12/26.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserActionDBManager : NSObject

//添加通知消息
- (BOOL)addVerifyMsg:(UserVerifMsgInfo*)verifyInfo;
//查询用户通知信息
- (NSMutableArray*)queryUserVerifyMsgInfosByStatus:(NSNumber*)status;

@end
