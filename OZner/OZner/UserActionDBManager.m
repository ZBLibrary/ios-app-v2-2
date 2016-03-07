//
//  UserActionDBManager.m
//  OZner
//
//  Created by Mac Mini 1 on 15/12/26.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

#import "UserActionDBManager.h"
#import "UserDatabase.h"

@implementation UserActionDBManager

-(BOOL)QueryDataIsExists:(NSString *)nsSql DataNum:(UNDWORD)num
{
    CDatabase* database = [[UserDatabase sharedUserDatabase] getConnectedDB];
    DataBaseParam *dbParam = [[DataBaseParam alloc] init];
    dbParam.nsSqlText = nsSql;
    [dbParam AddParamInt64:num];
    
    STATEMENT *stmt = [database PrepareSQLByParam:dbParam]; [NSString stringWithFormat:@"%@", @"" ];
    
    BOOL bFlag = YES;
    if(!stmt || ![database GetNextColumn:stmt])
    {
        bFlag = NO;
        [database FinishColumn:stmt];
        [dbParam release];
        return bFlag;
    }
    
    [database FinishColumn:stmt];
    [dbParam release];
    
    return bFlag;
}

-(BOOL)QueryDataIsExists:(NSString *)nsSql DataNum1:(UNDWORD)num1 DataNum2:(UNDWORD)num2
{
    CDatabase* database = [[UserDatabase sharedUserDatabase] getConnectedDB];
    DataBaseParam *dbParam = [[DataBaseParam alloc] init];
    dbParam.nsSqlText = nsSql;
    [dbParam AddParamInt64:num1];
    [dbParam AddParamInt64:num2];
    
    STATEMENT *stmt = [database PrepareSQLByParam:dbParam]; [NSString stringWithFormat:@"%@", @"" ];
    
    BOOL bFlag = YES;
    if(!stmt || ![database GetNextColumn:stmt])
    {
        bFlag = NO;
        [database FinishColumn:stmt];
        [dbParam release];
        return bFlag;
    }
    
    [database FinishColumn:stmt];
    [dbParam release];
    
    return bFlag;
}

- (BOOL)QueryDataIsExistOneStr:(NSString*)nsSql DataStr1:(NSString*)str1
{
    CDatabase* database = [[UserDatabase sharedUserDatabase] getConnectedDB];
    DataBaseParam *dbParam = [[DataBaseParam alloc] init];
    dbParam.nsSqlText = nsSql;
    [dbParam AddParamText:str1];
    
    STATEMENT *stmt = [database PrepareSQLByParam:dbParam];
    
    BOOL bFlag = YES;
    if(!stmt || ![database GetNextColumn:stmt])
    {
        bFlag = NO;
        [database FinishColumn:stmt];
        [dbParam release];
        return bFlag;
    }
    
    [database FinishColumn:stmt];
    [dbParam release];
    
    return bFlag;
}

-(BOOL)QueryDataIsExistStr:(NSString *)nsSql DataStr1:(NSString*)str1 DataStr2:(NSString*)str2
{
    CDatabase* database = [[UserDatabase sharedUserDatabase] getConnectedDB];
    DataBaseParam *dbParam = [[DataBaseParam alloc] init];
    dbParam.nsSqlText = nsSql;
    [dbParam AddParamText:str1];
    [dbParam AddParamText:str2];
    
    STATEMENT *stmt = [database PrepareSQLByParam:dbParam]; [NSString stringWithFormat:@"%@", @"" ];
    
    BOOL bFlag = YES;
    if(!stmt || ![database GetNextColumn:stmt])
    {
        bFlag = NO;
        [database FinishColumn:stmt];
        [dbParam release];
        return bFlag;
    }
    
    [database FinishColumn:stmt];
    [dbParam release];
    
    return bFlag;
}

-(BOOL)isNilOrNSNull:(NSString* )str
{
    if ([str isKindOfClass:[NSNull class]])
    {
        return YES;
    }
    if (!str)
    {
        return YES;
    }
    return NO;
    
}

- (BOOL)isNSNumberNilOrNSNull:(NSNumber* )num
{
    if ([num isKindOfClass:[NSNull class]])
    {
        return YES;
    }
    if (!num)
    {
        return YES;
    }
    return NO;
}

//添加通知消息
- (BOOL)addVerifyMsg:(UserVerifMsgInfo*)verifyInfo
{
    CDatabase* database = [[UserDatabase sharedUserDatabase] getConnectedDB];
    NSString* nsSql = @"select * from verify_msg_table where msgId = ? ";
    
    DataBaseParam* dbParam = [[DataBaseParam alloc] init];
    NSString* msgId = verifyInfo.msgId;
    
    if([self isNilOrNSNull:msgId])
    {
        msgId = @"";
    }
    
    if(![self QueryDataIsExistOneStr:nsSql DataStr1:verifyInfo.msgId])
    {
        dbParam.nsSqlText = @"insert into verify_msg_table(msgId,mobile,friendMobile,requestContent,status,disabled,createBy,createTime,modifyBy,modifytime) values(?,?,?,?,?,?,?,?,?,?)";
        
        [dbParam AddParamText:msgId];
        
        if([self isNilOrNSNull:verifyInfo.mobile])
        {
            [dbParam AddParamText:@""];
        }
        else
        {
            [dbParam AddParamText:verifyInfo.mobile];
        }
        
        if([self isNilOrNSNull:verifyInfo.friendMobile])
        {
            [dbParam AddParamText:@""];
        }
        else
        {
            [dbParam AddParamText:verifyInfo.friendMobile];
        }
        
        if([self isNilOrNSNull:verifyInfo.requestContent])
        {
            [dbParam AddParamText:@""];
        }
        else
        {
            [dbParam AddParamText:verifyInfo.requestContent];
        }
        
        if([self isNSNumberNilOrNSNull:verifyInfo.status])
        {
            [dbParam AddParamInt64:0];
        }
        else
        {
            [dbParam AddParamInt64:[verifyInfo.status intValue]];
        }
        
        if([self isNSNumberNilOrNSNull:verifyInfo.disabled])
        {
            [dbParam AddParamInt64:0];
        }
        else
        {
            [dbParam AddParamInt64:[verifyInfo.disabled intValue]];
        }
        
        if([self isNilOrNSNull:verifyInfo.createBy])
        {
            [dbParam AddParamText:@""];
        }
        else
        {
            [dbParam AddParamText:verifyInfo.createBy];
        }
        
        if([self isNilOrNSNull:verifyInfo.createTime])
        {
            [dbParam AddParamText:@""];
        }
        else
        {
            [dbParam AddParamText:verifyInfo.createTime];
        }
        
        if([self isNilOrNSNull:verifyInfo.modifyBy])
        {
            [dbParam AddParamText:@""];
        }
        else
        {
            [dbParam AddParamText:verifyInfo.modifyBy];
        }
        
        if([self isNilOrNSNull:verifyInfo.modifytime])
        {
            [dbParam AddParamText:@""];
        }
        else
        {
            [dbParam AddParamText:verifyInfo.modifytime];
        }
    }
    else
    {
        dbParam.nsSqlText = @"update verify_msg_table set mobile = ?,friendMobile = ?,requestContent = ?,status = ?,disabled = ?,createBy = ?,createTime = ?,modifyBy = ?,modifytime = ? where msgId = ?";
        
        if([self isNilOrNSNull:verifyInfo.mobile])
        {
            [dbParam AddParamText:@""];
        }
        else
        {
            [dbParam AddParamText:verifyInfo.mobile];
        }
        
        if([self isNilOrNSNull:verifyInfo.friendMobile])
        {
            [dbParam AddParamText:@""];
        }
        else
        {
            [dbParam AddParamText:verifyInfo.friendMobile];
        }
        
        if([self isNilOrNSNull:verifyInfo.requestContent])
        {
            [dbParam AddParamText:@""];
        }
        else
        {
            [dbParam AddParamText:verifyInfo.requestContent];
        }
        
        if([self isNSNumberNilOrNSNull:verifyInfo.status])
        {
            [dbParam AddParamInt64:0];
        }
        else
        {
            [dbParam AddParamInt64:[verifyInfo.status intValue]];
        }
        
        if([self isNSNumberNilOrNSNull:verifyInfo.disabled])
        {
            [dbParam AddParamInt64:0];
        }
        else
        {
            [dbParam AddParamInt64:[verifyInfo.disabled intValue]];
        }
        
        if([self isNilOrNSNull:verifyInfo.createBy])
        {
            [dbParam AddParamText:@""];
        }
        else
        {
            [dbParam AddParamText:verifyInfo.createBy];
        }
        
        if([self isNilOrNSNull:verifyInfo.createTime])
        {
            [dbParam AddParamText:@""];
        }
        else
        {
            [dbParam AddParamText:verifyInfo.createTime];
        }
        
        if([self isNilOrNSNull:verifyInfo.modifyBy])
        {
            [dbParam AddParamText:@""];
        }
        else
        {
            [dbParam AddParamText:verifyInfo.modifyBy];
        }
        
        if([self isNilOrNSNull:verifyInfo.modifytime])
        {
            [dbParam AddParamText:@""];
        }
        else
        {
            [dbParam AddParamText:verifyInfo.modifytime];
        }
        
        [dbParam AddParamText:msgId];
    }
    
    BOOL bSuccess = [database ExecCmdByParam:dbParam];
    if(!bSuccess)
    {
        NSLog(@"add verify_msg_table failed!......\n");
    }
    
    [dbParam release];
    
    return bSuccess;
}

//查询用户通知信息
- (NSMutableArray*)queryUserVerifyMsgInfosByStatus:(NSNumber*)status
{
    CDatabase* database = [[UserDatabase sharedUserDatabase] getConnectedDB];
    NSString* query = [NSString stringWithFormat:@"select * from verify_msg_table where status = %d",[status intValue]];
    
    STATEMENT* pStatement = [database PrepareSQL:query];
    
    NSMutableArray* muArr = [[[NSMutableArray alloc]init] autorelease];
    
    if(pStatement != NULL)
    {
        while ([database GetNextColumn:pStatement])
        {
            UserVerifMsgInfo* msgInfo = [[UserVerifMsgInfo alloc]init];
            msgInfo._id = [database GetColumnInt64:pStatement];
            msgInfo.msgId = [database GetColumnText:pStatement];
            msgInfo.mobile = [database GetColumnText:pStatement];
            msgInfo.friendMobile = [database GetColumnText:pStatement];
            msgInfo.requestContent = [database GetColumnText:pStatement];
            msgInfo.status = [NSNumber numberWithInt:[database GetColumnInt:pStatement]];
            msgInfo.disabled = [NSNumber numberWithInt:[database GetColumnInt:pStatement]];
            msgInfo.createBy = [database GetColumnText:pStatement];
            msgInfo.createTime = [database GetColumnText:pStatement];
            msgInfo.modifyBy = [database GetColumnText:pStatement];
            msgInfo.modifytime = [database GetColumnText:pStatement];
        }
        
        [database FinishColumn:pStatement];
    }
    return muArr;

}

@end
