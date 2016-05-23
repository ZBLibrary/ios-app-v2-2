//
//  DeviceWerbservice.h
//  OZner
//
//  Created by Mac Mini 1 on 15/12/21.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConnectUtil.h"
#import "StatusManager.h"

@interface DeviceWerbservice : NSObject

//添加设备
- (ASIFormDataRequest*)addDevice:(NSString*)mac name:(NSString*)name deviceType:(NSString*)deveiceType deviceAddress:(NSString*)deviceAddress weight:(NSString*)weight returnBlock:(void(^)(StatusManager* status))handle;
//获取设备列表
- (ASIFormDataRequest*)getDeviceList:(void(^)(StatusManager* status))handle;
//更新设备
- (ASIFormDataRequest*)updateDevice:(NSString*)mac keyArr:(NSArray*)keyArr valueArr:(NSArray*)valueArr returnBlock:(void(^)(StatusManager* status))handle;
//删除设备
- (ASIFormDataRequest*)deleteDevice:(NSString*)mac returnBlock:(void(^)(StatusManager* status))handle;
//获取tds数据
- (ASIFormDataRequest*)tdsSensor:(NSString*)mac type:(NSString*)type tds:(NSString*)tds beforetds:(NSString*)beforetds returnBlock:(void(^)(NSNumber* rank,NSNumber* total, StatusManager* status))handle;
//获取探头滤芯设备服务时间
- (ASIFormDataRequest*)filterService:(NSString*)mac returnBlock:(void(^)(NSString* modifyTime,NSNumber* userDay, StatusManager* status))handle;
//更新滤芯服务时间
- (ASIFormDataRequest*)RenewFilterTime:(NSString*)mac devicetype:(NSString*)devicetype code:(NSString*)code  returnBlock:(void(^)(NSDictionary* Dic,NSString* state, StatusManager* status))handle;
//饮水量传感器
- (ASIFormDataRequest*)volumeSensor:(NSString*)mac type:(NSString*)type volume:(NSString*)volume returnBlock:(void(^)(NSNumber* rank, StatusManager* status))handle;
//获取好友内的饮水量排名详情
- (ASIFormDataRequest*)volumeFriendRank:(void(^)(NSNumber* rank,NSMutableArray* muArr, StatusManager* status))handle;
//获取好友内的TDS排名详情/OznerDevice/TdsFriendRank
- (ASIFormDataRequest*)TdsFriendRank:(NSString*)type returnBlock:(void(^)(NSNumber* rank,NSMutableArray* muArr, StatusManager* status))handle;
//ip定位天气信息
- (ASIFormDataRequest*)getWeather:(NSString*)cityName returnBlock:(void(^)(NSString*pollution,NSString* cityname,NSString* PM25,NSString* AQI,NSString* temperature,NSString* humidity,NSString* dataFrom,StatusManager* status))handle;
//获取水机周月TDS分布
- (ASIFormDataRequest*)GetDeviceTdsFenBu:(NSString*)mac returnBlock:(void(^)(NSArray* weekRecord,NSArray* monthRecord,StatusManager* status))handle;
//获取水机滤芯服务到期时间
- (ASIFormDataRequest*)GetMachineLifeOutTime:(NSString*)mac  returnBlock:(void(^)(NSString* endTime,NSString* nowTime, StatusManager* status))handle;
//检查水机的功能种类
- (ASIFormDataRequest*)GetMachineType:(NSString*)type returnBlock:(void(^)(NSString* IsShowScan,NSString* MachineType,NSString* Attr,NSString* BuyUrl,NSString* days, StatusManager* status))handle;

//更新补水仪的数值  /OznerDevice/UpdateBuShuiYiNumber Face ，Eyes ,Hands, Neck
- (ASIFormDataRequest*)UpdateBuShuiYiNumber:(NSString*)mac ynumber:(NSString*)ynumber snumber:(NSString*)snumber action:(NSString*)action returnBlock:(void(^)(StatusManager* status))handle;

//获取周月补水仪器数值分布  /OznerServer/GetBuShuiFenBu Face ，Eyes ,Hands, Neck
- (ASIFormDataRequest*)GetBuShuiFenBu:(NSString*)mac action:(NSString*)action returnBlock:(void(^)(id Attr, StatusManager* status))handle;
//GetPost/OznerDevice/GetTimesCountBuShui获取补水仪检测次数
- (ASIFormDataRequest*)GetTimesCountBuShui:(NSString*)mac  returnBlock:(void(^)(NSDictionary * Times, StatusManager* status))handle;
@end
