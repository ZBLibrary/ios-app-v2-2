//
//  UserDatabase.h
//  Persistence
//
//  Created by hupo on 3/30/11.
//  Copyright 2011 deirlym. All rights reserved.
//

#import "Database.h"
#import "TypeDef.h"
#import "GlobalDef.h"

@class CDatabase;

@interface UserDatabase : NSObject 
{
	CDatabase			*database;
}

@property (nonatomic, retain) NSString* userId;

// 创建
+ (UserDatabase*) sharedUserDatabase;

// 开启数据库
- (BOOL) startDBEngineWithDB:(NSString*)strDBFileName;

// 拷贝数据库
- (BOOL)createDBFileInDocument:(NSString*)strDBFileName srcDBFile:(NSString*) strSrcDBFileName versionId:(UNDWORD)versionId;

// 获取连接的数据库
- (CDatabase*) getConnectedDB;

@end