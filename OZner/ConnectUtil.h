//
//  ConnectUtil.h
//  BlackRoom
//
//  Created by Mac Mini 1 on 14-10-11.
//  Copyright (c) 2014年 sunlinlin. All rights reserved.

#import <UIKit/UIKit.h>
#import "NetworkEntrance.h"

@class ASIFormDataRequest;

typedef enum
{
    kNormalRequest,            //普通
    kCustomRequest,            //自定义协议
} REQUESTTYPE;

@interface ConnectUtil : UIView

//网络请求
+ (ASIFormDataRequest *)request:(REQUESTTYPE)requestType NetworkEntrance:(NetworkEntrance *)networkEntrance returnBlock:(void(^)(NSData *data,BOOL bISsuccess))handler;

@end
