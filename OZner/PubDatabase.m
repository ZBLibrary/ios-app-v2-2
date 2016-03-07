//
//  PubDatabase.m
//  BlackRoom
//
//  Created by Mac Mini 1 on 15-1-9.
//  Copyright (c) 2014年 sunlinlin. All rights reserved.
//

#import "PubDatabase.h"

PubDatabase*     g_globalData = nil;

@implementation PubDatabase
{
    CDatabase*      m_database;
    BOOL            m_bIsDataBaseOpen;
}

+ (PubDatabase*) sharedGlobalData
{
    @synchronized(self)
    {
        if (!g_globalData)
        {
            g_globalData = [[PubDatabase alloc] init];
        }
    }
    
    return g_globalData;
}

- (id) init
{
    if (self = [super init])
    {
        if ([self copyDataFileToDocumentDictory])
        {
            NSArray * paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
            NSString * documentDirectory=[paths objectAtIndex:0];
            NSString *destDBPath=[documentDirectory stringByAppendingPathComponent:kDatabase_pub];
            
            m_database=[[CDatabase alloc] init];
            m_bIsDataBaseOpen = [m_database OpenDatabase:destDBPath];
        }
    }
    
    return self;
}


#pragma mark -拷贝数据文件到文档目录中
- (BOOL) copyDataFileToDocumentDictory
{
    NSFileManager* fm = [NSFileManager defaultManager];
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentDirectory = [paths objectAtIndex:0];
    NSString* strDstDBPath = [documentDirectory stringByAppendingPathComponent:kDatabase_pub];
    NSString* strSrcDBPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:kDatabase_pub];
    
    // 如果已存在则不创建，返回成功
    BOOL bIsExist = [fm fileExistsAtPath:strDstDBPath];
    if (bIsExist)
    {
        return YES;
    }
    NSError* err;
    if (![fm copyItemAtPath:strSrcDBPath toPath:strDstDBPath error:&err])
    {
        NSLog(@"Failed to create writable database %@,%@", kDatabase_pub, err.localizedFailureReason);
        return NO;
    }
    return YES;
}


-(BOOL)QueryDataIsExists:(NSString *)nsSql DataNum:(UNDWORD)num
{
    DataBaseParam *dbParam = [[DataBaseParam alloc] init];
    dbParam.nsSqlText = nsSql;
    [dbParam AddParamInt64:num];
    
    STATEMENT *stmt = [m_database PrepareSQLByParam:dbParam];
    
    BOOL bFlag = YES;
    if(!stmt || ![m_database GetNextColumn:stmt])
    {
        bFlag = NO;
        [m_database FinishColumn:stmt];
        [dbParam release];
        return bFlag;
    }
    
    [m_database FinishColumn:stmt];
    [dbParam release];
    
    return bFlag;
}

-(BOOL)QueryDataIsExists:(NSString *)nsSql DataNum1:(UNDWORD)num1 DataNum2:(UNDWORD)num2
{
    DataBaseParam *dbParam = [[DataBaseParam alloc] init];
    dbParam.nsSqlText = nsSql;
    [dbParam AddParamInt64:num1];
    [dbParam AddParamInt64:num2];
    
    STATEMENT *stmt = [m_database PrepareSQLByParam:dbParam]; [NSString stringWithFormat:@"%@", @"" ];
    
    BOOL bFlag = YES;
    if(!stmt || ![m_database GetNextColumn:stmt])
    {
        bFlag = NO;
        [m_database FinishColumn:stmt];
        [dbParam release];
        return bFlag;
    }
    
    [m_database FinishColumn:stmt];
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

-(BOOL)QueryDataIsExistStr:(NSString *)nsSql DataStr1:(NSString*)str1 DataStr2:(NSString*)str2
{
    DataBaseParam *dbParam = [[DataBaseParam alloc] init];
    dbParam.nsSqlText = nsSql;
    [dbParam AddParamText:str1];
    [dbParam AddParamText:str2];
    
    STATEMENT *stmt = [m_database PrepareSQLByParam:dbParam];
    
    BOOL bFlag = YES;
    if(!stmt || ![m_database GetNextColumn:stmt])
    {
        bFlag = NO;
        [m_database FinishColumn:stmt];
        [dbParam release];
        return bFlag;
    }
    
    [m_database FinishColumn:stmt];
    [dbParam release];
    
    return bFlag;
}

#pragma mark -获取省份列表
- (NSDictionary *)getProvinceList
{
    if (!m_bIsDataBaseOpen) return nil;
    
    NSString *query = @"select provinceid, provincename from table_province;";
    NSMutableDictionary* dictProvince = nil;
    STATEMENT * pStatement = [m_database PrepareSQL:query];
    if (pStatement != NULL)
    {
        dictProvince = [[[NSMutableDictionary alloc] init] autorelease];
        while([m_database GetNextColumn:pStatement])
        {
            NSString * tmpid = [[NSNumber numberWithLongLong:[m_database GetColumnInt64:pStatement]] stringValue];
            NSString * tmpValue = [m_database GetColumnText:pStatement];
            [dictProvince setValue:tmpid forKey:tmpValue];
        }
        [m_database FinishColumn:pStatement];
    }
    return dictProvince;
}

//添加设置value
- (BOOL)addSettingValue:(SETID)settingId vaue:(int)value
{
    NSString* nsSql = @"select * from Public_setting_table where settingId = ?";
    DataBaseParam* dbParam = [[DataBaseParam alloc] init];
    
    if(![self QueryDataIsExists:nsSql DataNum:settingId])
    {
        dbParam.nsSqlText = @"insert into Public_setting_table(settingId,value)values(?,?)";
        
        [dbParam AddParamInt:settingId];
        [dbParam AddParamInt:value];
    }
    else
    {
        dbParam.nsSqlText = @"update Public_setting_table set value = ? where settingId= ?";
        
        [dbParam AddParamInt:value];
        [dbParam AddParamInt:settingId];
    }
    
    BOOL bSuccess = [m_database ExecCmdByParam:dbParam];
    
    if(!bSuccess)
    {
        NSLog(@"failed to add user set to local database!\n");
    }
    
    [dbParam release];
    
    return bSuccess;
}

//查询设置value
- (Setting_ID_Values)querySettingValueBySettingId:(SETID)settingId
{
    NSString* query = [NSString stringWithFormat:@"select * from Public_setting_table where settingId = %d",settingId];
    STATEMENT* pStatement = [m_database PrepareSQL:query];
    
    int value = SETTING_VALUES_DEFAULT;
    
    if(pStatement != NULL)
    {
        while ([m_database GetNextColumn:pStatement])
        {
            [m_database GetColumnInt:pStatement];
            [m_database GetColumnInt:pStatement];
            value = [m_database GetColumnInt:pStatement];
        }
        
        [m_database FinishColumn:pStatement];
    }
    
    return value;
    
}


+ (void) deallocData
{
    @synchronized(self)
    {
        if (g_globalData)
        {
            [g_globalData release];
            g_globalData = nil;
        }
    }
}

- (void) dealloc
{
    if (m_bIsDataBaseOpen)
    {
        [m_database CloseDataBase];
        [m_database release];
    }
    
    [super dealloc];
}

@end
