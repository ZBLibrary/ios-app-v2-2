//
//  VersionSettingDBManager.h
//  VirtualLovers
//
//  Created by Mac Mini 1 on 15/10/13.
//  Copyright (c) 2015年 sunlinlin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VersionSettingDBManager : NSObject

//添加设置value
- (BOOL)addSettingValue:(int)settingId vaue:(UNDWORD)value;
//查询设置value
- (UNDWORD)querySettingValueBySettingId:(int)settingId;
//查询设置表是否存在
- (BOOL)querySettingTableIsExit;

//添加wifi
- (BOOL)addWifi:(NSString*)wifiName psw:(NSString*)psw;
//查询wifi
- (NSString*)queryPswByName:(NSString*)name;

@end
