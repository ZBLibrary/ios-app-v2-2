//
//  PubDatabase.h
//  BlackRoom
//
//  Created by Mac Mini 1 on 15-1-9.
//  Copyright (c) 2014年 sunlinlin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Database.h"

@interface PubDatabase : NSObject

+ (PubDatabase*) sharedGlobalData;
- (BOOL)queryFormNameIsExists;
//查询产品表是否存在
- (BOOL)queryProductTable;
+ (void) deallocData;

//获取省份列表
- (NSDictionary *)getProvinceList;
//获取指定省份的城市列表
- (NSDictionary *)getCityList:(UNDWORD)provinceid;
//添加设置value
- (BOOL)addSettingValue:(SETID)settingId vaue:(int)value;
//查询设置value
- (Setting_ID_Values)querySettingValueBySettingId:(SETID)settingId;
//查询数据库版本信息
- (NSMutableArray*)queryDataBaseVersion:(int)settingId;
@end
