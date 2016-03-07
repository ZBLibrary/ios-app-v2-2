//
//  NetworkParseSatus.h
//  BlackRoom
//
//  Created by Mac Mini 1 on 14-10-11.
//  Copyright (c) 2014年 sunlinlin. All rights reserved.

#import <Foundation/Foundation.h>
#import "ParseDictionaryData.h"

//网络和数据包解析状态
typedef enum
{
    kResponseFailedStatus,          //网络返回错误
    kParseFailedStatus,             //数据解析错误
    kSuccessStatus,                 //网络返回成功
    kHeadStError,                   //头返回不为0
}HHTP_NetworkStatus;

//数据库状态
typedef enum
{
    kDBSuccessStatus,               //数据库返回成功
    kDBFaildStatus,                 //数据库返回失败
}DBStatus;

//解析头
@interface HeadParseData : ParseDictionaryData

@property(nonatomic,retain)NSString *commandid;     //命令字
@property(nonatomic,retain)NSString *st;            //状态
@property(nonatomic,retain)NSString *msg;           //信息


@end

//status
@interface StatusManager : NSObject

@property (nonatomic, assign) HHTP_NetworkStatus networkStatus;      //网络和解析状态
@property (nonatomic, retain) NSString* errDesc;                     //服务器返回错误描述
@property (nonatomic, assign) int       errorCode;                  //返回错误码
@property (nonatomic, assign) DBStatus dbStatus;                    //数据库状态

//便利初始化方法
//+ (id)statusHead:(HeadParseData *)head networkStatus:(HHTP_NetworkStatus)networkStatus;
+ (id)statusHead:(NSString *)errDes networkStatus:(HHTP_NetworkStatus)networkStatus errorCode:(int)errorCode;
+ (id)statusWithDBStatus:(DBStatus)dbStatus;
@end





