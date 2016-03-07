//
//  VersionSettingDBManager.m
//  VirtualLovers
//
//  Created by Mac Mini 1 on 15/10/13.
//  Copyright (c) 2015年 sunlinlin. All rights reserved.
//

#import "VersionSettingDBManager.h"
#import "UserDatabase.h"

@implementation VersionSettingDBManager

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
        return bFlag;
    }
    
    [database FinishColumn:stmt];
    
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
        return bFlag;
    }
    
    [database FinishColumn:stmt];
    
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

//添加设置value
- (BOOL)addSettingValue:(int)settingId vaue:(UNDWORD)value
{
    NSString* nsSql = @"select * from version_setting_table where settingId = ?";
    DataBaseParam* dbParam = [[DataBaseParam alloc] init];
    CDatabase* database = [[UserDatabase sharedUserDatabase] getConnectedDB];
    
    //如果是设置数据库是否升级，则不需要更新，直接添加
    if(![self QueryDataIsExists:nsSql DataNum:settingId])
    {
        dbParam.nsSqlText = @"insert into version_setting_table(settingId,value)values(?,?)";
        
        [dbParam AddParamInt:settingId];
        [dbParam AddParamInt64:value];
    }
    else
    {
        dbParam.nsSqlText = @"update version_setting_table set value = ? where settingId= ?";
        
        [dbParam AddParamInt64:value];
        [dbParam AddParamInt:settingId];
    }
    
    BOOL bSuccess = [database ExecCmdByParam:dbParam];
    
    if(!bSuccess)
    {
        NSLog(@"failed to add user set to local database!\n");
    }
    
    return bSuccess;
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
        return bFlag;
    }
    
    [database FinishColumn:stmt];
    
    return bFlag;
}

//添加wifi
- (BOOL)addWifi:(NSString*)wifiName psw:(NSString*)psw
{
    NSString* nsSql = @"select * from wifi_table where name = ?";
    DataBaseParam* dbParam = [[DataBaseParam alloc] init];
    CDatabase* database = [[UserDatabase sharedUserDatabase] getConnectedDB];
    
    //如果是设置数据库是否升级，则不需要更新，直接添加
    if(![self QueryDataIsExistOneStr:nsSql DataStr1:wifiName])
    {
        dbParam.nsSqlText = @"insert into wifi_table(name,passWord)values(?,?)";
        
        [dbParam AddParamText:wifiName];
        [dbParam AddParamText:psw];
    }
    else
    {
        dbParam.nsSqlText = @"update wifi_table set passWord = ? where name= ?";
        
        [dbParam AddParamText:psw];
        [dbParam AddParamText:wifiName];
    }
    
    BOOL bSuccess = [database ExecCmdByParam:dbParam];
    
    if(!bSuccess)
    {
        NSLog(@"failed to add user set to local database!\n");
    }
    
    return bSuccess;

}
//查询wifi
- (NSString*)queryPswByName:(NSString*)name
{
    NSString* query = [NSString stringWithFormat:@"select passWord from wifi_table where name = %@",name];
    CDatabase* database = [[UserDatabase sharedUserDatabase] getConnectedDB];
    STATEMENT* pStatement = [database PrepareSQL:query];
    
    NSString* psw = @"";
    
    if(pStatement != NULL)
    {
        while ([database GetNextColumn:pStatement])
        {
            psw = [database GetColumnText:pStatement];
        }
        
        [database FinishColumn:pStatement];
    }
    
    return psw;

}

//查询设置表是否存在
- (BOOL)querySettingTableIsExit
{
    CDatabase* database = [[UserDatabase sharedUserDatabase] getConnectedDB];
    //建新表 AUTOINCREMENT
    if(![database ExecCmd:@"CREATE TABLE IF NOT EXISTS 'version_setting_table' ( ID INTEGER PRIMARY KEY , SETTINGID NUMERIC,VALUE NUMERIC)"])
    {
        NSLog(@"CREATE label_info_table FAILED");
        return false;
    }

    return YES;
}
//查询设置value
- (UNDWORD)querySettingValueBySettingId:(int)settingId
{
    NSString* query = [NSString stringWithFormat:@"select * from version_setting_table where settingId = %d",settingId];
    CDatabase* database = [[UserDatabase sharedUserDatabase] getConnectedDB];
    STATEMENT* pStatement = [database PrepareSQL:query];
    
    UNDWORD value = 0;
    
    if(pStatement != NULL)
    {
        while ([database GetNextColumn:pStatement])
        {
            [database GetColumnInt:pStatement];
            [database GetColumnInt:pStatement];
            value = [database GetColumnInt64:pStatement];
        }
        
        [database FinishColumn:pStatement];
    }
    
    return value;
}

@end
