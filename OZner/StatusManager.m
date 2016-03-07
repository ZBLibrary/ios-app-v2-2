//
//  NetworkParseSatus.m
//  BlackRoom
//
//  Created by Mac Mini 1 on 14-10-11.
//  Copyright (c) 2014年 sunlinlin. All rights reserved.

#import "StatusManager.h"

#pragma mark - 解析头
@implementation HeadParseData

- (void)InitSubFieldName
{
    ADD_FIELD(_commandid, @"cmd");
    ADD_FIELD(_st, @"st");
    ADD_FIELD(_msg, @"msg");
}

- (void)dealloc
{
    self.commandid = nil;
    self.st = nil;
    self.msg = nil;
    
    [super dealloc];
}

@end

@implementation StatusManager

+ (id)statusHead:(NSString *)errDes networkStatus:(HHTP_NetworkStatus)networkStatus errorCode:(int)errorCode
{
    StatusManager *status = [[[StatusManager alloc] init] autorelease];
    status.errDesc = errDes;
    status.errorCode = errorCode;
    status.networkStatus = networkStatus;
    return status;
}

+ (id)statusWithDBStatus:(DBStatus)dbStatus
{
    StatusManager *status = [[[StatusManager alloc] init] autorelease];    
    status.dbStatus = dbStatus;
    return status;
}

- (void)dealloc
{
    [super dealloc];
}

@end


