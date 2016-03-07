//
//  UserInfoDBManager.m
//  OZner
//
//  Created by Mac Mini 1 on 15/12/26.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

#import "UserInfoDBManager.h"
#import "UserDatabase.h"

@implementation UserInfoDBManager

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

//添加用户头像昵称信息
- (BOOL)addUserNickImgInfo:(UserNickImgInfo*)userInfo
{
    CDatabase* database = [[UserDatabase sharedUserDatabase] getConnectedDB];
    NSString* nsSql = @"select * from user_nick_img_table where mobile = ? ";
    
    DataBaseParam* dbParam = [[DataBaseParam alloc] init];
    NSString* mobile = userInfo.mobile;
    
    if([self isNilOrNSNull:userInfo.mobile])
    {
        mobile = @"";
    }
    
    if(![self QueryDataIsExistOneStr:nsSql DataStr1:userInfo.mobile])
    {
        dbParam.nsSqlText = @"insert into user_nick_img_table(mobile,nickName,headImg,score,status) values(?,?,?,?,?)";
        
        [dbParam AddParamText:mobile];
        
        if([self isNilOrNSNull:userInfo.nickName])
        {
            [dbParam AddParamText:@""];
        }
        else
        {
            [dbParam AddParamText:userInfo.nickName];
        }
        
        if([self isNilOrNSNull:userInfo.headImg])
        {
            [dbParam AddParamText:@""];
        }
        else
        {
            [dbParam AddParamText:userInfo.headImg];
        }
        
        if([self isNilOrNSNull:userInfo.score])
        {
            [dbParam AddParamText:@""];
        }
        else
        {
            [dbParam AddParamText:userInfo.score];
        }
        
        if([self isNilOrNSNull:userInfo.status])
        {
            [dbParam AddParamText:@""];
        }
        else
        {
            [dbParam AddParamText:userInfo.status];
        }
    }
    else
    {
        dbParam.nsSqlText = @"update user_nick_img_table set nickName = ?,headImg = ?,score = ?,status = ? where mobile = ?";
        
        if([self isNilOrNSNull:userInfo.nickName])
        {
            [dbParam AddParamText:@""];
        }
        else
        {
            [dbParam AddParamText:userInfo.nickName];
        }
        
        if([self isNilOrNSNull:userInfo.headImg])
        {
            [dbParam AddParamText:@""];
        }
        else
        {
            [dbParam AddParamText:userInfo.headImg];
        }
        
        if([self isNilOrNSNull:userInfo.score])
        {
            [dbParam AddParamText:@""];
        }
        else
        {
            [dbParam AddParamText:userInfo.score];
        }
        
        if([self isNilOrNSNull:userInfo.status])
        {
            [dbParam AddParamText:@""];
        }
        else
        {
            [dbParam AddParamText:userInfo.status];
        }
        
        [dbParam AddParamText:mobile];
    }
    
    BOOL bSuccess = [database ExecCmdByParam:dbParam];
    if(!bSuccess)
    {
        NSLog(@"add user_nick_img_table failed.....\n");
    }
    
    [dbParam release];
    
    return bSuccess;
}

- (BOOL)addUserInfo:(UserInfo *)userInfo
{
    CDatabase* database = [[UserDatabase sharedUserDatabase] getConnectedDB];
    NSString* nsSql = @"select * from userInfo_table where userId = ? ";
    
    DataBaseParam* dbParam = [[DataBaseParam alloc] init];
    NSString* userId = userInfo.userId;
    
    if([self isNilOrNSNull:userInfo.userId])
    {
        userId = @" ";
    }
    
    if(![self QueryDataIsExistOneStr:nsSql DataStr1:userInfo.userId])
    {
        dbParam.nsSqlText = @"insert into userInfo_table(userId,clientId,mobile,passWord,nickName,sex,birthday,height,weight,imgpath,isEaseSweat,isBind,userTalkCode,deviceInfo,version,disabled,createBy,createTime,modifyBy,modifyTime,language,area,email,friendSupport,ucode,lktMemberUcode,isRecomment,recommentVol) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
        
        [dbParam AddParamText:userId];
        
        if([self isNilOrNSNull:userInfo.clientId])
        {
            [dbParam AddParamText:@""];
        }
        else
        {
            [dbParam AddParamText:userInfo.clientId];
        }
        
        if([self isNilOrNSNull:userInfo.mobile])
        {
            [dbParam AddParamText:@""];
        }
        else
        {
            [dbParam AddParamText:userInfo.mobile];
        }
        
        if([self isNilOrNSNull:userInfo.passWord])
        {
            [dbParam AddParamText:@""];
        }
        else
        {
            [dbParam AddParamText:userInfo.passWord];
        }
        
        if([self isNilOrNSNull:userInfo.nickName])
        {
            [dbParam AddParamText:@""];
        }
        else
        {
            [dbParam AddParamText:userInfo.nickName];
        }
        
        if([self isNilOrNSNull:userInfo.sex])
        {
            [dbParam AddParamText:@""];
        }
        else
        {
            [dbParam AddParamText:userInfo.sex];
        }
        
        if([self isNilOrNSNull:userInfo.birthday])
        {
            [dbParam AddParamText:@""];
        }
        else
        {
            [dbParam AddParamText:userInfo.birthday];
        }
        
        if([self isNilOrNSNull:userInfo.height])
        {
            [dbParam AddParamText:@""];
        }
        else
        {
            [dbParam AddParamText:userInfo.height];
        }
        
        if([self isNilOrNSNull:userInfo.weight])
        {
            [dbParam AddParamText:@""];
        }
        else
        {
            [dbParam AddParamText:userInfo.weight];
        }
        
        if([self isNilOrNSNull:userInfo.imgpath])
        {
            [dbParam AddParamText:@""];
        }
        else
        {
            [dbParam AddParamText:userInfo.imgpath];
        }
        
        if([self isNilOrNSNull:userInfo.isEaseSweat])
        {
            [dbParam AddParamText:@""];
        }
        else
        {
            [dbParam AddParamText:userInfo.isEaseSweat];
        }
        
        if([self isNilOrNSNull:userInfo.isBind])
        {
            [dbParam AddParamText:@""];
        }
        else
        {
            [dbParam AddParamText:userInfo.isBind];
        }
        
        if([self isNilOrNSNull:userInfo.userTalkCode])
        {
            [dbParam AddParamText:@""];
        }
        else
        {
            [dbParam AddParamText:userInfo.userTalkCode];
        }
        
        if([self isNilOrNSNull:userInfo.deviceInfo])
        {
            [dbParam AddParamText:@""];
        }
        else
        {
            [dbParam AddParamText:userInfo.deviceInfo];
        }
        
        if([self isNilOrNSNull:userInfo.version])
        {
            [dbParam AddParamText:@""];
        }
        else
        {
            [dbParam AddParamText:userInfo.version];
        }
        
        if([self isNilOrNSNull:userInfo.disabled])
        {
            [dbParam AddParamText:@""];
        }
        else
        {
            [dbParam AddParamText:userInfo.disabled];
        }
        
        if([self isNilOrNSNull:userInfo.createBy])
        {
            [dbParam AddParamText:@""];
        }
        else
        {
            [dbParam AddParamText:userInfo.createBy];
        }
        
        if([self isNilOrNSNull:userInfo.createTime])
        {
            [dbParam AddParamText:@""];
        }
        else
        {
            [dbParam AddParamText:userInfo.createTime];
        }
        
        if([self isNilOrNSNull:userInfo.modifyBy])
        {
            [dbParam AddParamText:@""];
        }
        else
        {
            [dbParam AddParamText:userInfo.modifyBy];
        }
        
        if([self isNilOrNSNull:userInfo.modifyTime])
        {
            [dbParam AddParamText:@""];
        }
        else
        {
            [dbParam AddParamText:userInfo.modifyTime];
        }
        
        if([self isNilOrNSNull:userInfo.language])
        {
            [dbParam AddParamText:@""];
        }
        else
        {
            [dbParam AddParamText:userInfo.language];
        }
        
        if([self isNilOrNSNull:userInfo.area])
        {
            [dbParam AddParamText:@""];
        }
        else
        {
            [dbParam AddParamText:userInfo.area];
        }
        
        if([self isNilOrNSNull:userInfo.email])
        {
            [dbParam AddParamText:@""];
        }
        else
        {
            [dbParam AddParamText:userInfo.email];
        }
        
        if([self isNilOrNSNull:userInfo.friendSupport])
        {
            [dbParam AddParamText:@""];
        }
        else
        {
            [dbParam AddParamText:userInfo.friendSupport];
        }
        
        if([self isNilOrNSNull:userInfo.ucode])
        {
            [dbParam AddParamText:@""];
        }
        else
        {
            [dbParam AddParamText:userInfo.ucode];
        }
        
        if([self isNilOrNSNull:userInfo.lktMemberUcode])
        {
            [dbParam AddParamText:@""];
        }
        else
        {
            [dbParam AddParamText:userInfo.lktMemberUcode];
        }
        
        if([self isNilOrNSNull:userInfo.isRecomment])
        {
            [dbParam AddParamText:@""];
        }
        else
        {
            [dbParam AddParamText:userInfo.isRecomment];
        }
        
        if([self isNilOrNSNull:userInfo.recommentVol])
        {
            [dbParam AddParamText:@""];
        }
        else
        {
            [dbParam AddParamText:userInfo.recommentVol];
        }
    }
    else
    {
        dbParam.nsSqlText = @"update userInfo_table set clientId = ?,mobile = ?,passWord = ?,nickName = ?,sex = ?,birthday = ?,height = ?,weight = ?,imgpath = ?,isEaseSweat = ?,isBind = ?,userTalkCode = ?,deviceInfo = ?,version = ?,disabled = ?,createBy = ?,createTime = ?,modifyBy = ?,modifyTime = ?,language = ?,area = ?,email = ?,friendSupport = ?,ucode = ?,lktMemberUcode = ?,isRecomment = ?,recommentVol = ? where userId = ?";
        
        if([self isNilOrNSNull:userInfo.clientId])
        {
            [dbParam AddParamText:@""];
        }
        else
        {
            [dbParam AddParamText:userInfo.clientId];
        }
        
        if([self isNilOrNSNull:userInfo.mobile])
        {
            [dbParam AddParamText:@""];
        }
        else
        {
            [dbParam AddParamText:userInfo.mobile];
        }
        
        if([self isNilOrNSNull:userInfo.passWord])
        {
            [dbParam AddParamText:@""];
        }
        else
        {
            [dbParam AddParamText:userInfo.passWord];
        }
        
        if([self isNilOrNSNull:userInfo.nickName])
        {
            [dbParam AddParamText:@""];
        }
        else
        {
            [dbParam AddParamText:userInfo.nickName];
        }
        
        if([self isNilOrNSNull:userInfo.sex])
        {
            [dbParam AddParamText:@""];
        }
        else
        {
            [dbParam AddParamText:userInfo.sex];
        }
        
        if([self isNilOrNSNull:userInfo.birthday])
        {
            [dbParam AddParamText:@""];
        }
        else
        {
            [dbParam AddParamText:userInfo.birthday];
        }
        
        if([self isNilOrNSNull:userInfo.height])
        {
            [dbParam AddParamText:@""];
        }
        else
        {
            [dbParam AddParamText:userInfo.height];
        }
        
        if([self isNilOrNSNull:userInfo.weight])
        {
            [dbParam AddParamText:@""];
        }
        else
        {
            [dbParam AddParamText:userInfo.weight];
        }
        
        if([self isNilOrNSNull:userInfo.imgpath])
        {
            [dbParam AddParamText:@""];
        }
        else
        {
            [dbParam AddParamText:userInfo.imgpath];
        }
        
        if([self isNilOrNSNull:userInfo.isEaseSweat])
        {
            [dbParam AddParamText:@""];
        }
        else
        {
            [dbParam AddParamText:userInfo.isEaseSweat];
        }
        
        if([self isNilOrNSNull:userInfo.isBind])
        {
            [dbParam AddParamText:@""];
        }
        else
        {
            [dbParam AddParamText:userInfo.isBind];
        }
        
        if([self isNilOrNSNull:userInfo.userTalkCode])
        {
            [dbParam AddParamText:@""];
        }
        else
        {
            [dbParam AddParamText:userInfo.userTalkCode];
        }
        
        if([self isNilOrNSNull:userInfo.deviceInfo])
        {
            [dbParam AddParamText:@""];
        }
        else
        {
            [dbParam AddParamText:userInfo.deviceInfo];
        }
        
        if([self isNilOrNSNull:userInfo.version])
        {
            [dbParam AddParamText:@""];
        }
        else
        {
            [dbParam AddParamText:userInfo.version];
        }
        
        if([self isNilOrNSNull:userInfo.disabled])
        {
            [dbParam AddParamText:@""];
        }
        else
        {
            [dbParam AddParamText:userInfo.disabled];
        }
        
        if([self isNilOrNSNull:userInfo.createBy])
        {
            [dbParam AddParamText:@""];
        }
        else
        {
            [dbParam AddParamText:userInfo.createBy];
        }
        
        if([self isNilOrNSNull:userInfo.createTime])
        {
            [dbParam AddParamText:@""];
        }
        else
        {
            [dbParam AddParamText:userInfo.createTime];
        }
        
        if([self isNilOrNSNull:userInfo.modifyBy])
        {
            [dbParam AddParamText:@""];
        }
        else
        {
            [dbParam AddParamText:userInfo.modifyBy];
        }
        
        if([self isNilOrNSNull:userInfo.modifyTime])
        {
            [dbParam AddParamText:@""];
        }
        else
        {
            [dbParam AddParamText:userInfo.modifyTime];
        }
        
        if([self isNilOrNSNull:userInfo.language])
        {
            [dbParam AddParamText:@""];
        }
        else
        {
            [dbParam AddParamText:userInfo.language];
        }
        
        if([self isNilOrNSNull:userInfo.area])
        {
            [dbParam AddParamText:@""];
        }
        else
        {
            [dbParam AddParamText:userInfo.area];
        }
        
        if([self isNilOrNSNull:userInfo.email])
        {
            [dbParam AddParamText:@""];
        }
        else
        {
            [dbParam AddParamText:userInfo.email];
        }
        
        if([self isNilOrNSNull:userInfo.friendSupport])
        {
            [dbParam AddParamText:@""];
        }
        else
        {
            [dbParam AddParamText:userInfo.friendSupport];
        }
        
        if([self isNilOrNSNull:userInfo.ucode])
        {
            [dbParam AddParamText:@""];
        }
        else
        {
            [dbParam AddParamText:userInfo.ucode];
        }
        
        if([self isNilOrNSNull:userInfo.lktMemberUcode])
        {
            [dbParam AddParamText:@""];
        }
        else
        {
            [dbParam AddParamText:userInfo.lktMemberUcode];
        }
        
        if([self isNilOrNSNull:userInfo.isRecomment])
        {
            [dbParam AddParamText:@""];
        }
        else
        {
            [dbParam AddParamText:userInfo.isRecomment];
        }
        
        if([self isNilOrNSNull:userInfo.recommentVol])
        {
            [dbParam AddParamText:@""];
        }
        else
        {
            [dbParam AddParamText:userInfo.recommentVol];
        }
        
        [dbParam AddParamText:userId];

    }
    
    BOOL bSuccess = [database ExecCmdByParam:dbParam];
    if(!bSuccess)
    {
        NSLog(@"failed to add userInfo_table....\n");
    }
    
    [dbParam release];
    
    return bSuccess;
}

//根据mobile查询用户头像昵称信息
- (UserNickImgInfo*)queryUserNickImgInfoByMobile:(NSString*)mobile
{
    CDatabase* database = [[UserDatabase sharedUserDatabase] getConnectedDB];
    NSString* query = [NSString stringWithFormat:@"select id,mobile,nickName,headImg,score,status from userInfo_table where mobile = %@",mobile];
    STATEMENT* pStatement = [database PrepareSQL:query];
    
    UserNickImgInfo* info = nil;
    
    if(pStatement != NULL)
    {
        while ([database GetNextColumn:pStatement])
        {
            info = [[[UserNickImgInfo alloc] init] autorelease];
            info._id = [database GetColumnInt64:pStatement];
            info.mobile = [database GetColumnText:pStatement];
            info.nickName = [database GetColumnText:pStatement];
            info.headImg = [database GetColumnText:pStatement];
            info.score = [database GetColumnText:pStatement];
            info.status = [database GetColumnText:pStatement];
        }
        [database FinishColumn:pStatement];
    }
    return info;
}

//根据userId查询用户信息
- (UserInfo*)queryUserInfoByUserId:(NSString*)userId
{
    CDatabase* database = [[UserDatabase sharedUserDatabase] getConnectedDB];
    NSString* query = [NSString stringWithFormat:@"select id,userId,clientId,mobile,passWord,nickName,sex,birthday,height,weight,imgpath,isEaseSweat,isBind,userTalkCode,deviceInfo,version,disabled,createBy,createTime,modifyBy,modifyTime,language,area,email,friendSupport,ucode,lktMemberUcode,isRecomment,recommentVol from userInfo_table where userId = %@",userId];
    STATEMENT* pStatement = [database PrepareSQL:query];
    
    UserInfo* info = nil;
    
    if(pStatement != NULL)
    {
        while ([database GetNextColumn:pStatement])
        {
            info = [[[UserInfo alloc] init] autorelease];
            info._id = [database GetColumnInt64:pStatement];
            info.userId = [database GetColumnText:pStatement];
            info.clientId = [database GetColumnText:pStatement];
            info.mobile = [database GetColumnText:pStatement];
            info.passWord = [database GetColumnText:pStatement];
            info.nickName = [database GetColumnText:pStatement];
            info.sex = [database GetColumnText:pStatement];
            info.birthday = [database GetColumnText:pStatement];
            info.height = [database GetColumnText:pStatement];
            info.weight = [database GetColumnText:pStatement];
            info.imgpath = [database GetColumnText:pStatement];
            info.isEaseSweat = [database GetColumnText:pStatement];
            info.isBind = [database GetColumnText:pStatement];
            info.userTalkCode = [database GetColumnText:pStatement];
            info.deviceInfo = [database GetColumnText:pStatement];
            info.version = [database GetColumnText:pStatement];
            info.disabled = [database GetColumnText:pStatement];
            info.createBy = [database GetColumnText:pStatement];
            info.createTime = [database GetColumnText:pStatement];
            info.modifyBy = [database GetColumnText:pStatement];
            info.modifyTime = [database GetColumnText:pStatement];
            info.language = [database GetColumnText:pStatement];
            info.area = [database GetColumnText:pStatement];
            info.email = [database GetColumnText:pStatement];
            info.friendSupport = [database GetColumnText:pStatement];
            info.ucode = [database GetColumnText:pStatement];
            info.lktMemberUcode = [database GetColumnText:pStatement];
            info.isRecomment = [database GetColumnText:pStatement];
            info.recommentVol = [database GetColumnText:pStatement];
            
        }
        [database FinishColumn:pStatement];
    }
    return info;
}


@end
