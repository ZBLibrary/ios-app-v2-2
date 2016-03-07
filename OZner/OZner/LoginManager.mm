//
//  LoginManager.m
//  UMarket
//
//  Created by 孙 林林 on 13-8-22.
//  Copyright (c) 2013年 王 家振. All rights reserved.
//

#import "LoginManager.h"

static LoginManager* g_LoginManager = nil;

@implementation LoginManager
@synthesize loginInfo = mLoginInfo;
@synthesize keyWordArr;
@synthesize isEnterBackGround;

+(LoginManager*)loginInstance
{
    if(nil == g_LoginManager)
    {
        g_LoginManager = [[LoginManager alloc] init];
    }
    
    return g_LoginManager;
}

- (id)init
{
    if(self = [super init])
    {
        mLoginInfo = [[LoginUserInfo alloc] init];
        isEnterBackGround = FALSE;
    }
    
    return self;
}

+ (NSArray*)gainKeyWordArr:(NSString*)fileName
{
    NSString* fileContent = [NSString stringWithContentsOfFile:@"sensitivity.txt" usedEncoding:NULL error:NULL];
    
    return [fileContent componentsSeparatedByString:@","];
}


- (NSString *)dataFilePath:(NSString* )uid
{
	NSArray * paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString * docDirectory=nil;
    docDirectory = [[paths objectAtIndex: 0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",ACHIVER_FILE]];
	return docDirectory;
}

-(void)encodeParamObject
{
    if (!self.loginInfo)
    {
        return;
    }
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    [dic setValue:self.loginInfo.sessionToken forKey:keySessionToken];
    [dic setValue:self.loginInfo.password forKey:keyPassword];
    [dic setValue:self.loginInfo.loginName forKey:keyLoginName];
    [dic setValue:self.loginInfo.displayName forKey:keyDisplayName];
    [dic setValue:self.loginInfo.userID forKey:keyUserID];
    [dic setValue:self.loginInfo.avatarUrl forKey:keyAvataurl];
    [dic setValue:self.loginInfo.gender forKey:keyGender];
    [NSKeyedArchiver archiveRootObject:dic toFile:[self dataFilePath:self.loginInfo.loginName]];
    
	[dic release];
}

-(void)decodeParamObject
{
    NSString * filePath=[self dataFilePath:self.loginInfo.loginName];
	if(![[NSFileManager defaultManager] fileExistsAtPath:filePath])
	{
        return;
    }
    
    NSMutableDictionary* dic = [NSKeyedUnarchiver unarchiveObjectWithFile:[self dataFilePath:mLoginInfo.loginName]];
    
    self.loginInfo.sessionToken = [dic objectForKey:keySessionToken];
    self.loginInfo.loginName = [dic objectForKey:keyLoginName];
    self.loginInfo.password = [dic objectForKey:keyPassword];
    self.loginInfo.displayName = [dic objectForKey:keyDisplayName];
    self.loginInfo.userID = [dic objectForKey:keyUserID];
    self.loginInfo.avatarUrl = [dic objectForKey:keyAvataurl];
    self.loginInfo.gender = [dic objectForKey:keyGender];
}

- (void)dealloc
{
    self.loginInfo = nil;

    [super dealloc];
}


@end
