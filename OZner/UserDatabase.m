//
//  UserDatabase.m
//  Persistence
//
//  Created by hupo on 3/30/11.
//  Copyright 2011 deirlym. All rights reserved.
//

#import "UserDatabase.h"

@implementation UserDatabase

- (id) init
{
    if (self = [super init])
    {
        database = nil;
    }    
    return self;
}

+ (UserDatabase*) sharedUserDatabase
{
    static UserDatabase* userDatabase=nil;
    @synchronized(self)
    {
        if (!userDatabase)
        {
            userDatabase = [[self alloc] init];
        }
    }
    
    return userDatabase;
}

- (BOOL) startDBEngineWithDB:(NSString*)strDBFileName
{
    // 关闭已经连接的数据库
    if (database)
    {
        [database CloseDataBase];
        [database release];
        database = nil;
    }
    
    database=[[CDatabase alloc] init];
    
	NSArray * paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
	NSString * documentDirectory=[paths objectAtIndex:0];
	NSString *destDBPath=[documentDirectory stringByAppendingPathComponent:strDBFileName];
	if(![database OpenDatabase:destDBPath])
		return NO;
	
	return YES;
}

- (BOOL) createDBFileInDocument:(NSString*)strDBFileName srcDBFile:(NSString*) strSrcDBFileName versionId:(UNDWORD)versionId
{
    NSFileManager* fm = [NSFileManager defaultManager];
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentDirectory = [paths objectAtIndex:0];
    NSString* strDstDBPath = [documentDirectory stringByAppendingPathComponent:strDBFileName];
    NSString* strSrcDBPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:strSrcDBFileName];
    
    // 如果已存在则不创建，返回成功
    BOOL bIsExist = [fm fileExistsAtPath:strDstDBPath];
    if (bIsExist)
    {
        return NO;
    }
    
    NSError* err;
    if (![fm copyItemAtPath:strSrcDBPath toPath:strDstDBPath error:&err])
    {
        NSLog(@"Failed to create writable database %@,%@", strDBFileName, err.localizedFailureReason);
        return NO;
    }    
    return YES;
}

- (CDatabase*) getConnectedDB
{
    return database;
}

@end

















